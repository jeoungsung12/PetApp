//
//  PlayerViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PlayerViewController: BaseViewController {
    private lazy var tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
    private lazy var naviHeight = navigationController?.navigationBar.frame.height ?? 0
    private let tableView = UITableView()
    private let viewModel: PlayerViewModel
    private var disposeBag = DisposeBag()
    
    weak var coordinator: PlayerCoordinator?
    init(viewModel: PlayerViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBar(color: .customBlack)
    }
    
    override func setBinding() {
        let input = PlayerViewModel.Input(
            loadTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        input.loadTrigger.accept(.init(start: 1, end: 10))
        LoadingIndicator.showLoading()
        
        let result = output.videoResult.asDriver(onErrorJustReturn: [])
        
        result
            .drive(tableView.rx.items(cellIdentifier: PlayerTableViewCell.id, cellType: PlayerTableViewCell.self)) { row, element, cell in
                cell.selectionStyle = .none
                cell.configure(element)
            }
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, _ in
                LoadingIndicator.hideLoading()
            }
            .disposed(by: disposeBag)
        
        output.errorResult
            .drive(with: self) { owner, error in
                owner.coordinator?.showError(error: error)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .bind(with: self) { owner, IndexPaths in
                if let lastIndex = IndexPaths.last.map({ $0.row }),
                   let request = owner.viewModel.playerRequest,
                   (output.videoResult.value.count - 2) < lastIndex
                {
                    LoadingIndicator.showLoading()
                    input.loadTrigger.accept(.init(start: 1 + request.end, end: request.end + 10))
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.cancelPrefetchingForRows
            .bind(with: self) { owner, IndexPaths in
                
            }
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .bind(with: self) { owner, cellInfo in
                if let cell = cellInfo.cell as? PlayerTableViewCell {
                    cell.playVideo()
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDisplayingCell
            .bind(with: self) { owner, cellInfo in
                if let cell = cellInfo.cell as? PlayerTableViewCell {
                    cell.stopVideo()
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation(logo: true, color: .customBlack)
        self.view.backgroundColor = .customBlack
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customBlack
        tableView.isPagingEnabled = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = self.view.frame.height - tabBarHeight - naviHeight
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.id)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(naviHeight)
            make.bottom.equalToSuperview().inset(tabBarHeight)
        }
    }
    
    deinit {
        print(#function, self)
    }
}
