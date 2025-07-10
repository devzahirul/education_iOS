//
//  AuthenticationContainerView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct AuthenticationContainerView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    let onAuthentication: ((User) -> Void)?
    
    init(onAuthentication: ((User) -> Void)? = nil) {
        self.onAuthentication = onAuthentication
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppColors.background
                    .ignoresSafeArea()
                
                // Authentication Views
                switch authViewModel.screenState {
                case .login:
                    LoginView(viewModel: authViewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)
                        ))
                    
                case .signUp:
                    SignUpView(viewModel: authViewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                    
                case .forgotPassword:
                    ForgotPasswordView(viewModel: authViewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .top)
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authViewModel.screenState)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper behavior on all devices
        .onAppear {
            authViewModel.checkAuthenticationStatus()
        }
        .onChange(of: authViewModel.state) { newState in
            if case .authenticated(let user) = newState {
                onAuthentication?(user)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AuthenticationContainerView()
}