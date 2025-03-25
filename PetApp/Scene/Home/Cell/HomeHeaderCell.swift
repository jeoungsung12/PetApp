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
    private let customPageControl = UILabel()
    private let posterImages: [UIImage?] = [
        UIImage(named: "poster1"),
        UIImage(named: "poster2"),
        UIImage(named: "poster3"),
        UIImage(named: "poster4"),
        UIImage(named: "poster5"),
        UIImage(named: "poster6"),
        UIImage(named: "poster1")
    ]
    private var timer: Timer?
    private var currentPage = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopAutoScrollTimer()
        startAutoScrollTimer()
    }
    
    
    override func configureView() {
        posterCollectionView.delegate = self
        posterCollectionView.dataSource = self
        posterCollectionView.isPagingEnabled = true
        posterCollectionView.backgroundColor = .lightGray
        posterCollectionView.showsHorizontalScrollIndicator = false
        posterCollectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.id)
        
        customPageControl.clipsToBounds = true
        customPageControl.font = .mediumBold
        customPageControl.layer.cornerRadius = 5
        customPageControl.textColor = .customWhite
        customPageControl.backgroundColor = .black.withAlphaComponent(0.5)
        customPageControl.textAlignment = .center
        updatePageControl()
        startAutoScrollTimer()
    }
    
    override func configureHierarchy() {
        [posterCollectionView, categoryView, customPageControl].forEach {
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
        
        customPageControl.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(25)
            make.bottom.equalTo(posterCollectionView.snp.bottom).inset(12)
            make.trailing.equalTo(posterCollectionView.snp.trailing).inset(12)
        }
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
            .scheduledTimer(withTimeInterval: 7.0, repeats: true) { [weak self] _ in
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
        currentPage += 1
        
        if currentPage == totalItems - 1 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            posterCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.currentPage = 0
                let resetIndexPath = IndexPath(item: 0, section: 0)
                self.posterCollectionView.scrollToItem(at: resetIndexPath, at: .centeredHorizontally, animated: false)
                self.updatePageControl()
            }
        } else if currentPage < totalItems {
            let indexPath = IndexPath(item: currentPage, section: 0)
            posterCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updatePageControl()
        }
    }
    
    private func updatePageControl() {
        customPageControl.text = "\(currentPage + 1) / \(posterImages.count - 1)"
    }
}

extension HomeHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.id, for: indexPath) as? PosterCell else { return UICollectionViewCell() }
        cell.configure(with: posterImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: contentView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = posterCollectionView.frame.width
        currentPage = Int((posterCollectionView.contentOffset.x + pageWidth / 2) / pageWidth) % posterImages.count
        updatePageControl()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageControl()
    }
}
