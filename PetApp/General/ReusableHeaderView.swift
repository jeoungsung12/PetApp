//
//  ReusableHeaderView.swift
//  Moving
//
//  Created by 정성윤 on 3/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol MoreBtnDelegate: AnyObject {
    func moreBtnTapped()
}

final class ReusableHeaderView: UICollectionReusableView, ReusableIdentifier {
    private let titleLabel = UILabel()
    private let spacer = UIView()
    private let moreBtn = UIButton()
    private var disposeBag = DisposeBag()
    weak var delegate: MoreBtnDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
        setBinding()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBinding() {
        moreBtn.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.moreBtnTapped()
            }
            .disposed(by: disposeBag)
    }
    
}

extension ReusableHeaderView {
    
    private func configureView() {
        titleLabel.textColor = .customBlack
        titleLabel.font = .headLine
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        
        spacer.backgroundColor = .customBlack
        
        let buttonColor: UIColor = .point.withAlphaComponent(0.5)
        moreBtn.setTitle("더보기", for: .normal)
        moreBtn.setTitleColor(buttonColor, for: .normal)
        moreBtn.setImage(.arrowRight, for: .normal)
        moreBtn.titleLabel?.font = .largeBold
        moreBtn.tintColor = buttonColor
        
        moreBtn.semanticContentAttribute = .forceRightToLeft
    }
    
    private func configureHierarchy() {
        [titleLabel, spacer, moreBtn].forEach {
            self.addSubview($0)
        }
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        spacer.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        moreBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
    
    func configure(_ title: String,_ isMore: Bool = false) {
        titleLabel.text = title
        moreBtn.isHidden = (isMore)
    }
}
