//
//  CardView.swift
//  OnboardingCardView
//
//  Created by Hishara Dilshan on 13/02/2025.
//

import SwiftUI

struct CardView: View {
    var card: CardModel
    var body: some View {
        Image(card.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay {
                Color.black.opacity(0.2)
            }
            .clipShape(.rect(cornerRadius: 15))
            .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)
    }
}
