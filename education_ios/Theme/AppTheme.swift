//
//  AppTheme.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Color Theme
struct AppColors {
    // Primary Colors
    static let primary = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let primaryLight = Color(red: 0.3, green: 0.5, blue: 0.9)
    static let primaryDark = Color(red: 0.1, green: 0.3, blue: 0.7)
    
    // Secondary Colors
    static let secondary = Color(red: 0.9, green: 0.5, blue: 0.2)
    static let secondaryLight = Color(red: 1.0, green: 0.6, blue: 0.3)
    static let secondaryDark = Color(red: 0.8, green: 0.4, blue: 0.1)
    
    // Onboarding Colors
    static let onboarding1 = Color(red: 0.3, green: 0.7, blue: 0.9)
    static let onboarding2 = Color(red: 0.9, green: 0.6, blue: 0.3)
    static let onboarding3 = Color(red: 0.7, green: 0.3, blue: 0.9)
    static let onboarding4 = Color(red: 0.3, green: 0.9, blue: 0.5)
    
    // Neutral Colors
    static let background = Color(.systemBackground)
    static let surface = Color(.secondarySystemBackground)
    static let onSurface = Color(.label)
    static let onBackground = Color(.label)
    static let surfaceVariant = Color(.tertiarySystemBackground)
    
    // Text Colors
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)
    
    // System Colors
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let white = Color.white
    static let black = Color.black
}

// MARK: - Typography
struct AppTypography {
    // Display Styles
    static let displayLarge = Font.system(size: 57, weight: .regular, design: .default)
    static let displayMedium = Font.system(size: 45, weight: .regular, design: .default)
    static let displaySmall = Font.system(size: 36, weight: .regular, design: .default)
    
    // Headline Styles
    static let headlineLarge = Font.system(size: 32, weight: .bold, design: .default)
    static let headlineMedium = Font.system(size: 28, weight: .bold, design: .default)
    static let headlineSmall = Font.system(size: 24, weight: .bold, design: .default)
    
    // Title Styles
    static let titleLarge = Font.system(size: 22, weight: .semibold, design: .default)
    static let titleMedium = Font.system(size: 16, weight: .semibold, design: .default)
    static let titleSmall = Font.system(size: 14, weight: .semibold, design: .default)
    
    // Body Styles
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)
    
    // Label Styles
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)
}

// MARK: - Spacing
struct AppSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - Shadow
struct AppShadow {
    static let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    static let medium = Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    static let large = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}