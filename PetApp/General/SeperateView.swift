//
//  SeperateView.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SnapKit

final class SeperateView: BaseView {
    private let view = UIView()
    override func configureView() {
        view.backgroundColor = .systemGray6
    }
    
    override func configureHierarchy() {
        self.addSubview(view)
    }
    
    override func configureLayout() {
        view.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.edges.equalToSuperview()
        }
    }
}
