//
//  PlayerTableViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import UIKit
import SnapKit
import YouTubeiOSPlayerHelper

final class PlayerTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private var playerView: YTPlayerView?
    private var videoID: String?
    
    private let containerView = UIView()
    private let locationLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoID = nil
        playerView?.stopVideo()
        playerView?.load(withVideoId: "")
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .customBlack
        containerView.backgroundColor = .customBlack
        
        locationLabel.textColor = .customWhite
        locationLabel.font = .smallBold
        locationLabel.textAlignment = .right
        
        titleLabel.textColor = .customWhite
        titleLabel.font = .largeBold
        
        descriptionLabel.textColor = .customWhite
        descriptionLabel.font = .mediumBold
        descriptionLabel.numberOfLines = 0
        
        statusLabel.textColor = .point
        statusLabel.font = .smallBold
        statusLabel.textAlignment = .right
        
        [titleLabel, descriptionLabel].forEach {
            $0.textAlignment = .left
        }
    }
    
    override func configureHierarchy() {
        playerView = YTPlayerView()
        playerView?.isUserInteractionEnabled = false
        if let playerView = playerView {
            self.contentView.addSubview(playerView)
        }
        [
            locationLabel,
            titleLabel,
            descriptionLabel,
            statusLabel
        ].forEach {
            containerView.addSubview($0)
        }
        self.contentView.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        playerView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.trailing.greaterThanOrEqualTo(locationLabel.snp.leading).inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    func configure(_ entity: PlayerEntity) {
        titleLabel.text = entity.name
        statusLabel.text = entity.status
        locationLabel.text = entity.shelter
        descriptionLabel.text = "\(entity.weight) \(entity.age)"
        
        videoID = extractYouTubeVideoID(from: entity.videoURL)
        playerView?.load(withVideoId: videoID ?? "")
    }
    
}

extension PlayerTableViewCell {
    
    func playVideo() {
        guard let videoID = videoID else { return }
        let playerVars: [String: Any] = [
            "autoplay": 1,
            "playsinline": 1,
            "controls": 1,
            "rel": 0,
            "modestbranding": 1
        ]
        playerView?.load(withVideoId: videoID, playerVars: playerVars)
    }
    
    func stopVideo() {
        playerView?.stopVideo()
    }
    
    private func extractYouTubeVideoID(from url: String) -> String? {
        let pattern = "youtu.be/([a-zA-Z0-9_-]+)"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
        let nsString = url as NSString
        let results = regex.matches(in: url, options: [], range: NSRange(location: 0, length: nsString.length))
        
        if let match = results.first {
            let videoIDRange = match.range(at: 1)
            return nsString.substring(with: videoIDRange)
        }
        return nil
    }
    
}
