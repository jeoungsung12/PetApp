//
//  PosterView.swift
//  PetApp
//
//  Created by 정성윤 on 4/22/25.
//

import SwiftUI
import SNKit

struct PosterView: View {
    let image: String
    let size: CGFloat
    var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: URL(string: image)) { status in
                switch status {
                case .empty:
                    ProgressView()
                        .frame(height: size)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: size)
                case .failure:
                    Color.gray
                        .frame(height: size)
                @unknown default:
                    Color.gray
                        .frame(height: size)
                }
            }
        } else {
            if let url = URL(string: image) {
                SNImage(url: url)
            }
        }
    }
}
