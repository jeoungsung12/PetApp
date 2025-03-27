//
//  ChatKeyboardView.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SnapKit

final class ChatKeyboardView: BaseView {
    private let containerView = UIView()
    //TODO: UITextView
    private let textField = UITextField()
    private let sendButton = UIButton()
    
    override func configureView() {
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        
        textField.backgroundColor = .clear
        textField.font = .largeSemibold
        textField.placeholder = "메시지를 입력하세요..."
        textField.textColor = .black
        textField.borderStyle = .none
        textField.returnKeyType = .send
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        
        sendButton.setImage(.paperplaneImage, for: .normal)
        sendButton.tintColor = .point
        sendButton.contentMode = .scaleAspectFit
    }
    
    override func configureHierarchy() {
        [textField, sendButton].forEach {
            containerView.addSubview($0)
        }
        self.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(50)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview()
        }
    }

}
