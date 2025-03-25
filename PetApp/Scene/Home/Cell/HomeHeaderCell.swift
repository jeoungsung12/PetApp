//
//  HomeHeaderCell.swift
//  Moving
//
//  Created by 조우현 on 3/21/25.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

final class HomeHeaderCell: BaseCollectionViewCell, ReusableIdentifier {
    private lazy var posterCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout()
    )
    private let categoryView = HomeCategoryView()
    private let posterImages: [UIImage?] = [
        UIImage(named: "poster1"),
        UIImage(named: "poster2"),
        UIImage(named: "poster3"),
        UIImage(named: "poster4"),
        UIImage(named: "poster5"),
        UIImage(named: "poster6")
    ]
    private var timer: Timer?
    private var currentPage = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopAutoScrollTimer()
        startAutoScrollTimer()
    }
    
    override func configureHierarchy() {
        [posterCollectionView, categoryView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        posterCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(posterCollectionView.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        posterCollectionView.delegate = self
        posterCollectionView.dataSource = self
        posterCollectionView.isPagingEnabled = true
        posterCollectionView.backgroundColor = .lightGray
        posterCollectionView.showsHorizontalScrollIndicator = false
        posterCollectionView
            .register(
                PosterCell.self,
                forCellWithReuseIdentifier: PosterCell.id
            )
        startAutoScrollTimer()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(
            width: contentView.frame.width,
            height: contentView.frame.width
        )
        return layout
    }
    
    deinit {
        print(#function, self)
        stopAutoScrollTimer()
    }
}

extension HomeHeaderCell {
    private func startAutoScrollTimer() {
        stopAutoScrollTimer()
        timer = Timer
            .scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.scrollToNextPage()
            }
    }
    
    private func stopAutoScrollTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func scrollToNextPage() {
        let totalItems = posterImages.count
        currentPage = (currentPage + 1) % totalItems
        let indexPath = IndexPath(item: currentPage, section: 0)
        posterCollectionView
            .scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
    }
}

extension HomeHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PosterCell.id,
            for: indexPath
        ) as! PosterCell
        cell
            .configure(
                with: posterImages[indexPath.item] ?? UIImage(named: "poster1")
            )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: contentView.frame.width,
            height: contentView.frame.width
        )
    }
}
