//
//  LineByStackView.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SnapKit

final class LineByStackView: BaseView {
    
    struct LineStack {
        let title: String
        let subTitle: String
    }
    
    private let stackView = UIStackView()
    private let verticalLineView = UIView()
    
    override func configureView() {
        stackView.spacing = 12
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        verticalLineView.backgroundColor = .customLightGray.withAlphaComponent(0.5)
    }
    
    override func configureHierarchy() {
        [stackView, verticalLineView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        verticalLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(4)
        }
    }
    
    func configure(_ model: [LineStack]) {
        for (index, item) in model.enumerated() {
            let horizontalLine = UIView()
            horizontalLine.backgroundColor = .customLightGray.withAlphaComponent(0.5)
            let itemView = LineItemView(item.title, item.subTitle, .center)
            stackView.addArrangedSubview(itemView)
            if (model.count - 1) != index {
                stackView.addArrangedSubview(horizontalLine)
                horizontalLine.snp.makeConstraints { make in
                    make.width.equalTo(1)
                    make.verticalEdges.equalToSuperview().inset(12)
                }
            }
            itemView.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview().inset(12)
            }
        }
    }
}

final class LineItemView: BaseView {
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let titleString: String
    private let subTitleString: String
    private let alignment: NSTextAlignment
    init(_ titleString: String,_ subTitleString: String,_ alignment: NSTextAlignment) {
        self.titleString = titleString
        self.subTitleString = subTitleString
        self.alignment = alignment
        super.init(frame: .zero)
    }
    
    override func configureView() {
        titleLabel.font = .mediumBold
        titleLabel.textColor = .customBlack
        titleLabel.text = titleString
        
        subTitleLabel.font = .mediumSemibold
        subTitleLabel.textColor = .customLightGray
        subTitleLabel.text = subTitleString
        subTitleLabel.numberOfLines = 0
        
        [titleLabel, subTitleLabel].forEach {
            $0.textAlignment = alignment
        }
    }
    
    override func configureHierarchy() {
        [titleLabel, subTitleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.greaterThanOrEqualToSuperview().inset(4)
        }
    }
}
