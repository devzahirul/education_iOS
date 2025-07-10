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
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Header Section
                    VStack(spacing: AppSpacing.lg) {
                        // Back Button
                        HStack {
                            Button(action: {
                                viewModel.showLogin()
                            }) {
                                HStack(spacing: AppSpacing.xs) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Back")
                                        .font(AppTypography.labelLarge)
                                }
                                .foregroundColor(AppColors.primary)
                            }
                            Spacer()
                        }
                        
                        // Icon
                        Image(systemName: "key.horizontal.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primary)
                            .scaleEffect(1.0)
                            .animation(.easeInOut(duration: 0.6), value: true)
                        
                        // Title and Description
                        VStack(spacing: AppSpacing.sm) {
                            Text("Forgot Password?")
                                .font(AppTypography.headlineLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Don't worry! Enter your email address and we'll send you a link to reset your password.")
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                    }
                    .padding(.top, AppSpacing.lg)
                    
                    // Reset Form
                    VStack(spacing: AppSpacing.xl) {
                        // Email Field
                        AppTextField(
                            "Email",
                            placeholder: "Enter your email address",
                            text: $viewModel.forgotPasswordEmail,
                            type: .email,
                            errorMessage: viewModel.forgotPasswordEmailError
                        )
                        
                        // Send Reset Link Button
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
                    }
                    
                    Spacer(minLength: AppSpacing.xl)
                    
                    // Alternative Actions
                    VStack(spacing: AppSpacing.md) {
                        Text("Remember your password?")
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Button("Back to Sign In") {
                            viewModel.showLogin()
                        }
                        .font(AppTypography.labelLarge)
                        .foregroundColor(AppColors.primary)
                    }
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
    ForgotPasswordView(viewModel: AuthenticationViewModel())
}