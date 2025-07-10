//
//  ForgotPasswordView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                // Logo and Header Section
                VStack(spacing: AppSpacing.lg) {
                    // App Logo/Icon
                    VStack(spacing: AppSpacing.md) {
                        Image(systemName: "key.horizontal")
                            .font(.system(size: 80, weight: .medium))
                            .foregroundColor(AppColors.primary)
                        
                        VStack(spacing: AppSpacing.xs) {
                            Text("Forgot Password?")
                                .font(AppTypography.headlineLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("No worries! Enter your email address and we'll send you a reset link")
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, AppSpacing.md)
                        }
                    }
                }
                .padding(.top, AppSpacing.xl)
                
                // Reset Form
                VStack(spacing: AppSpacing.lg) {
                    // Email Field
                    AuthTextField(
                        title: "Email Address",
                        placeholder: "Enter your email",
                        text: $viewModel.forgotPasswordEmail,
                        style: .email,
                        errorMessage: viewModel.errorMessage?.contains("email") == true ? viewModel.errorMessage : nil
                    )
                    
                    // General Message (Error or Success)
                    if let message = viewModel.errorMessage,
                       !message.contains("email") {
                        Text(message)
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(message.contains("success") ? AppColors.success : AppColors.error)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppSpacing.md)
                    }
                    
                    // Reset Button
                    AppButton(
                        "Send Reset Link",
                        style: .primary,
                        size: .large,
                        isLoading: viewModel.isLoading
                    ) {
                        Task {
                            await viewModel.forgotPassword()
                        }
                    }
                    .padding(.top, AppSpacing.sm)
                    
                    // Instructions
                    VStack(spacing: AppSpacing.sm) {
                        Text("Instructions:")
                            .font(AppTypography.labelLarge)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                        
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            instructionRow("1.", "Check your email inbox")
                            instructionRow("2.", "Click the reset link in the email")
                            instructionRow("3.", "Create a new password")
                            instructionRow("4.", "Sign in with your new password")
                        }
                    }
                    .padding(.all, AppSpacing.md)
                    .background(AppColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.md))
                    .padding(.top, AppSpacing.lg)
                }
                
                // Back to Sign In Section
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
                    
                    // Back to Sign In Link
                    HStack(spacing: AppSpacing.xs) {
                        Text("Remember your password?")
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
                .padding(.top, AppSpacing.xl)
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColors.background)
        .navigationBarHidden(true)
    }
    
    // MARK: - Helper Views
    private func instructionRow(_ number: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Text(number)
                .font(AppTypography.labelMedium)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primary)
                .frame(width: 20, alignment: .leading)
            
            Text(text)
                .font(AppTypography.bodyMedium)
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    ForgotPasswordView(viewModel: AuthenticationViewModel())
}