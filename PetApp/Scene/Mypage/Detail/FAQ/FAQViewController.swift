//
//  FAQViewController.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FAQViewController: BaseViewController {
    private var tableView = UITableView()
    private let viewModel: FAQViewModel
    private var disposeBag = DisposeBag()
    
    weak var coordinator: MyPageCoordinator?
    init(viewModel: FAQViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        let input = FAQViewModel.Input()
        let output = viewModel.transform(input)
        
        output.data
            .drive(tableView.rx.items(cellIdentifier: FAQTableViewCell.id, cellType: FAQTableViewCell.self)) { row, element, cell in
                cell.configure(question: element.question, answer: element.answer)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = .white
        title = "자주 묻는 질문 📝"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: FAQTableViewCell.id)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
}
