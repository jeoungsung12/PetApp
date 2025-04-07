//
//  WriteViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import UIKit
import SnapKit
import YPImagePicker
import Toast
import Photos
import RxSwift
import RxCocoa

final class WriteViewController: BaseViewController {
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    private let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let locationTextField = UITextField()
    private let photoButton = UIButton()
    private let photoIconBtn = UIButton()
    private let titleTextField = UITextField()
    private let spacerView = SeperateView()
    private let descriptionTextView = UITextView()
    private let descriptionLabel = UILabel()
    
    private let viewModel = WriteViewModel()
    private var disposeBag = DisposeBag()
    
    private lazy var picker = YPImagePicker(configuration: self.configurePicker())
    private var selectedImages = BehaviorRelay<[UIImage]>(value: [])
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func setBinding() {
        let input = WriteViewModel.Input(
            saveTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        
        photoButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.requestPhotoLibraryPermission {
                    owner.present(owner.picker, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        photoIconBtn.rx.tap
            .bind(with: self) { owner, _ in
                owner.requestPhotoLibraryPermission {
                    owner.present(owner.picker, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        picker.didFinishPicking { [weak self] items, cancelled in
            guard let self = self else { return }
            
            let images = items.compactMap { item -> UIImage? in
                switch item {
                case .photo(let photo):
                    return photo.image
                default:
                    return nil
                }
            }
            self.selectedImages.accept(images)
            self.dismiss(animated: true)
        }
        
        descriptionTextView.rx.didBeginEditing
            .bind(with: self, onNext: { owner, _ in
                if owner.descriptionTextView.textColor == .customLightGray {
                    owner.descriptionTextView.text = ""
                    owner.descriptionTextView.textColor = .customBlack
                }
            })
            .disposed(by: disposeBag)
        
        descriptionTextView.rx.didEndEditing
            .bind(with: self, onNext: { owner, _ in
                if owner.descriptionTextView.text.isEmpty {
                    owner.descriptionTextView.text = """
                            친구들과 함께 했던 얘기를 자유롭게 얘기해보세요!
                            #봉사활동 #기록 #함께라서 행복 #얼른 가족만나길
                        """
                    owner.descriptionTextView.textColor = .customLightGray
                }
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let location = owner.locationTextField.text , !location.isEmpty,
                      let title = owner.titleTextField.text, !title.isEmpty,
                      let description = owner.descriptionTextView.text, !description.isEmpty,
                      !owner.selectedImages.value.isEmpty else {
                    owner.view.makeToast("모든 항목을 기록해 주세요!", duration: 1, position: .center)
                    return
                }
                
                let record = RecordRealmEntity(
                    location: location,
                    date: .currentDate(),
                    imagePaths: owner.selectedImages.value.compactMap { image in
                        return .saveImage(image: image)
                    },
                    title: title,
                    subTitle: description
                )
                
                input.saveTrigger.accept(record)
            }
            .disposed(by: disposeBag)
        
        output.saveResult
            .drive(with: self) { owner, valid in
                if valid {
                    owner.view.makeToast("저장 성공!", duration: 1, position: .center)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        owner.navigationController?.popViewController(animated: true)
                    }
                } else {
                    owner.view.makeToast("저장에 실패했습니다!", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        let result = selectedImages.asDriver(onErrorJustReturn: [])
        
        result
            .drive(collectionView.rx.items(cellIdentifier: PosterCell.id, cellType: PosterCell.self)) { items, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, images in
                owner.photoIconBtn.isHidden = (images.isEmpty)
                owner.photoButton.isHidden = !(images.isEmpty)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .customWhite
        self.navigationItem.rightBarButtonItem = saveButton
        
        scrollView.keyboardDismissMode = .onDrag
        
        photoButton.contentMode = .scaleAspectFit
        photoButton.setImage(UIImage(named: "bubble"), for: .normal)
        
        photoIconBtn.isHidden = true
        photoIconBtn.tintColor = .black
        photoIconBtn.contentMode = .scaleAspectFit
        photoIconBtn.setImage(.photoImage, for: .normal)
        
        locationTextField.clipsToBounds = true
        locationTextField.layer.cornerRadius = 10
        locationTextField.backgroundColor = .systemGray6
        locationTextField.placeholder = "위치를 입력해 주세요"
        locationTextField.textColor = .customBlack
        locationTextField.font = .largeSemibold
        
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: locationTextField.frame.height))
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: locationTextField.frame.height))
        
        locationTextField.leftView = paddingViewLeft
        locationTextField.rightView = paddingViewRight
        locationTextField.leftViewMode = .always
        locationTextField.rightViewMode = .always
        
        titleTextField.placeholder = "제목을 입력해 주세요"
        titleTextField.textColor = .customBlack
        titleTextField.font = .largeBold
        
        descriptionTextView.textColor = .customLightGray
        descriptionTextView.font = .mediumRegular
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.textContainer.maximumNumberOfLines = 0
        descriptionTextView.textContainer.lineBreakMode = .byWordWrapping
        descriptionTextView.text = """
                                친구들과 함께 했던 얘기를 자유롭게 얘기해보세요!
                                #봉사활동 #기록 #함께라서 행복 #얼른 가족만나길
                                """
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .customLightGray
        descriptionLabel.font = .mediumRegular
        descriptionLabel.textAlignment = .center
        descriptionLabel.text =
                                """
                                동물들과 함께한 오늘, 어떤 순간이 가장 가슴에 남았나요? 
                                혹시 처음 다가온 강아지의 눈빛, 조용히 곁을 내어준 고양이의 따뜻함이 기억나시나요? 봉사활동을 하며 느낀 감정과 생각을 이곳에 기록해보세요. 작은 순간들이 모이면, 나만의 특별한 봉사 다이어리가 완성됩니다. 당신의 진심 어린 기록이 또 다른 사람에게 영감을 줄지도 몰라요. 지금 이 순간을 잊지 않도록 소중히 남겨보세요.
                                """
        
        configureCollectionView()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            locationTextField,
            collectionView,
            photoButton,
            photoIconBtn,
            titleTextField,
            spacerView,
            descriptionTextView,
            descriptionLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        locationTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        photoButton.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(locationTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(locationTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        photoIconBtn.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(24)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(photoIconBtn.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        spacerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(spacerView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    deinit {
        print(#function, self)
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension WriteViewController {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.id)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return layout
    }
    
    private func configurePicker() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.library.maxNumberOfItems = 5
        config.startOnScreen = .library
        config.library.mediaType = .photo
        return config
    }
    
    @objc
    private
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = keyboardFrame.height + 20
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }

    
    private func requestPhotoLibraryPermission(completion: @escaping () -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion()
        case .denied, .restricted:
            let alert = UIAlertController(title: "권한이 필요합니다", message: "앱에서 사진에 접근할 수 있도록 권한을 허용해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "설정으로 가기", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(alert, animated: true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        default:
            break
        }
    }
    
}
