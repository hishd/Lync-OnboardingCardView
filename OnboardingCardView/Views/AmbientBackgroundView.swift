//
//  AmbientBackgroundView.swift
//  OnboardingCardView
//
//  Created by Hishara Dilshan on 13/02/2025.
//

import SwiftUI

struct AmbientBackgroundView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            content()
            
            Rectangle()
                .fill(.black.opacity(0.45))
                .ignoresSafeArea()
        }
        .compositingGroup()
        .blur(radius: 90, opaque: true)
        .ignoresSafeArea()
    }
}
