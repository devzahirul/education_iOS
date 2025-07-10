//
//  OnboardingContainerView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    var body: some View {
        ZStack {
            switch onboardingViewModel.state {
            case .splash:
                SplashScreen(viewModel: onboardingViewModel)
                    .transition(.opacity)
                
            case .onboarding:
                OnboardingView(viewModel: onboardingViewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                
            case .completed:
                // After onboarding completion, show authentication or main app
                Group {
                    switch authViewModel.state {
                    case .unauthenticated, .authenticating:
                        AuthenticationContainerView()
                    case .authenticated:
                        MainAppView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: onboardingViewModel.state)
        .animation(.easeInOut(duration: 0.5), value: authViewModel.state)
        .onAppear {
            onboardingViewModel.checkOnboardingStatus()
            authViewModel.checkAuthenticationStatus()
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
                    
                    Text("You're successfully authenticated and ready to learn!")
                        .font(AppTypography.bodyLarge)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: AppSpacing.md) {
                    AppButton("Sign Out", style: .outline) {
                        // Sign out and return to authentication
                        UserDefaults.standard.set(false, forKey: "isAuthenticated")
                        UserDefaults.standard.removeObject(forKey: "userEmail")
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = UIHostingController(rootView: OnboardingContainerView())
                            window.makeKeyAndVisible()
                        }
                    }
                    
                    AppButton("Reset Onboarding", style: .text) {
                        // Reset onboarding for testing
                        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                        UserDefaults.standard.set(false, forKey: "isAuthenticated")
                        UserDefaults.standard.removeObject(forKey: "userEmail")
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = UIHostingController(rootView: OnboardingContainerView())
                            window.makeKeyAndVisible()
                        }
                    }
                }
            }
            .padding(AppSpacing.xl)
            .navigationTitle("EduApp")
        }
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