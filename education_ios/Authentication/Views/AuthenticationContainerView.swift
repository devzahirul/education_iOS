//
//  AuthenticationContainerView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct AuthenticationContainerView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppColors.background
                    .ignoresSafeArea()
                
                // Authentication Screens
                switch viewModel.currentScreen {
                case .login:
                    LoginView(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)
                        ))
                
                case .signUp:
                    SignUpView(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                
                case .forgotPassword:
                    ForgotPasswordView(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentScreen)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.checkAuthenticationStatus()
        }
    }
}

// MARK: - Preview
#Preview {
    AuthenticationContainerView()
}