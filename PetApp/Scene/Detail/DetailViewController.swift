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
    
    override func setBinding() {
        let input = DetailViewModel.Input(
            
        )
        let output = viewModel.transform(input)
        loadingIndicator.startAnimating()
        
        let dataSource = RxTableViewSectionedReloadDataSource<DetailSection> { dataSource, tableView, indexPath, item in
            
            switch DetailSectionType.allCases[indexPath.section] {
            case .header:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderCell.id, for: indexPath) as? DetailHeaderCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.configure(item.data)
                return cell
                
            case .middle:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailMiddleCell.id, for: indexPath) as? DetailMiddleCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                let vm = DetailMiddleViewModel(entity: item.data)
                vm.delegate = self
                cell.configure(item.data, viewModel: vm)
                return cell
                
            case .footer:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailFooterCell.id, for: indexPath) as? DetailFooterCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.configure(item.data)
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
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        setNavigation(color: .clear)
        self.navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = .customWhite
        loadingIndicator.style = .medium
        loadingIndicator.color = .customLightGray
        configureTableView()
    }
}

extension DetailViewController: ShareDelegate {
    
    func activityShare(_ entity: HomeEntity) {
        //TODO: 앱 링크
        let deepLink = "yourapp://animal/\(entity.animal.id)"
        let shareText = """
            와랄라에서 유기동물을 만나보세요! 🐾
            이름: \(entity.animal.name)
            상태: \(entity.animal.state)
            구조된 장소: \(entity.shelter.discplc)
            성별: \(entity.animal.gender)
            중성화 여부: \(entity.animal.neut)
            새로운 가족을 기다리고 있어요! 💕
            자세히 보기: \(deepLink)
            """
        
        let items: [Any] = [shareText]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customWhite
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DetailHeaderCell.self, forCellReuseIdentifier: DetailHeaderCell.id)
        tableView.register(DetailMiddleCell.self, forCellReuseIdentifier: DetailMiddleCell.id)
        tableView.register(DetailFooterCell.self, forCellReuseIdentifier: DetailFooterCell.id)
    }
    
    
}
