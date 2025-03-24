//
//  UIImage + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/21/25.
//

import UIKit
enum ImageSubscription: String {
    case footPrint = "pawprint.fill"
    case list = "list.dash"
    case bubble
    case person = "person.circle"
    case pencil
    case play = "play.square"
    case map
    case photo = "photo.badge.plus"
    case paperplane
    
    case magnifyingglass
    case archivebox
    case arrowRight = "chevron.right"
    case arrowLeft = "chevron.left"
    case heart
    case heartFill = "heart.fill"
    case share = "square.and.arrow.up"
}

extension UIImage {
    static let footPrintImage = UIImage(systemName: ImageSubscription.footPrint.rawValue)
    static let listImage = UIImage(systemName: ImageSubscription.list.rawValue)
    static let bubbleImage = UIImage(systemName: ImageSubscription.bubble.rawValue)
    static let personImage = UIImage(systemName: ImageSubscription.person.rawValue)
    static let pencilImage = UIImage(systemName: ImageSubscription.pencil.rawValue)
    static let playImage = UIImage(systemName: ImageSubscription.play.rawValue)
    static let mapImage = UIImage(systemName: ImageSubscription.map.rawValue)
    static let photoImage = UIImage(systemName: ImageSubscription.photo.rawValue)
    static let paperplaneImage = UIImage(systemName: ImageSubscription.paperplane.rawValue)
}

extension UIImage {
    static let magnifyingglassImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let archiveboxImage = UIImage(systemName: ImageSubscription.archivebox.rawValue)
    static let arrowRight = UIImage(systemName: ImageSubscription.arrowRight.rawValue)
    static let arrowLeft = UIImage(systemName: ImageSubscription.arrowLeft.rawValue)
    static let heartImage = UIImage(systemName: ImageSubscription.heart.rawValue)
    static let heartFillImage = UIImage(systemName: ImageSubscription.heartFill.rawValue)
    static let shareImage = UIImage(systemName: ImageSubscription.share.rawValue)
}
