# Onboarding Card View

<p>
<img src="https://img.shields.io/badge/iOS-16.0-blue">
<img src="https://img.shields.io/badge/Swift-5.9-violet">
</p>

<p>
  	<img src="https://github.com/hishd/Lync-OnboardingCardView/blob/main/preview.gif?raw=true" height="450">
</p>

### Overview

An infinite horizontal card scrolling view component developed for an open-source project I'm currently developing. The `OnboardingView` contains a horizontal scrollview which scrolls the attached list of views in X axis. Due to limitations of SwiftUI's ScrollView, UiKit's  `UIScrollViewDelegate` is being utilized to achieve the infinite scroll effect with updating scrollview's  `contentOffset`.

This implementation is based on [Kavsoft's Infinite ScrollView](https://www.youtube.com/watch?v=VHaPYUWFTF8&t=2s) 

## Installation

 - Clone the OnboardingCardView repository (or use the required components).
 - Find the `OnboardingView` on `Screens/Onboarding/Sub views/OnboardingView.swift`
 - The method `private func  cardView(from card: CardModel)` returns the type of `CardView` which is at `Views/CardView.swift`
 - Change the `cardView()` method implementation of change the `CardView` struct as needed.
