//
//  AppCard.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Card Style
enum AppCardStyle {
    case elevated
    case outlined
    case filled
}

// MARK: - App Card
struct AppCard<Content: View>: View {
    let style: AppCardStyle
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let padding: EdgeInsets
    let content: () -> Content
    
    init(
        style: AppCardStyle = .elevated,
        backgroundColor: Color = AppColors.surface,
        cornerRadius: CGFloat = AppCornerRadius.md,
        padding: EdgeInsets = EdgeInsets(
            top: AppSpacing.md,
            leading: AppSpacing.md,
            bottom: AppSpacing.md,
            trailing: AppSpacing.md
        ),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
    
    private var borderColor: Color {
        switch style {
        case .elevated, .filled:
            return Color.clear
        case .outlined:
            return AppColors.textTertiary.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .elevated, .filled:
            return 0
        case .outlined:
            return 1
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .elevated:
            return .black.opacity(0.1)
        case .outlined, .filled:
            return .clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .elevated:
            return 4
        case .outlined, .filled:
            return 0
        }
    }
    
    private var shadowOffset: CGSize {
        switch style {
        case .elevated:
            return CGSize(width: 0, height: 2)
        case .outlined, .filled:
            return .zero
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.lg) {
        AppCard(style: .elevated) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Elevated Card")
                    .font(AppTypography.titleMedium)
                    .fontWeight(.semibold)
                
                Text("This is an elevated card with shadow")
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        
        AppCard(style: .outlined) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Outlined Card")
                    .font(AppTypography.titleMedium)
                    .fontWeight(.semibold)
                
                Text("This is an outlined card with border")
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        
        AppCard(style: .filled, backgroundColor: AppColors.primary.opacity(0.1)) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Filled Card")
                    .font(AppTypography.titleMedium)
                    .fontWeight(.semibold)
                
                Text("This is a filled card with background color")
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
    .padding()
}