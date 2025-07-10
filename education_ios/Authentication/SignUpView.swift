//
//  SignUpView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                // Logo and Welcome Section
                VStack(spacing: AppSpacing.lg) {
                    // App Logo/Icon
                    VStack(spacing: AppSpacing.md) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 80, weight: .medium))
                            .foregroundColor(AppColors.secondary)
                        
                        VStack(spacing: AppSpacing.xs) {
                            Text("Create Account")
                                .font(AppTypography.headlineLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Join thousands of learners worldwide")
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.top, AppSpacing.xl)
                
                // Sign Up Form
                VStack(spacing: AppSpacing.lg) {
                    VStack(spacing: AppSpacing.md) {
                        // Name Field
                        AuthTextField(
                            title: "Full Name",
                            placeholder: "Enter your full name",
                            text: $viewModel.signUpName,
                            style: .name,
                            errorMessage: viewModel.errorMessage?.contains("name") == true ? viewModel.errorMessage : nil
                        )
                        
                        // Email Field
                        AuthTextField(
                            title: "Email Address",
                            placeholder: "Enter your email",
                            text: $viewModel.signUpEmail,
                            style: .email,
                            errorMessage: viewModel.errorMessage?.contains("email") == true ? viewModel.errorMessage : nil
                        )
                        
                        // Password Field
                        AuthTextField(
                            title: "Password",
                            placeholder: "Enter your password",
                            text: $viewModel.signUpPassword,
                            style: .secure,
                            errorMessage: viewModel.errorMessage?.contains("Password must") == true ? viewModel.errorMessage : nil
                        )
                        
                        // Confirm Password Field
                        AuthTextField(
                            title: "Confirm Password",
                            placeholder: "Confirm your password",
                            text: $viewModel.signUpConfirmPassword,
                            style: .secure,
                            errorMessage: viewModel.errorMessage?.contains("match") == true ? viewModel.errorMessage : nil
                        )
                    }
                    
                    // Terms and Privacy Notice
                    VStack(spacing: AppSpacing.sm) {
                        Text("By creating an account, you agree to our")
                            .font(AppTypography.bodySmall)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: AppSpacing.xs) {
                            Button("Terms of Service") {
                                // Handle terms of service
                            }
                            .font(AppTypography.bodySmall)
                            .foregroundColor(AppColors.primary)
                            
                            Text("and")
                                .font(AppTypography.bodySmall)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Button("Privacy Policy") {
                                // Handle privacy policy
                            }
                            .font(AppTypography.bodySmall)
                            .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // General Error Message
                    if let errorMessage = viewModel.errorMessage,
                       !errorMessage.contains("email") && !errorMessage.contains("name") && 
                       !errorMessage.contains("Password must") && !errorMessage.contains("match") {
                        Text(errorMessage)
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.error)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppSpacing.md)
                    }
                    
                    // Sign Up Button
                    AppButton(
                        "Create Account",
                        style: .secondary,
                        size: .large,
                        isLoading: viewModel.isLoading
                    ) {
                        Task {
                            await viewModel.signUp()
                        }
                    }
                    .padding(.top, AppSpacing.sm)
                }
                
                // Sign In Section
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
                    
                    // Sign In Link
                    HStack(spacing: AppSpacing.xs) {
                        Text("Already have an account?")
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Button(action: {
                            viewModel.switchToLogin()
                        }) {
                            Text("Sign In")
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
    SignUpView(viewModel: AuthenticationViewModel())
}