//
//  InfiniteHorizontalView.swift
//  OnboardingCardView
//
//  Created by Hishara Dilshan on 13/02/2025.
//

import Foundation
import SwiftUI

struct InfiniteHorizontalView<Content: View>: View {
    var spacing: CGFloat = 10
    @ViewBuilder var content: Content
    @State private var contentSize: CGSize = .zero
    
    private typealias Scroller = InfiniteHorizontalViewHelper
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.horizontal) {
                HStack(spacing: self.spacing) {
                    Group(subviews: self.content) { views in
                        HStack(spacing: self.spacing) {
                            ForEach(views) { subView in
                                subView
                            }
                        }
                        .onGeometryChange(for: CGSize.self) { proxy in
                            proxy.size
                        } action: { newSize in
                            self.contentSize = .init(width: newSize.width + spacing, height: newSize.height)
                        }
                        
                        
                        let avgWidth = contentSize.width / CGFloat(views.count)
                        let repeatCount = contentSize.width > 0 ? Int(size.width / avgWidth) + 1 : 1
                        
                        HStack(spacing: spacing) {
                            ForEach(0..<repeatCount, id: \.self) { index in
                                let view = Array(views)[index % views.count]
                                
                                view
                            }
                        }

                    }
                }
                .background(Scroller.init(declarationRate: .constant(.fast), contentSize: self.$contentSize))
            }
        }
    }
}

fileprivate struct InfiniteHorizontalViewHelper: UIViewRepresentable {
    @Binding var declarationRate: UIScrollView.DecelerationRate
    @Binding var contentSize: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let scrollview = view.scrollView {
                context.coordinator.defaultDelegate = scrollview.delegate
                scrollview.decelerationRate = self.declarationRate
                scrollview.delegate = context.coordinator
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.declarationRate = self.declarationRate
        context.coordinator.contentSize = self.contentSize
    }
}

fileprivate extension InfiniteHorizontalViewHelper {
    func makeCoordinator() -> Coordinator {
        .init(declarationRate: self.declarationRate, contentSize: self.contentSize)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var declarationRate: UIScrollView.DecelerationRate
        var contentSize: CGSize
        weak var defaultDelegate: UIScrollViewDelegate?
        
        init(declarationRate: UIScrollView.DecelerationRate, contentSize: CGSize) {
            self.declarationRate = declarationRate
            self.contentSize = contentSize
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollView.decelerationRate = self.declarationRate
            let minX = scrollView.contentOffset.x
            
            if minX > contentSize.width {
                scrollView.contentOffset.x -= contentSize.width
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += contentSize.width
            }
                        
            defaultDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            defaultDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewWillBeginDragging?(scrollView)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            defaultDelegate?.scrollViewWillEndDragging?(
                scrollView,
                withVelocity: velocity,
                targetContentOffset: targetContentOffset
            )
        }
    }
}

fileprivate extension UIView {
    var scrollView: UIScrollView? {
        if let superview, superview is UIScrollView {
            return superview as? UIScrollView
        }
        return superview?.scrollView
    }
}
