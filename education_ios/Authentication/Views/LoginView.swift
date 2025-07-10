//
//  LoginView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var showPassword = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Header Section
                    VStack(spacing: AppSpacing.lg) {
                        // Logo/Icon
                        Image(systemName: "graduationcap.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primary)
                            .scaleEffect(1.0)
                            .animation(.easeInOut(duration: 0.6), value: true)
                        
                        // Welcome Text
                        VStack(spacing: AppSpacing.sm) {
                            Text("Welcome Back!")
                                .font(AppTypography.headlineLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Sign in to continue your learning journey")
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, AppSpacing.xl)
                    
                    // Login Form
                    VStack(spacing: AppSpacing.lg) {
                        // Email Field
                        AppTextField(
                            "Email",
                            placeholder: "Enter your email address",
                            text: $viewModel.loginEmail,
                            type: .email,
                            errorMessage: viewModel.loginEmailError
                        )
                        
                        // Password Field
                        AppTextField(
                            "Password",
                            placeholder: "Enter your password",
                            text: $viewModel.loginPassword,
                            type: .secure,
                            errorMessage: viewModel.loginPasswordError
                        )
                        
                        // Forgot Password Link
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                viewModel.showForgotPassword()
                            }
                            .font(AppTypography.labelLarge)
                            .foregroundColor(AppColors.primary)
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: AppSpacing.md) {
                        // Login Button
                        AppButton(
                            "Sign In",
                            style: .primary,
                            size: .large,
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.login()
                            }
                        }
                        
                        // Sign Up Link
                        HStack(spacing: AppSpacing.xs) {
                            Text("Don't have an account?")
                                .font(AppTypography.bodyMedium)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Button("Sign Up") {
                                viewModel.showSignUp()
                            }
                            .font(AppTypography.labelLarge)
                            .foregroundColor(AppColors.primary)
                        }
                    }
                    
                    Spacer(minLength: AppSpacing.xl)
                }
                .padding(.horizontal, AppSpacing.xl)
                .frame(minHeight: geometry.size.height)
            }
        }
        .background(AppColors.background)
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Preview
#Preview {
    LoginView(viewModel: AuthenticationViewModel())
}