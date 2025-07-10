//
//  OnboardingContainerView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onCompletion: (() -> Void)?
    
    init(onCompletion: (() -> Void)? = nil) {
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .splash:
                SplashScreen(viewModel: viewModel)
                    .transition(.opacity)
                
            case .onboarding:
                OnboardingView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                
            case .completed:
                if let onCompletion = onCompletion {
                    // Use the callback instead of showing MainAppView directly
                    Color.clear.onAppear {
                        onCompletion()
                    }
                } else {
                    MainAppView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.state)
        .onAppear {
            viewModel.checkOnboardingStatus()
        }
    }
}

// MARK: - Main App View (Placeholder)
struct MainAppView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: AppSpacing.xl) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.success)
                
                VStack(spacing: AppSpacing.md) {
                    Text("Welcome to EduApp!")
                        .font(AppTypography.headlineLarge)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Onboarding completed successfully")
                        .font(AppTypography.bodyLarge)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                AppButton("Reset Onboarding", style: .outline) {
                    // Reset onboarding for testing
                    UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = UIHostingController(rootView: OnboardingContainerView())
                        window.makeKeyAndVisible()
                    }
                }
            }
            .padding(AppSpacing.xl)
            .navigationTitle("EduApp")
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingContainerView()
}