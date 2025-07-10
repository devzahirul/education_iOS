//
//  LoadingIndicator.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Loading Indicator Style
enum LoadingIndicatorStyle {
    case small
    case medium
    case large
    
    var size: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 24
        case .large: return 32
        }
    }
}

// MARK: - Loading Indicator
struct LoadingIndicator: View {
    let style: LoadingIndicatorStyle
    let color: Color
    
    init(style: LoadingIndicatorStyle = .medium, color: Color = AppColors.primary) {
        self.style = style
        self.color = color
    }
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(style.size / 24) // Base size is 24
    }
}

// MARK: - Pulse Loading Indicator
struct PulseLoadingIndicator: View {
    let style: LoadingIndicatorStyle
    let color: Color
    @State private var isAnimating = false
    
    init(style: LoadingIndicatorStyle = .medium, color: Color = AppColors.primary) {
        self.style = style
        self.color = color
    }
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: style.size, height: style.size)
            .scaleEffect(isAnimating ? 1.2 : 0.8)
            .opacity(isAnimating ? 0.3 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Dots Loading Indicator
struct DotsLoadingIndicator: View {
    let style: LoadingIndicatorStyle
    let color: Color
    @State private var animationOffset: CGFloat = 0
    
    private let dotCount = 3
    private var dotSize: CGFloat { style.size * 0.3 }
    private var spacing: CGFloat { style.size * 0.2 }
    
    init(style: LoadingIndicatorStyle = .medium, color: Color = AppColors.primary) {
        self.style = style
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .offset(y: animationOffset)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animationOffset
                    )
            }
        }
        .onAppear {
            animationOffset = -dotSize * 0.5
        }
    }
}

// MARK: - Loading Overlay
struct LoadingOverlay: View {
    let isVisible: Bool
    let message: String?
    let style: LoadingIndicatorStyle
    
    init(isVisible: Bool, message: String? = nil, style: LoadingIndicatorStyle = .large) {
        self.isVisible = isVisible
        self.message = message
        self.style = style
    }
    
    var body: some View {
        if isVisible {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.md) {
                    LoadingIndicator(style: style, color: AppColors.white)
                    
                    if let message = message {
                        Text(message)
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(AppSpacing.xl)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                        .fill(Color.black.opacity(0.8))
                )
            }
            .transition(.opacity)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.xl) {
        HStack(spacing: AppSpacing.lg) {
            LoadingIndicator(style: .small)
            LoadingIndicator(style: .medium)
            LoadingIndicator(style: .large)
        }
        
        HStack(spacing: AppSpacing.lg) {
            PulseLoadingIndicator(style: .small)
            PulseLoadingIndicator(style: .medium)
            PulseLoadingIndicator(style: .large)
        }
        
        HStack(spacing: AppSpacing.lg) {
            DotsLoadingIndicator(style: .small)
            DotsLoadingIndicator(style: .medium)
            DotsLoadingIndicator(style: .large)
        }
        
        LoadingOverlay(isVisible: true, message: "Loading...")
    }
    .padding()
}