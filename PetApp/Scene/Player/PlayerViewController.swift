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
    }
    
    override func setBinding() {
        let input = PlayerViewModel.Input(
            loadTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        input.loadTrigger.accept(.init(start: 1, end: 10))
        
        let result = output.videoResult.asDriver(onErrorJustReturn: [])
        
        result
            .drive(tableView.rx.items(cellIdentifier: PlayerTableViewCell.id, cellType: PlayerTableViewCell.self)) { row, element, cell in
                cell.selectionStyle = .none
                cell.configure(element)
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
                    //TODO: 캐싱
                    input.loadTrigger.accept(.init(start: 1 + request.end, end: request.end + 10))
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.cancelPrefetchingForRows
            .bind(with: self) { owner, IndexPaths in
                //TODO: 네트워크 요청 취소
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation(logo: true)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .customWhite
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.id)
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
