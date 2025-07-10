//
//  AppButton.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Button Style Enum
enum AppButtonStyle {
    case primary
    case secondary
    case outline
    case text
}

// MARK: - Button Size Enum
enum AppButtonSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 44
        case .large: return 56
        }
    }
    
    var font: Font {
        switch self {
        case .small: return AppTypography.labelMedium
        case .medium: return AppTypography.labelLarge
        case .large: return AppTypography.titleMedium
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        case .medium: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        case .large: return EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        }
    }
}

// MARK: - AppButton
struct AppButton: View {
    let title: String
    let style: AppButtonStyle
    let size: AppButtonSize
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        _ title: String,
        style: AppButtonStyle = .primary,
        size: AppButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if !isDisabled && !isLoading {
                action()
            }
        }) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                }
                
                if !isLoading || !title.isEmpty {
                    Text(title)
                        .font(size.font)
                        .fontWeight(.medium)
                }
            }
            .foregroundColor(textColor)
            .padding(size.padding)
            .frame(minHeight: size.height)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.md))
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return AppColors.primary
        case .secondary:
            return AppColors.secondary
        case .outline:
            return Color.clear
        case .text:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .secondary:
            return AppColors.white
        case .outline:
            return AppColors.primary
        case .text:
            return AppColors.primary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary, .secondary:
            return Color.clear
        case .outline:
            return AppColors.primary
        case .text:
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .secondary, .text:
            return 0
        case .outline:
            return 1
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.md) {
        AppButton("Primary Button", style: .primary, size: .large) {}
        AppButton("Secondary Button", style: .secondary, size: .medium) {}
        AppButton("Outline Button", style: .outline, size: .medium) {}
        AppButton("Text Button", style: .text, size: .small) {}
        AppButton("Loading Button", style: .primary, isLoading: true) {}
        AppButton("Disabled Button", style: .primary, isDisabled: true) {}
    }
    .padding()
}