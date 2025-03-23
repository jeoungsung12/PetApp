//
//  ReusableHeaderView.swift
//  Moving
//
//  Created by 정성윤 on 3/21/25.
//

import UIKit
import SnapKit

final class ReusableHeaderView: UICollectionReusableView, ReusableIdentifier {
    private let titleLabel = UILabel()
    private let spacer = UIView()
    private let moreBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReusableHeaderView {
    
    private func configureView() {
        titleLabel.textColor = .customBlack
        titleLabel.font = .headLine
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        
        spacer.backgroundColor = .customBlack
        
        moreBtn.setTitle("더보기", for: .normal)
        moreBtn.setTitleColor(.customLightGray, for: .normal)
        moreBtn.setImage(.arrowRight, for: .normal)
        moreBtn.titleLabel?.font = .largeBold
        moreBtn.tintColor = .customLightGray
        
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
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
}
