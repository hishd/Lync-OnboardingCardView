//
//  BlurOpacityEffect.swift
//  OnboardingCardView
//
//  Created by Hishara Dilshan on 13/02/2025.
//

import SwiftUI

extension View {
    func blurOpacityEffect(_ show: Bool) -> some View {
        self
            .blur(radius: show ? 0 : 2)
            .opacity(show ? 1 : 0)
            .scaleEffect(show ? 1 : 0.9)
    }
}
