//
//  OnboardingPageView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isCurrentPage: Bool
    
    @State private var titleOffset: CGFloat = 50
    @State private var subtitleOffset: CGFloat = 50
    @State private var descriptionOffset: CGFloat = 50
    @State private var imageScale: CGFloat = 0.8
    @State private var contentOpacity: Double = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                page.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.xl) {
                    Spacer()
                    
                    // Icon/Image
                    ZStack {
                        Circle()
                            .fill(page.textColor.opacity(0.1))
                            .frame(width: 180, height: 180)
                        
                        Image(systemName: page.imageName)
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(page.textColor)
                            .scaleEffect(imageScale)
                    }
                    .opacity(contentOpacity)
                    
                    Spacer().frame(maxHeight: AppSpacing.xl)
                    
                    // Content
                    VStack(spacing: AppSpacing.lg) {
                        // Title
                        Text(page.title)
                            .font(AppTypography.headlineLarge)
                            .fontWeight(.bold)
                            .foregroundColor(page.textColor)
                            .multilineTextAlignment(.center)
                            .offset(y: titleOffset)
                            .opacity(contentOpacity)
                        
                        // Subtitle
                        Text(page.subtitle)
                            .font(AppTypography.titleLarge)
                            .fontWeight(.semibold)
                            .foregroundColor(page.textColor.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .offset(y: subtitleOffset)
                            .opacity(contentOpacity)
                        
                        // Description
                        Text(page.description)
                            .font(AppTypography.bodyLarge)
                            .foregroundColor(page.textColor.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, AppSpacing.lg)
                            .offset(y: descriptionOffset)
                            .opacity(contentOpacity)
                    }
                    
                    Spacer()
                }
                .padding(AppSpacing.xl)
            }
        }
        .onAppear {
            if isCurrentPage {
                startAnimations()
            }
        }
        .onChange(of: isCurrentPage) { _, newValue in
            if newValue {
                startAnimations()
            } else {
                resetAnimations()
            }
        }
    }
    
    private func startAnimations() {
        // Reset first
        resetAnimations()
        
        // Animate content in sequence
        withAnimation(.easeOut(duration: 0.8)) {
            contentOpacity = 1.0
            imageScale = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
            titleOffset = 0
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
            subtitleOffset = 0
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
            descriptionOffset = 0
        }
    }
    
    private func resetAnimations() {
        titleOffset = 50
        subtitleOffset = 50
        descriptionOffset = 50
        imageScale = 0.8
        contentOpacity = 0.0
    }
}

// MARK: - Preview
#Preview {
    OnboardingPageView(
        page: OnboardingData.pages[0],
        isCurrentPage: true
    )
}