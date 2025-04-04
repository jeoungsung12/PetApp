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
    private let tableView = UITableView()
    private let viewModel = PlayerViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.showLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
                let errorVM = ErrorViewModel(notiType: .player)
                let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
                errorVC.modalPresentationStyle = .overCurrentContext
                owner.present(errorVC, animated: true)
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
        self.view.backgroundColor = .customBlack
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customBlack
        tableView.isPagingEnabled = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = self.view.frame.height - tabBarHeight
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.id)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
