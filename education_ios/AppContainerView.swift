//
//  AppContainerView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - App State
enum AppState {
    case splash
    case onboarding
    case authentication
    case authenticated(user: User)
}

// MARK: - App Container View Model
@MainActor
class AppContainerViewModel: ObservableObject {
    @Published var appState: AppState = .splash
    
    func checkAppState() {
        // First check if user has completed onboarding
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if !hasCompletedOnboarding {
            // Show onboarding first
            appState = .splash
        } else {
            // Check authentication status
            let isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
            
            if isAuthenticated {
                // User is authenticated, load user data
                let email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
                let name = UserDefaults.standard.string(forKey: "userName") ?? ""
                let user = User(email: email, name: name)
                appState = .authenticated(user: user)
            } else {
                // Show authentication screens
                appState = .authentication
            }
        }
    }
    
    func onboardingCompleted() {
        // After onboarding is completed, show authentication
        appState = .authentication
    }
    
    func userAuthenticated(user: User) {
        appState = .authenticated(user: user)
    }
    
    func userLoggedOut() {
        appState = .authentication
    }
}

// MARK: - App Container View
struct AppContainerView: View {
    @StateObject private var viewModel = AppContainerViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.appState {
            case .splash, .onboarding:
                // Show onboarding flow
                OnboardingContainerView { 
                    viewModel.onboardingCompleted()
                }
                .transition(.opacity)
                
            case .authentication:
                // Show authentication flow
                AuthenticationContainerView { user in
                    viewModel.userAuthenticated(user: user)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                
            case .authenticated(let user):
                // Show main app
                MainAppView(user: user) {
                    viewModel.userLoggedOut()
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.appState.id)
        .onAppear {
            viewModel.checkAppState()
        }
    }
}

// MARK: - Enhanced Main App View
struct MainAppView: View {
    let user: User
    let onLogout: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Welcome Header
                    VStack(spacing: AppSpacing.md) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primary)
                        
                        VStack(spacing: AppSpacing.xs) {
                            Text("Welcome, \(user.name)!")
                                .font(AppTypography.headlineLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(user.email)
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    // App Features Placeholder
                    VStack(spacing: AppSpacing.lg) {
                        // Dashboard Card
                        AppCard {
                            VStack(spacing: AppSpacing.md) {
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.title2)
                                        .foregroundColor(AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                        Text("Learning Progress")
                                            .font(AppTypography.titleMedium)
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Text("Continue your journey")
                                            .font(AppTypography.bodyMedium)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("75%")
                                        .font(AppTypography.headlineSmall)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppColors.success)
                                }
                            }
                        }
                        
                        // Courses Card
                        AppCard {
                            VStack(spacing: AppSpacing.md) {
                                HStack {
                                    Image(systemName: "book.fill")
                                        .font(.title2)
                                        .foregroundColor(AppColors.secondary)
                                    
                                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                        Text("My Courses")
                                            .font(AppTypography.titleMedium)
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Text("12 enrolled courses")
                                            .font(AppTypography.bodyMedium)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(AppColors.textTertiary)
                                }
                            }
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: AppSpacing.md) {
                        AppButton("Reset Onboarding", style: .outline) {
                            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                window.rootViewController = UIHostingController(rootView: AppContainerView())
                                window.makeKeyAndVisible()
                            }
                        }
                        
                        AppButton("Sign Out", style: .secondary) {
                            UserDefaults.standard.set(false, forKey: "isAuthenticated")
                            UserDefaults.standard.removeObject(forKey: "userEmail")
                            UserDefaults.standard.removeObject(forKey: "userName")
                            onLogout()
                        }
                    }
                }
                .padding(AppSpacing.xl)
            }
            .navigationTitle("EduApp")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - AppState Extension for Animation
extension AppState {
    var id: String {
        switch self {
        case .splash: return "splash"
        case .onboarding: return "onboarding"
        case .authentication: return "authentication"
        case .authenticated: return "authenticated"
        }
    }
}

// MARK: - Preview
#Preview {
    AppContainerView()
}