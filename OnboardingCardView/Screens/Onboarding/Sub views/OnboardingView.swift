//
//  OnboardingView.swift
//  OnboardingCardView
//
//  Created by Hishara Dilshan on 13/02/2025.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @State var activeCard: CardModel? = cards.first
    @State var scrollPosition: ScrollPosition = .init()
    @State var scrollOffset: CGFloat = .zero
    @State var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    @State var initialAnimation: Bool = false
    @State var titleProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            ambientBackground
                .animation(.easeInOut(duration: 1), value: activeCard)
            
            VStack(spacing: 10) {
                infiniteCardScrollView
                
                VStack {
                    appIntro
                    btnGetStarted
                }
            }
            .safeAreaPadding(25)
        }
        .onReceive(timer) { _ in
            self.scrollOffset += 0.4
            self.scrollPosition.scrollTo(x: scrollOffset)
        }
        .task {
            try? await Task.sleep(for: .seconds(0.35))
            
            withAnimation(.smooth(duration: 0.75, extraBounce: 0)) {
                self.initialAnimation = true
            }
            
            withAnimation(.smooth(duration: 2.5, extraBounce: 0).delay(0.3)) {
                self.titleProgress = 1
            }
        }
    }
}

extension OnboardingView {
    private var ambientBackground: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            AmbientBackgroundView {
                ForEach(cards) { card in
                    Image(card.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .frame(width: size.width, height: size.height)
                        .opacity(self.activeCard?.id == card.id  ? 1 : 0)
                }
            }
        }
    }
    
    @ViewBuilder
    private func cardView(from card: CardModel) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            CardView(card: card)
                .frame(width: size.width, height: size.height)
        }
        .frame(width: 230)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
            content
                .offset(y: phase == .identity ? -10 : 0)
                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
        }
    }
    
    var infiniteCardScrollView: some View {
        InfiniteHorizontalView {
            ForEach(cards) { card in
                cardView(from: card)
            }
        }
        .scrollIndicators(.hidden)
        .scrollPosition(self.$scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self) { proxy in
            proxy.contentOffset.x + proxy.contentInsets.leading
        } action: { _, newValue in
            self.scrollOffset = newValue
            let activeCardIndex = Int((scrollOffset/200).rounded()) % cards.count
            self.activeCard = cards[activeCardIndex]
        }
        .visualEffect { [initialAnimation] content, proxy in
            content
                .offset(y: !initialAnimation ? -(proxy.size.height + 200) : 0)
        }
    }
    
    var appIntro: some View {
        VStack(spacing: 2) {
            Text("Welcome to")
                .fontWeight(.regular)
                .foregroundStyle(.white.secondary)
                .blurOpacityEffect(self.initialAnimation)
                .padding(.vertical)
            
            HStack(spacing: 0) {
                Image("logo_white")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
                    .padding()
                    .blurOpacityEffect(self.initialAnimation)
                
                Text("Lync")
                    .font(.system(size: 46, weight: .bold))
                    .foregroundStyle(.white)
                    .textRenderer(TextEffect(progress: self.titleProgress))
            }
            
            Text("Connect with professionals and dive into a pool of expertise for growth and new opportunities.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.secondary)
                .padding()
                .padding(.bottom, 30)
                .blurOpacityEffect(self.initialAnimation)
        }
    }
    
    var btnGetStarted: some View {
        Button {
            self.timer.upstream.connect().cancel()
        } label: {
            Text("Get Started")
                .foregroundStyle(.white)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.bgPurple)
                }
        }
        .backgroundStyle(.red)
    }
}

#Preview {
    OnboardingView()
}
