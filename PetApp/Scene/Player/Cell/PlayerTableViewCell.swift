//
//  PlayerTableViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import UIKit
import SnapKit
import AVKit
import AVFoundation
import YouTubeiOSPlayerHelper

final class PlayerTableViewCell: BaseTableViewCell, ReusableIdentifier {
//    private var player: AVPlayer?
//    private var playerVC: AVPlayerViewController?
    private var playerView: YTPlayerView?
    private var videoID: String?
    
    private let containerView = UIView()
    private let locationLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView?.stopVideo()
        videoID = nil
    }
    
    override func configureView() {
        containerView.clipsToBounds = true
        containerView.backgroundColor = .customLightGray
        containerView.layer.cornerRadius = 10
        
        locationLabel.textColor = .customLightGray
        locationLabel.font = .smallSemibold
        locationLabel.textAlignment = .right
        
        titleLabel.textColor = .customBlack
        titleLabel.font = .largeBold
        
        descriptionLabel.textColor = .customBlack
        descriptionLabel.font = .mediumRegular
        descriptionLabel.numberOfLines = 0
        
        statusLabel.textColor = .point
        statusLabel.font = .smallSemibold
        statusLabel.textAlignment = .right
        
        [titleLabel, descriptionLabel].forEach {
            $0.textAlignment = .left
        }
    }
    
    override func configureHierarchy() {
        playerView = YTPlayerView()
        if let playerView = playerView {
            containerView.addSubview(playerView)
        }
        [containerView, locationLabel, titleLabel, descriptionLabel, statusLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        playerView?.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(containerView.snp.bottom).offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.trailing.greaterThanOrEqualTo(locationLabel.snp.leading).inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(2)
        }
    }
    
    func configure(_ entity: PlayerEntity) {
        titleLabel.text = entity.name
        statusLabel.text = entity.status
        locationLabel.text = entity.shelter
        descriptionLabel.text = "\(entity.weight) \(entity.age)"
        
        videoID = extractYouTubeVideoID(from: entity.videoURL)
        //TODO: 수정
        playerView?.load(withVideoId: videoID ?? "")
        //        configurePlayer(entity.videoURL)
    }
    
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
    
    //TODO: ViewModel
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

extension PlayerTableViewCell {
    
//    private func configurePlayer(_ url: String) {
//        if let videoURL = URL(string: url) {
//            player = AVPlayer(url: videoURL)
//            
//            playerVC = AVPlayerViewController()
//            playerVC?.player = player
//            if let playerVC = playerVC {
//                playerVC.view.clipsToBounds = true
//                playerVC.view.layer.cornerRadius = 10
//                containerView.addSubview(playerVC.view)
//                playerVC.view.snp.makeConstraints { make in
//                    make.edges.equalToSuperview()
//                }
//                startPlayer()
//            }
//        }
//    }
    
//    func startPlayer() {
//        player?.play()
//    }
//    
//    func stopPlayer() {
//        player?.pause()
//    }
    
}
