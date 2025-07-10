//
//  LoginView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                // Logo and Welcome Section
                VStack(spacing: AppSpacing.lg) {
                    // App Logo/Icon
                    VStack(spacing: AppSpacing.md) {
                        Image(systemName: "graduationcap.circle.fill")
                            .font(.system(size: 80, weight: .medium))
                            .foregroundColor(AppColors.primary)
                        
                        VStack(spacing: AppSpacing.xs) {
                            Text("Welcome Back")
                                .font(AppTypography.headlineLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Sign in to continue your learning journey")
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.top, AppSpacing.xl)
                
                // Login Form
                VStack(spacing: AppSpacing.lg) {
                    VStack(spacing: AppSpacing.md) {
                        // Email Field
                        AuthTextField(
                            title: "Email Address",
                            placeholder: "Enter your email",
                            text: $viewModel.loginEmail,
                            style: .email,
                            errorMessage: viewModel.errorMessage?.contains("email") == true ? viewModel.errorMessage : nil
                        )
                        
                        // Password Field
                        AuthTextField(
                            title: "Password",
                            placeholder: "Enter your password",
                            text: $viewModel.loginPassword,
                            style: .secure,
                            errorMessage: viewModel.errorMessage?.contains("password") == true || viewModel.errorMessage?.contains("Password") == true ? viewModel.errorMessage : nil
                        )
                    }
                    
                    // Forgot Password Link
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.switchToForgotPassword()
                        }) {
                            Text("Forgot Password?")
                                .font(AppTypography.labelLarge)
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    
                    // General Error Message
                    if let errorMessage = viewModel.errorMessage,
                       !errorMessage.contains("email") && !errorMessage.contains("password") && !errorMessage.contains("Password") {
                        Text(errorMessage)
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.error)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppSpacing.md)
                    }
                    
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
                    .padding(.top, AppSpacing.sm)
                }
                
                // Sign Up Section
                VStack(spacing: AppSpacing.md) {
                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(AppColors.textSecondary.opacity(0.3))
                        
                        Text("OR")
                            .font(AppTypography.labelMedium)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, AppSpacing.md)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(AppColors.textSecondary.opacity(0.3))
                    }
                    
                    // Sign Up Link
                    HStack(spacing: AppSpacing.xs) {
                        Text("Don't have an account?")
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Button(action: {
                            viewModel.switchToSignUp()
                        }) {
                            Text("Sign Up")
                                .font(AppTypography.bodyMedium)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.primary)
                        }
                    }
                }
                .padding(.top, AppSpacing.lg)
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColors.background)
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
#Preview {
    LoginView(viewModel: AuthenticationViewModel())
}