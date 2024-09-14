//
//  PopView.swift
//  SwiftUI-Alert-Dialogue
//
//  Created by Seungsub Oh on 9/14/24.
//

import SwiftUI

struct Config {
    var backgroundColor: Color = .black.opacity(0.25)
    
}

extension View {
    func popView<Content: View>(
        config: Config = .init(),
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            PopViewHelper(
                config: config,
                isPresented: isPresented,
                onDismiss: onDismiss,
                viewContent: content
            )
        )
    }
}

struct PopViewHelper<ViewContent: View>: ViewModifier {
    var config: Config
    @Binding var isPresented: Bool
    @State private var presentFullscreenCover = false
    var onDismiss: () -> Void
    @ViewBuilder var viewContent: ViewContent
    @State private var animateView = false
    
    func body(content: Content) -> some View {
        let screenHeight = screenSize.height
        let animateView = animateView
        
        return content
            .fullScreenCover(isPresented: $presentFullscreenCover) {
                ZStack {
                    Rectangle()
                        .fill(config.backgroundColor)
                        .ignoresSafeArea()
                        .opacity(animateView ? 1 : 0)
                    
                    viewContent
                        .visualEffect { content, proxy in
                            content
                                .offset(y: offset(proxy, screenHeight, animateView))
                        }
                        .presentationBackground(
                            .clear
                        )
                        .task {
                            guard !animateView else { return }
                            withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                                self.animateView = true
                            }
                        }
                        .ignoresSafeArea(.container, edges: .all)
                }
            }
            .onChange(of: isPresented) { _, new in
                if new {
                    toggleView(to: true)
                } else {
                    withAnimation(.snappy(duration: 0.45, extraBounce: 0.05)) {
                        self.animateView = false
                    } completion: {
                        toggleView(to: false)
                        onDismiss()
                    }

                }
            }
    }
    
    func toggleView(to: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        
        withTransaction(transaction) {
            presentFullscreenCover = to
        }
    }
    
    nonisolated func offset(_ proxy: GeometryProxy, _ screenHeight: CGFloat, _ animateView: Bool) -> CGFloat {
        let viewHeight = proxy.size.height
        return animateView ? 0 : (screenHeight + viewHeight) / 2
    }
    
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        
        return .zero
    }
}
