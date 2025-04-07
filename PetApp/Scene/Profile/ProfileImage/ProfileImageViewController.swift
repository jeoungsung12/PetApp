//
//  ProfileImageViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol ProfileImageDelegate: AnyObject {
    func returnImage(_ image: String?) -> Void
}

final class ProfileImageViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    private let profileButton = CustomProfileButton(120, true)
    
    weak var profileDelegate: ProfileImageDelegate?
    var profileImage: String?
    
    private let viewModel = ProfileImageViewModel()
    private let inputTrigger = ProfileImageViewModel.Input(backButtonTrigger: PublishSubject())
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inputTrigger.backButtonTrigger.onNext(())
    }
    
    private func setBinding() {
        let output = viewModel.transform(inputTrigger)
        
        output.backButtonResult
            .bind(with: self, onNext: { owner, _ in
                owner.profileDelegate?.returnImage(owner.profileImage)
            }).disposed(by: disposeBag)
    }
    
    private func configureHierarchy() {
        [profileButton, collectionView].forEach({
            self.view.addSubview($0)
        })
    }
    
    private func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(profileButton.snp.bottom).offset(36)
        }
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        
        profileButton.isUserInteractionEnabled = false
        profileButton.profileImage.image = UIImage(named: profileImage ?? "")
        
        configureCollectionView()
    }
}

//MARK: - CollectionView
extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing = 12
        let width = (Int(UIScreen.main.bounds.width) - (spacing * 5)) / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileData.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        let image = ProfileData.allCases[indexPath.row].rawValue
        cell.configure(image)
        cell.profileButton.containerView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        cell.isSelected.toggle()
        profileImage = cell.profileImage
        profileButton.profileImage.image = cell.profileButton.profileImage.image
    }
    
}
