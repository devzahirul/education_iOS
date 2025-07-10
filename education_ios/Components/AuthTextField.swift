//
//  AuthTextField.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Auth Text Field Style
enum AuthTextFieldStyle {
    case standard
    case secure
    case email
    case name
}

// MARK: - Auth Text Field
struct AuthTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let style: AuthTextFieldStyle
    let isRequired: Bool
    let errorMessage: String?
    
    @State private var isSecureTextVisible = false
    @FocusState private var isFocused: Bool
    
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        style: AuthTextFieldStyle = .standard,
        isRequired: Bool = true,
        errorMessage: String? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.isRequired = isRequired
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Field Title
            HStack(spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.labelLarge)
                    .foregroundColor(AppColors.textPrimary)
                
                if isRequired {
                    Text("*")
                        .font(AppTypography.labelLarge)
                        .foregroundColor(AppColors.error)
                }
            }
            
            // Input Field
            HStack(spacing: AppSpacing.sm) {
                // Leading Icon
                Image(systemName: leadingIconName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isFocused ? AppColors.primary : AppColors.textSecondary)
                    .frame(width: 20)
                
                // Text Input
                Group {
                    if style == .secure && !isSecureTextVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(AppTypography.bodyLarge)
                .foregroundColor(AppColors.textPrimary)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .autocapitalization(autocapitalizationType)
                .disableAutocorrection(shouldDisableAutocorrection)
                
                // Trailing Icon (for secure fields)
                if style == .secure {
                    Button(action: {
                        isSecureTextVisible.toggle()
                    }) {
                        Image(systemName: isSecureTextVisible ? "eye.slash" : "eye")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm + 2)
            .background(AppColors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.md))
            
            // Error Message
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(AppTypography.labelMedium)
                    .foregroundColor(errorMessage.contains("success") ? AppColors.success : AppColors.error)
                    .padding(.leading, AppSpacing.xs)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var leadingIconName: String {
        switch style {
        case .standard:
            return "textformat"
        case .secure:
            return "lock"
        case .email:
            return "envelope"
        case .name:
            return "person"
        }
    }
    
    private var keyboardType: UIKeyboardType {
        switch style {
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }
    
    private var autocapitalizationType: TextInputAutocapitalization {
        switch style {
        case .email:
            return .never
        case .name:
            return .words
        default:
            return .sentences
        }
    }
    
    private var shouldDisableAutocorrection: Bool {
        switch style {
        case .email, .secure:
            return true
        default:
            return false
        }
    }
    
    private var borderColor: Color {
        if let errorMessage = errorMessage, !errorMessage.isEmpty && !errorMessage.contains("success") {
            return AppColors.error
        } else if isFocused {
            return AppColors.primary
        } else {
            return AppColors.textSecondary.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        return isFocused || (errorMessage != nil && !errorMessage!.isEmpty) ? 1.5 : 1
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.lg) {
        AuthTextField(
            title: "Full Name",
            placeholder: "Enter your full name",
            text: .constant(""),
            style: .name
        )
        
        AuthTextField(
            title: "Email Address",
            placeholder: "Enter your email",
            text: .constant(""),
            style: .email
        )
        
        AuthTextField(
            title: "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            style: .secure
        )
        
        AuthTextField(
            title: "Email Address",
            placeholder: "Enter your email",
            text: .constant("test@"),
            style: .email,
            errorMessage: "Please enter a valid email address"
        )
        
        AuthTextField(
            title: "Email Address",
            placeholder: "Enter your email",
            text: .constant("test@example.com"),
            style: .email,
            errorMessage: "Password reset email sent successfully"
        )
    }
    .padding()
    .background(AppColors.background)
}