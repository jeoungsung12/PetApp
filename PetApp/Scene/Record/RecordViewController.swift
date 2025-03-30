//
//  RecordViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RecordViewController: BaseViewController {
    private let imageView = UIImageView()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    //TODO: 드롭다운
    private let writeButton = IconLabelButton()
    
    private let viewModel = RecordViewModel()
    private var disposeBag = DisposeBag()
    
    override func setBinding() {
        let input = RecordViewModel.Input(
            loadTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        
        writeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(WriteViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        let result = output.recordResult
        
        result
            .drive(tableView.rx.items(cellIdentifier: RecordTableViewCell.id, cellType: RecordTableViewCell.self)) { row, element, cell in
                cell.configure(element)
            }
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, data in
                owner.imageView.isHidden = !data.isEmpty
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configureView() {
        self.setNavigation(logo: true)
        self.view.backgroundColor = .customWhite
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색어를 입력하세요!"
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "recordBackDrop")
        
        writeButton.configure(image: .pencilImage, title: "글쓰기", color: .point)
        configureTableView()
    }
    
    override func configureHierarchy() {
        [searchBar, tableView, writeButton, imageView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        writeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(100)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension RecordViewController {
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.id)
    }
}
