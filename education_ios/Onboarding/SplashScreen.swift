//
//  SplashScreen.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct SplashScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                    AppColors.secondary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                // Logo/Icon
                ZStack {
                    Circle()
                        .fill(AppColors.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(AppColors.white)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
                
                // App Name and Tagline
                VStack(spacing: AppSpacing.sm) {
                    Text("EduApp")
                        .font(AppTypography.displayMedium)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.white)
                        .opacity(textOpacity)
                    
                    Text("Learn. Grow. Succeed.")
                        .font(AppTypography.titleLarge)
                        .foregroundColor(AppColors.white.opacity(0.9))
                        .opacity(textOpacity)
                }
                
                Spacer()
                
                // Loading Indicator
                VStack(spacing: AppSpacing.md) {
                    DotsLoadingIndicator(style: .medium, color: AppColors.white)
                    
                    Text("Preparing your learning experience...")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(AppColors.white.opacity(0.8))
                        .opacity(textOpacity)
                }
                .padding(.bottom, AppSpacing.xxl)
            }
            .padding(AppSpacing.xl)
        }
        .onAppear {
            startAnimations()
            
            // Auto-advance to onboarding after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                viewModel.startOnboarding()
            }
        }
    }
    
    private func startAnimations() {
        // Logo animation
        withAnimation(.easeOut(duration: 1.0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text animation with delay
        withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
            textOpacity = 1.0
        }
        
        // Background animation
        withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
            isAnimating = true
        }
    }
}

// MARK: - Preview
#Preview {
    SplashScreen(viewModel: OnboardingViewModel())
}