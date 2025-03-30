//
//  WriteViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos

final class WriteViewController: BaseViewController {
    private let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
    //TODO: DropDown
    private let photoButton = UIButton()
    private let titleTextField = UITextField()
    private let spacerView = SeperateView()
    private let descriptionTextView = UITextView()
    private let descriptionLabel = UILabel()
    
    private let viewModel = WriteViewModel()
    private var disposeBag = DisposeBag()
    
    override func setBinding() {
        let input = WriteViewModel.Input()
        let output = viewModel.transform(input)
        
        
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .customWhite
        self.navigationItem.rightBarButtonItem = saveButton
        
        photoButton.contentMode = .scaleAspectFit
        photoButton.setImage(UIImage(named: "bubble"), for: .normal)
        titleTextField.placeholder = "제목을 입력해 주세요"
        titleTextField.textColor = .customBlack
        titleTextField.font = .largeBold
        
        descriptionTextView.textColor = .customBlack
        descriptionTextView.font = .mediumRegular
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .customLightGray
        descriptionLabel.font = .mediumSemibold
        descriptionLabel.text =
                                """
                                동물들과 함께한 오늘, 어떤 순간이 가장 가슴에 남았나요? 
                                혹시 처음 다가온 강아지의 눈빛, 조용히 곁을 내어준 고양이의 따뜻함이 기억나시나요? 봉사활동을 하며 느낀 감정과 생각을 이곳에 기록해보세요. 작은 순간들이 모이면, 나만의 특별한 봉사 다이어리가 완성됩니다. 당신의 진심 어린 기록이 또 다른 사람에게 영감을 줄지도 몰라요. 지금 이 순간을 잊지 않도록 소중히 남겨보세요.
                                """
    }
    
    override func configureHierarchy() {
        [
            photoButton,
            titleTextField,
            spacerView,
            descriptionTextView,
            descriptionLabel
        ].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        photoButton.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(4)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(12)
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
            make.top.equalTo(descriptionTextView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
}
