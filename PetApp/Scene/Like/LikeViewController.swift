//
//  LikeViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LikeViewController: BaseViewController {
    private let tableView = UITableView()
    private let viewModel = LikeViewModel()
    private let input = LikeViewModel.Input(
        loadTrigger: PublishRelay()
    )
    private var disposeBag = DisposeBag()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.loadTrigger.accept(())
    }
    
    override func setBinding() {
        let output = viewModel.transform(input)
        input.loadTrigger.accept(())
        
        let result = output.likeResult.asDriver()
        
        result
            .drive(tableView.rx.items(cellIdentifier: LikeTableViewCell.id, cellType: LikeTableViewCell.self)) { row, element, cell in
                cell.configure(element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HomeEntity.self)
            .bind(with: self) { owner, entity in
                let vm = DetailViewModel(model: entity)
                let vc = DetailViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.register(LikeTableViewCell.self, forCellReuseIdentifier: LikeTableViewCell.id)
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
