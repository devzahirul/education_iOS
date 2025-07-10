//
//  AuthenticationModel.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI
import Foundation

// MARK: - User Model
struct User: Identifiable, Codable {
    let id = UUID()
    let email: String
    let firstName: String
    let lastName: String
    let profileImageURL: String?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

// MARK: - Authentication State
enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated(User)
}

// MARK: - Authentication Screen Type
enum AuthenticationScreen {
    case login
    case signUp
    case forgotPassword
}

// MARK: - Form Validation
struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?
    
    static let valid = ValidationResult(isValid: true, errorMessage: nil)
    static func invalid(_ message: String) -> ValidationResult {
        ValidationResult(isValid: false, errorMessage: message)
    }
}

// MARK: - Authentication View Model
@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var state: AuthenticationState = .unauthenticated
    @Published var currentScreen: AuthenticationScreen = .login
    @Published var isLoading: Bool = false
    
    // Login Form
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    
    // Sign Up Form
    @Published var signUpFirstName: String = ""
    @Published var signUpLastName: String = ""
    @Published var signUpEmail: String = ""
    @Published var signUpPassword: String = ""
    @Published var signUpConfirmPassword: String = ""
    
    // Forgot Password Form
    @Published var forgotPasswordEmail: String = ""
    
    // Form Validation
    @Published var loginEmailError: String? = nil
    @Published var loginPasswordError: String? = nil
    @Published var signUpFirstNameError: String? = nil
    @Published var signUpLastNameError: String? = nil
    @Published var signUpEmailError: String? = nil
    @Published var signUpPasswordError: String? = nil
    @Published var signUpConfirmPasswordError: String? = nil
    @Published var forgotPasswordEmailError: String? = nil
    
    // MARK: - Navigation Actions
    func showLogin() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .login
            clearErrors()
        }
    }
    
    func showSignUp() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .signUp
            clearErrors()
        }
    }
    
    func showForgotPassword() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .forgotPassword
            clearErrors()
        }
    }
    
    // MARK: - Authentication Actions
    func login() async {
        guard validateLoginForm() else { return }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Mock successful login
        let user = User(
            email: loginEmail,
            firstName: "John",
            lastName: "Doe",
            profileImageURL: nil
        )
        
        withAnimation(.easeInOut(duration: 0.5)) {
            state = .authenticated(user)
            isLoading = false
        }
        
        // Save authentication state
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        UserDefaults.standard.set(loginEmail, forKey: "userEmail")
    }
    
    func signUp() async {
        guard validateSignUpForm() else { return }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Mock successful sign up
        let user = User(
            email: signUpEmail,
            firstName: signUpFirstName,
            lastName: signUpLastName,
            profileImageURL: nil
        )
        
        withAnimation(.easeInOut(duration: 0.5)) {
            state = .authenticated(user)
            isLoading = false
        }
        
        // Save authentication state
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        UserDefaults.standard.set(signUpEmail, forKey: "userEmail")
    }
    
    func forgotPassword() async {
        guard validateForgotPasswordForm() else { return }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        isLoading = false
        
        // Show success message and navigate back to login
        showLogin()
    }
    
    func logout() {
        withAnimation(.easeInOut(duration: 0.5)) {
            state = .unauthenticated
            currentScreen = .login
        }
        
        // Clear stored authentication state
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        clearAllForms()
    }
    
    // MARK: - Form Validation
    private func validateLoginForm() -> Bool {
        clearErrors()
        var isValid = true
        
        // Email validation
        let emailValidation = validateEmail(loginEmail)
        if !emailValidation.isValid {
            loginEmailError = emailValidation.errorMessage
            isValid = false
        }
        
        // Password validation
        let passwordValidation = validatePassword(loginPassword)
        if !passwordValidation.isValid {
            loginPasswordError = passwordValidation.errorMessage
            isValid = false
        }
        
        return isValid
    }
    
    private func validateSignUpForm() -> Bool {
        clearErrors()
        var isValid = true
        
        // First name validation
        if signUpFirstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            signUpFirstNameError = "First name is required"
            isValid = false
        }
        
        // Last name validation
        if signUpLastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            signUpLastNameError = "Last name is required"
            isValid = false
        }
        
        // Email validation
        let emailValidation = validateEmail(signUpEmail)
        if !emailValidation.isValid {
            signUpEmailError = emailValidation.errorMessage
            isValid = false
        }
        
        // Password validation
        let passwordValidation = validatePassword(signUpPassword)
        if !passwordValidation.isValid {
            signUpPasswordError = passwordValidation.errorMessage
            isValid = false
        }
        
        // Confirm password validation
        if signUpPassword != signUpConfirmPassword {
            signUpConfirmPasswordError = "Passwords don't match"
            isValid = false
        }
        
        return isValid
    }
    
    private func validateForgotPasswordForm() -> Bool {
        clearErrors()
        
        let emailValidation = validateEmail(forgotPasswordEmail)
        if !emailValidation.isValid {
            forgotPasswordEmailError = emailValidation.errorMessage
            return false
        }
        
        return true
    }
    
    private func validateEmail(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            return .invalid("Email is required")
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: trimmedEmail) {
            return .invalid("Please enter a valid email address")
        }
        
        return .valid
    }
    
    private func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .invalid("Password is required")
        }
        
        if password.count < 6 {
            return .invalid("Password must be at least 6 characters")
        }
        
        return .valid
    }
    
    // MARK: - Helper Methods
    private func clearErrors() {
        loginEmailError = nil
        loginPasswordError = nil
        signUpFirstNameError = nil
        signUpLastNameError = nil
        signUpEmailError = nil
        signUpPasswordError = nil
        signUpConfirmPasswordError = nil
        forgotPasswordEmailError = nil
    }
    
    private func clearAllForms() {
        loginEmail = ""
        loginPassword = ""
        signUpFirstName = ""
        signUpLastName = ""
        signUpEmail = ""
        signUpPassword = ""
        signUpConfirmPassword = ""
        forgotPasswordEmail = ""
        clearErrors()
    }
    
    // MARK: - Lifecycle
    func checkAuthenticationStatus() {
        let isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        if isAuthenticated, let email = UserDefaults.standard.string(forKey: "userEmail") {
            // Mock user recreation from stored data
            let user = User(
                email: email,
                firstName: "John",
                lastName: "Doe",
                profileImageURL: nil
            )
            state = .authenticated(user)
        } else {
            state = .unauthenticated
        }
    }
}