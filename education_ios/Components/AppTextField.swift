//
//  AppTextField.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Text Field Style Enum
enum AppTextFieldStyle {
    case standard
    case outlined
}

// MARK: - Text Field Type Enum
enum AppTextFieldType {
    case text
    case email
    case password
    case secure
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .text, .password, .secure:
            return .default
        case .email:
            return .emailAddress
        }
    }
    
    var autocapitalization: TextInputAutocapitalization {
        switch self {
        case .text:
            return .words
        case .email, .password, .secure:
            return .never
        }
    }
}

// MARK: - AppTextField
struct AppTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let style: AppTextFieldStyle
    let type: AppTextFieldType
    let errorMessage: String?
    let isDisabled: Bool
    
    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool
    
    init(
        _ title: String = "",
        placeholder: String,
        text: Binding<String>,
        style: AppTextFieldStyle = .outlined,
        type: AppTextFieldType = .text,
        errorMessage: String? = nil,
        isDisabled: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.type = type
        self.errorMessage = errorMessage
        self.isDisabled = isDisabled
        self._isSecure = State(initialValue: type == .secure || type == .password)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Title
            if !title.isEmpty {
                Text(title)
                    .font(AppTypography.labelLarge)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            // Text Field Container
            HStack(spacing: AppSpacing.sm) {
                // Input Field
                Group {
                    if (type == .secure || type == .password) && isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(AppTypography.bodyLarge)
                .foregroundColor(AppColors.textPrimary)
                .textInputAutocapitalization(type.autocapitalization)
                .keyboardType(type.keyboardType)
                .autocorrectionDisabled()
                .focused($isFocused)
                
                // Secure Toggle Button
                if type == .secure || type == .password {
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.md))
            
            // Error Message
            if let errorMessage = errorMessage {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.error)
                    
                    Text(errorMessage)
                        .font(AppTypography.labelSmall)
                        .foregroundColor(AppColors.error)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .standard:
            return AppColors.surface
        case .outlined:
            return AppColors.background
        }
    }
    
    private var borderColor: Color {
        if let _ = errorMessage {
            return AppColors.error
        }
        
        if isFocused {
            return AppColors.primary
        }
        
        switch style {
        case .standard:
            return Color.clear
        case .outlined:
            return AppColors.textTertiary.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        if let _ = errorMessage {
            return 1.5
        }
        
        if isFocused {
            return 2
        }
        
        switch style {
        case .standard:
            return 0
        case .outlined:
            return 1
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.lg) {
        AppTextField(
            "Email",
            placeholder: "Enter your email",
            text: .constant(""),
            type: .email
        )
        
        AppTextField(
            "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            type: .secure
        )
        
        AppTextField(
            "Name",
            placeholder: "Enter your name",
            text: .constant("John Doe"),
            errorMessage: "This field is required"
        )
        
        AppTextField(
            placeholder: "Standard style",
            text: .constant(""),
            style: .standard
        )
        
        AppTextField(
            placeholder: "Disabled field",
            text: .constant(""),
            isDisabled: true
        )
    }
    .padding()
}