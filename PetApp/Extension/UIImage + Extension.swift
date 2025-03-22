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
    case arrow = "arrow.left"
}

extension UIImage {
    static let footPrintImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let listImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let bubbleImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let personImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let pencilImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let playImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let mapImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let photoImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let paperplaneImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
}

extension UIImage {
    static let magnifyingglassImage = UIImage(systemName: ImageSubscription.magnifyingglass.rawValue)
    static let archiveboxImage = UIImage(systemName: ImageSubscription.archivebox.rawValue)
    static let arrowImage = UIImage(systemName: ImageSubscription.arrow.rawValue)
}
