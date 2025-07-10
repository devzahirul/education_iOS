//
//  AuthenticationShowcaseView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct AuthenticationShowcaseView: View {
    @State private var selectedScreen: AuthenticationScreen = .login
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Screen Selector
                Picker("Authentication Screen", selection: $selectedScreen) {
                    Text("Login").tag(AuthenticationScreen.login)
                    Text("Sign Up").tag(AuthenticationScreen.signUp)
                    Text("Forgot Password").tag(AuthenticationScreen.forgotPassword)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Selected Screen
                Group {
                    switch selectedScreen {
                    case .login:
                        LoginView(viewModel: viewModel)
                    case .signUp:
                        SignUpView(viewModel: viewModel)
                    case .forgotPassword:
                        ForgotPasswordView(viewModel: viewModel)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: selectedScreen)
            }
            .navigationTitle("Authentication Screens")
            .onReceive(viewModel.$currentScreen) { screen in
                selectedScreen = screen
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AuthenticationShowcaseView()
}