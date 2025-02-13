//
//  CardModel.swift
//  OnboardingCardView
//
//  Created by Hishara Dilshan on 13/02/2025.
//

import Foundation

let cards: [CardModel] = [
    .init(image: "card1"),
    .init(image: "card2"),
    .init(image: "card3"),
    .init(image: "card4"),
    .init(image: "card5"),
    .init(image: "card6"),
]

struct CardModel: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
}
