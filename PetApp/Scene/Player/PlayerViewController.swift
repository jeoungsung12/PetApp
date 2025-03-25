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
                
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configureView() {
        tableView.separatorStyle = .none
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
