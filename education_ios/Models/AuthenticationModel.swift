//
//  AuthenticationModel.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI
import Foundation

// MARK: - Authentication State
enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated(user: User)
}

// MARK: - Authentication Screen State
enum AuthScreenState {
    case login
    case signUp
    case forgotPassword
}

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let name: String
    let profileImageURL: String?
    
    init(id: UUID = UUID(), email: String, name: String, profileImageURL: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
    }
}

// MARK: - Login Request
struct LoginRequest {
    let email: String
    let password: String
}

// MARK: - Sign Up Request
struct SignUpRequest {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
}

// MARK: - Forgot Password Request
struct ForgotPasswordRequest {
    let email: String
}

// MARK: - Authentication Error
enum AuthenticationError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case passwordMismatch
    case emptyFields
    case networkError
    case userNotFound
    case emailAlreadyExists
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Password must be at least 6 characters long"
        case .passwordMismatch:
            return "Passwords do not match"
        case .emptyFields:
            return "Please fill in all required fields"
        case .networkError:
            return "Network error. Please try again"
        case .userNotFound:
            return "User not found. Please check your credentials"
        case .emailAlreadyExists:
            return "An account with this email already exists"
        case .unknown:
            return "An unknown error occurred. Please try again"
        }
    }
}

// MARK: - Authentication View Model
@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var state: AuthenticationState = .unauthenticated
    @Published var screenState: AuthScreenState = .login
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Login fields
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    
    // Sign up fields
    @Published var signUpName: String = ""
    @Published var signUpEmail: String = ""
    @Published var signUpPassword: String = ""
    @Published var signUpConfirmPassword: String = ""
    
    // Forgot password fields
    @Published var forgotPasswordEmail: String = ""
    
    // MARK: - Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    // MARK: - Authentication Actions
    func login() async {
        clearError()
        
        // Validation
        guard !loginEmail.isEmpty && !loginPassword.isEmpty else {
            errorMessage = AuthenticationError.emptyFields.errorDescription
            return
        }
        
        guard isValidEmail(loginEmail) else {
            errorMessage = AuthenticationError.invalidEmail.errorDescription
            return
        }
        
        guard isValidPassword(loginPassword) else {
            errorMessage = AuthenticationError.invalidPassword.errorDescription
            return
        }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Simulate successful login
        let user = User(email: loginEmail, name: "John Doe")
        state = .authenticated(user: user)
        
        // Save authentication state
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        UserDefaults.standard.set(loginEmail, forKey: "userEmail")
        UserDefaults.standard.set("John Doe", forKey: "userName")
        
        isLoading = false
        clearLoginFields()
    }
    
    func signUp() async {
        clearError()
        
        // Validation
        guard !signUpName.isEmpty && !signUpEmail.isEmpty && 
              !signUpPassword.isEmpty && !signUpConfirmPassword.isEmpty else {
            errorMessage = AuthenticationError.emptyFields.errorDescription
            return
        }
        
        guard isValidEmail(signUpEmail) else {
            errorMessage = AuthenticationError.invalidEmail.errorDescription
            return
        }
        
        guard isValidPassword(signUpPassword) else {
            errorMessage = AuthenticationError.invalidPassword.errorDescription
            return
        }
        
        guard signUpPassword == signUpConfirmPassword else {
            errorMessage = AuthenticationError.passwordMismatch.errorDescription
            return
        }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Simulate successful sign up
        let user = User(email: signUpEmail, name: signUpName)
        state = .authenticated(user: user)
        
        // Save authentication state
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        UserDefaults.standard.set(signUpEmail, forKey: "userEmail")
        UserDefaults.standard.set(signUpName, forKey: "userName")
        
        isLoading = false
        clearSignUpFields()
    }
    
    func forgotPassword() async {
        clearError()
        
        guard !forgotPasswordEmail.isEmpty else {
            errorMessage = AuthenticationError.emptyFields.errorDescription
            return
        }
        
        guard isValidEmail(forgotPasswordEmail) else {
            errorMessage = AuthenticationError.invalidEmail.errorDescription
            return
        }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        isLoading = false
        
        // Show success message and go back to login
        errorMessage = "Password reset email sent successfully"
        clearForgotPasswordFields()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.screenState = .login
            self.clearError()
        }
    }
    
    func logout() {
        state = .unauthenticated
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        clearAllFields()
    }
    
    func checkAuthenticationStatus() {
        let isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        if isAuthenticated {
            let email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
            let name = UserDefaults.standard.string(forKey: "userName") ?? ""
            let user = User(email: email, name: name)
            state = .authenticated(user: user)
        }
    }
    
    // MARK: - Screen Navigation
    func switchToLogin() {
        screenState = .login
        clearError()
    }
    
    func switchToSignUp() {
        screenState = .signUp
        clearError()
    }
    
    func switchToForgotPassword() {
        screenState = .forgotPassword
        clearError()
    }
    
    // MARK: - Helper Methods
    private func clearError() {
        errorMessage = nil
    }
    
    private func clearLoginFields() {
        loginEmail = ""
        loginPassword = ""
    }
    
    private func clearSignUpFields() {
        signUpName = ""
        signUpEmail = ""
        signUpPassword = ""
        signUpConfirmPassword = ""
    }
    
    private func clearForgotPasswordFields() {
        forgotPasswordEmail = ""
    }
    
    private func clearAllFields() {
        clearLoginFields()
        clearSignUpFields()
        clearForgotPasswordFields()
    }
}