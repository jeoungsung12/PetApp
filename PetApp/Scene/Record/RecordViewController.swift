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
    private let writeButton = IconLabelButton()
    
    private let viewModel = RecordViewModel()
    private lazy var input = RecordViewModel.Input(
        loadTrigger: PublishRelay(),
        searchText: PublishRelay()
    )
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        input.loadTrigger.accept(())
    }
    
    override func setBinding() {
        let output = viewModel.transform(input)
        
        writeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(WriteViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        let result = output.recordResult
        
        result
            .drive(tableView.rx.items(cellIdentifier: RecordTableViewCell.id, cellType: RecordTableViewCell.self)) { [weak self] row, element, cell in
                cell.delegate = self
                cell.selectionStyle = .none
                cell.configure(element)
            }
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, data in
                owner.imageView.isHidden = !data.isEmpty
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .bind(to: input.searchText)
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setTabBar()
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
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
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

extension RecordViewController: RemoveDelegate {
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.id)
    }
    
    func remove() {
        self.customAlert(
            "게시글 삭제",
            "확인을 누르시면 영구적으로 게시글이 삭제됩니다. 삭제하시겠습니까?",
            [.Ok, .Cancel]
        ) { [weak self] in
            self?.input.loadTrigger.accept(())
        }
    }
}
