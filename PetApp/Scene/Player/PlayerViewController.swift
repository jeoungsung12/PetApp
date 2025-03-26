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
        let input = PlayerViewModel.Input(loadTrigger: Observable.just(()))
        let output = viewModel.transform(input)
        
        let result = output.videoResult
        
        result
            .drive(tableView.rx.items(cellIdentifier: PlayerTableViewCell.id, cellType: PlayerTableViewCell.self)) { row, element, cell in
                cell.selectionStyle = .none
                cell.configure(element)
            }
            .disposed(by: disposeBag)
        
//        tableView.rx.willDisplayCell
//            .bind(with: self, onNext: { owner, event in
//                guard let cell = event.cell as? PlayerTableViewCell else { return }
//                cell.playVideo()
//            })
//            .disposed(by: disposeBag)
//          
//        
//        tableView.rx.didEndDisplayingCell
//            .bind(with: self, onNext: { owner, event in
//                guard let cell = event.cell as? PlayerTableViewCell else { return }
//                cell.stopVideo()
//            })
//            .disposed(by: disposeBag)
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
