//
//  DetailViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailViewController: BaseViewController {
    private let loadingIndicator = UIActivityIndicatorView()
    private let tableView = UITableView()
    
    private var disposeBag = DisposeBag()
    private var viewModel: DetailViewModel
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let input = DetailViewModel.Input(
            
        )
        let output = viewModel.transform(input)
        loadingIndicator.startAnimating()
        
        let dataSource = RxTableViewSectionedReloadDataSource<DetailSection> { dataSource, tableView, indexPath, item in
            
            switch DetailSectionType.allCases[indexPath.section] {
            case .header:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderCell.id, for: indexPath) as? DetailHeaderCell else { return UITableViewCell() }
                cell.configure()
                return cell
                
            case .middle:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailMiddleCell.id, for: indexPath) as? DetailMiddleCell else { return UITableViewCell() }
                cell.configure()
                return cell
                
            case .footer:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailFooterCell.id, for: indexPath) as? DetailFooterCell else { return UITableViewCell() }
                cell.configure()
                return cell
            }
        }
        
        let result = output.detailResult
        
        result
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, sectionArray in
                owner.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [tableView, loadingIndicator].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.horizontalEdges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        setNavigation()
        view.backgroundColor = .customWhite
        loadingIndicator.style = .medium
        loadingIndicator.color = .customLightGray
        configureTableView()
    }
}

extension DetailViewController {
    
    private func configureTableView() {
        tableView.backgroundColor = .customWhite
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DetailHeaderCell.self, forCellReuseIdentifier: DetailHeaderCell.id)
        tableView.register(DetailMiddleCell.self, forCellReuseIdentifier: DetailMiddleCell.id)
        tableView.register(DetailFooterCell.self, forCellReuseIdentifier: DetailFooterCell.id)
    }
}
