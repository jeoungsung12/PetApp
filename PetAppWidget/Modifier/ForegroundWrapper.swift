//
//  ForegroundWrapper.swift
//  PetApp
//
//  Created by 정성윤 on 4/22/25.
//

import SwiftUI

struct ForegroundWrapper: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .foregroundStyle(color)
        } else {
            content
                .foregroundColor(color)
        }
    }
}

extension View {
    func asForeground(_ color: Color) -> some View {
        modifier(ForegroundWrapper(color: color))
    }
}
