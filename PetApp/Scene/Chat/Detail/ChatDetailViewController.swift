//
//  ChatDetailViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ChatDetailViewController: BaseViewController {
    private let containerView = UIView()
    private let tableView = UITableView()
    private let keyboardView = ChatKeyboardView()
    private lazy var tabGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    private let viewModel: ChatDetailViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: ChatDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.keyboardView.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setBinding() {
        let input = ChatDetailViewModel.Input(
            loadTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        LoadingIndicator.showLoading()
        
        let result = output.chatResult
        
        result
            .drive(tableView.rx.items(cellIdentifier: ChatDetailCell.id, cellType: ChatDetailCell.self)) { row, element, cell in
                cell.configure(element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, entity in
                LoadingIndicator.hideLoading()
                owner.tableView.scrollToRow(at: IndexPath(row: entity.count-1, section: 0), at: .top, animated: true)
            }
            .disposed(by: disposeBag)
        
        keyboardView.sendButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let text = owner.keyboardView.textField.text else { return }
                LoadingIndicator.showLoading()
                input.loadTrigger.accept(text)
                owner.keyboardView.textField.text = nil
            }
            .disposed(by: disposeBag)
        
        keyboardView.textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(keyboardView.textField.rx.text)
            .bind(with: self) { owner, text in
                guard let text = owner.keyboardView.textField.text else { return }
                LoadingIndicator.showLoading()
                input.loadTrigger.accept(text)
                owner.keyboardView.textField.text = nil
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        containerView.backgroundColor = .white
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ChatDetailCell.self, forCellReuseIdentifier: ChatDetailCell.id)
    }
    
    override func configureHierarchy() {
        [keyboardView, tableView].forEach {
            containerView.addSubview($0)
        }
        self.view.addSubview(containerView)
        self.view.addGestureRecognizer(tabGesture)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        keyboardView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(keyboardView.snp.top)
            make.top.horizontalEdges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .bind(with: self, onNext: { owner, notification in
                guard let userInfo = notification.userInfo,
                      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
                
                let keyboardHeight = keyboardFrame.height
                UIView.animate(withDuration: duration) {
                    self.keyboardView.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(-keyboardHeight)
                    }
                    self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                    self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .bind(with: self) { owner, notification in
                guard let userInfo = notification.userInfo,
                      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
                
                UIView.animate(withDuration: duration) {
                    self.keyboardView.snp.updateConstraints { make in
                        make.bottom.equalToSuperview()
                    }
                    self.tableView.contentInset = .zero
                    self.tableView.scrollIndicatorInsets = .zero
                    self.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
    }
}
