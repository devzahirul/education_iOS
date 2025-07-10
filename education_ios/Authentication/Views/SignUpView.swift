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
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Header Section
                    VStack(spacing: AppSpacing.lg) {
                        // Logo/Icon
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.secondary)
                            .scaleEffect(1.0)
                            .animation(.easeInOut(duration: 0.6), value: true)
                        
                        // Welcome Text
                        VStack(spacing: AppSpacing.sm) {
                            Text("Join EduApp")
                                .font(AppTypography.headlineLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Create your account to start learning")
                                .font(AppTypography.bodyLarge)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, AppSpacing.lg)
                    
                    // Sign Up Form
                    VStack(spacing: AppSpacing.lg) {
                        // Name Fields
                        HStack(spacing: AppSpacing.md) {
                            AppTextField(
                                "First Name",
                                placeholder: "First name",
                                text: $viewModel.signUpFirstName,
                                errorMessage: viewModel.signUpFirstNameError
                            )
                            
                            AppTextField(
                                "Last Name",
                                placeholder: "Last name",
                                text: $viewModel.signUpLastName,
                                errorMessage: viewModel.signUpLastNameError
                            )
                        }
                        
                        // Email Field
                        AppTextField(
                            "Email",
                            placeholder: "Enter your email address",
                            text: $viewModel.signUpEmail,
                            type: .email,
                            errorMessage: viewModel.signUpEmailError
                        )
                        
                        // Password Field
                        AppTextField(
                            "Password",
                            placeholder: "Create a password",
                            text: $viewModel.signUpPassword,
                            type: .secure,
                            errorMessage: viewModel.signUpPasswordError
                        )
                        
                        // Confirm Password Field
                        AppTextField(
                            "Confirm Password",
                            placeholder: "Confirm your password",
                            text: $viewModel.signUpConfirmPassword,
                            type: .secure,
                            errorMessage: viewModel.signUpConfirmPasswordError
                        )
                    }
                    
                    // Terms and Privacy
                    VStack(spacing: AppSpacing.sm) {
                        Text("By creating an account, you agree to our")
                            .font(AppTypography.bodySmall)
                            .foregroundColor(AppColors.textSecondary)
                        
                        HStack(spacing: AppSpacing.xs) {
                            Button("Terms of Service") {
                                // Handle terms of service
                            }
                            .font(AppTypography.labelMedium)
                            .foregroundColor(AppColors.primary)
                            
                            Text("and")
                                .font(AppTypography.bodySmall)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Button("Privacy Policy") {
                                // Handle privacy policy
                            }
                            .font(AppTypography.labelMedium)
                            .foregroundColor(AppColors.primary)
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: AppSpacing.md) {
                        // Sign Up Button
                        AppButton(
                            "Create Account",
                            style: .primary,
                            size: .large,
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.signUp()
                            }
                        }
                        
                        // Login Link
                        HStack(spacing: AppSpacing.xs) {
                            Text("Already have an account?")
                                .font(AppTypography.bodyMedium)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Button("Sign In") {
                                viewModel.showLogin()
                            }
                            .font(AppTypography.labelLarge)
                            .foregroundColor(AppColors.primary)
                        }
                    }
                    
                    Spacer(minLength: AppSpacing.lg)
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
    SignUpView(viewModel: AuthenticationViewModel())
}