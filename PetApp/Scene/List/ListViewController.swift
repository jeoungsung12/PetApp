//
//  ListViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ListViewController: BaseViewController {
    private let tableView = UITableView()
    private let locationButton = LocationButton()
    private let viewModel: ListViewModel
    private let input = ListViewModel.Input(
        loadTrigger: PublishRelay<ListViewModel.ListRequest>()
    )
    private lazy var output = viewModel.transform(input)
    private var disposeBag = DisposeBag()
    
    weak var homeCoord: HomeCoordinator?
    weak var chatCoord: ChatCoordinator?
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.showLoading()
    }
    
    override func setBinding() {
        LoadingIndicator.showLoading()
        
        let result = output.homeResult.asDriver()
        
        result
            .drive(tableView.rx.items(cellIdentifier: ListTableViewCell.id, cellType: ListTableViewCell.self)) { row, element, cell in
                cell.configure(element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, _ in
                LoadingIndicator.hideLoading()
            }
            .disposed(by: disposeBag)
        
        output.errorResult
            .drive(with: self) { owner, error in
                if let homeCoord = owner.homeCoord {
                    homeCoord.showError(error: error)
                } else if let chatCoord = owner.chatCoord {
                    chatCoord.showError(error: error)
                }
            }
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .bind(with: self) { owner, _ in
                LoadingIndicator.showLoading()
            }
            .disposed(by: disposeBag)
        
        locationButton.rx.tap
            .bind(with: self) {
                owner, _ in
                let entity = owner.locationButton.viewModel.currentLocationEntity.value
                if let homeCoord = owner.homeCoord {
                    homeCoord.showLocation(location: entity)
                } else if let chatCoord = owner.chatCoord {
                    chatCoord.showLocation(location: entity)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HomeEntity.self)
            .bind(with: self) { owner, entity in
                if let homeCoord = owner.homeCoord {
                    homeCoord.showDetail(with: entity)
                } else if let chatCoord = owner.chatCoord {
                    chatCoord.showDetail(with: entity)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .bind(with: self) {
                owner, IndexPaths in
                if let lastIndex = IndexPaths.last.map({ $0.row }),
                   (owner.output.homeResult.value.count - 2) < lastIndex
                {
                    LoadingIndicator.showLoading()
                    owner.input.loadTrigger.accept(
                        .init(page: owner.viewModel.page + 1, location: owner.viewModel.location)
                    )
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.cancelPrefetchingForRows
            .bind(with: self) { owner, indexPaths in
                
            }
            .disposed(by: disposeBag)
        
        locationButton.waitForLocationReady { [weak self] entity in
            guard let self = self else { return }
            self.input.loadTrigger.accept(.init(page: self.viewModel.page, location: entity.location))
        }
        
        if viewModel.homeResult.value.isEmpty {
            input.loadTrigger.accept(.init(page: viewModel.page, location: nil))
        }
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationButton)
        homeCoord?.errorDelegate = self
        homeCoord?.locationDelegate = self
        chatCoord?.errorDelegate = self
        chatCoord?.locationDelegate = self
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 200
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}

extension ListViewController: ErrorDelegate, LocationDelegate {
    
    func reloadLoaction(_ locationEntity: LocationViewModel.LocationEntity) {
        locationButton.configure(locationEntity)
        output.homeResult.accept([])
        viewModel.resetPage()
        input.loadTrigger.accept(.init(page: 1, location: locationEntity.location))
    }
    
    func reloadNetwork(type: ErrorSenderType) {
        input.loadTrigger.accept((.init(page: viewModel.page, location: viewModel.location)))
    }
}
