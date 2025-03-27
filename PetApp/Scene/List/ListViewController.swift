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
    private let viewModel = ListViewModel()
    private var disposeBag = DisposeBag()
    
    override func setBinding() {
        let input = ListViewModel.Input(
            loadTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        input.loadTrigger.accept(viewModel.page)
        
        let result = output.homeResult.asDriver()
        
        result
            .drive(tableView.rx.items(cellIdentifier: ListTableViewCell.id, cellType: ListTableViewCell.self)) { row, element, cell in
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
        
        tableView.rx.prefetchRows
            .bind(with: self) { owner, IndexPaths in
                if let lastIndex = IndexPaths.last.map({ $0.row }),
                   (output.homeResult.value.count - 2) < lastIndex
                {
                    //TODO: 캐싱
                    input.loadTrigger.accept(owner.viewModel.page + 1)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.cancelPrefetchingForRows
            .bind(with: self) { owner, indexPaths in
                
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
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
