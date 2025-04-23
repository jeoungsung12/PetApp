//
//  BackgroundWrapper.swift
//  PetApp
//
//  Created by 정성윤 on 4/23/25.
//
import SwiftUI

struct BackgroundWrapper: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .background(color)
        } else {
            content
                .background(Rectangle().fill(color))
        }
    }
}

extension View {
    func asBackground(_ color: Color) -> some View {
        modifier(BackgroundWrapper(color: color))
    }
}
