//
//  ComponentsShowcaseView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

/// A showcase view demonstrating all reusable components
/// This can be used for development and testing purposes
struct ComponentsShowcaseView: View {
    @State private var currentPage = 0
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Buttons Section
                    VStack(spacing: AppSpacing.md) {
                        Text("Buttons")
                            .font(AppTypography.headlineSmall)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: AppSpacing.sm) {
                            AppButton("Primary Button", style: .primary) {
                                toggleLoading()
                            }
                            
                            AppButton("Secondary Button", style: .secondary) {
                                toggleLoading()
                            }
                            
                            AppButton("Outline Button", style: .outline) {
                                toggleLoading()
                            }
                            
                            AppButton("Text Button", style: .text) {
                                toggleLoading()
                            }
                            
                            AppButton("Loading Button", style: .primary, isLoading: isLoading) {
                                toggleLoading()
                            }
                            
                            AppButton("Disabled Button", style: .primary, isDisabled: true) {
                                // No action
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Loading Indicators Section
                    VStack(spacing: AppSpacing.md) {
                        Text("Loading Indicators")
                            .font(AppTypography.headlineSmall)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: AppSpacing.lg) {
                            VStack(spacing: AppSpacing.sm) {
                                LoadingIndicator(style: .small)
                                Text("Small")
                                    .font(AppTypography.bodySmall)
                            }
                            
                            VStack(spacing: AppSpacing.sm) {
                                LoadingIndicator(style: .medium)
                                Text("Medium")
                                    .font(AppTypography.bodySmall)
                            }
                            
                            VStack(spacing: AppSpacing.sm) {
                                LoadingIndicator(style: .large)
                                Text("Large")
                                    .font(AppTypography.bodySmall)
                            }
                        }
                        
                        HStack(spacing: AppSpacing.lg) {
                            VStack(spacing: AppSpacing.sm) {
                                PulseLoadingIndicator(style: .medium)
                                Text("Pulse")
                                    .font(AppTypography.bodySmall)
                            }
                            
                            VStack(spacing: AppSpacing.sm) {
                                DotsLoadingIndicator(style: .medium)
                                Text("Dots")
                                    .font(AppTypography.bodySmall)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Page Indicators Section
                    VStack(spacing: AppSpacing.md) {
                        Text("Page Indicators")
                            .font(AppTypography.headlineSmall)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: AppSpacing.lg) {
                            VStack(spacing: AppSpacing.sm) {
                                PageIndicator(
                                    currentPage: currentPage,
                                    pageCount: 4,
                                    style: .dots
                                )
                                Text("Dots Style")
                                    .font(AppTypography.bodySmall)
                            }
                            
                            VStack(spacing: AppSpacing.sm) {
                                PageIndicator(
                                    currentPage: currentPage,
                                    pageCount: 4,
                                    style: .line
                                )
                                Text("Line Style")
                                    .font(AppTypography.bodySmall)
                            }
                            
                            VStack(spacing: AppSpacing.sm) {
                                PageIndicator(
                                    currentPage: currentPage,
                                    pageCount: 4,
                                    style: .progress
                                )
                                Text("Progress Style")
                                    .font(AppTypography.bodySmall)
                            }
                        }
                        
                        HStack(spacing: AppSpacing.md) {
                            AppButton("Previous", style: .outline, size: .small) {
                                if currentPage > 0 {
                                    currentPage -= 1
                                }
                            }
                            
                            AppButton("Next", style: .primary, size: .small) {
                                if currentPage < 3 {
                                    currentPage += 1
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Cards Section
                    VStack(spacing: AppSpacing.md) {
                        Text("Cards")
                            .font(AppTypography.headlineSmall)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: AppSpacing.md) {
                            AppCard(style: .elevated) {
                                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                    Text("Elevated Card")
                                        .font(AppTypography.titleMedium)
                                        .fontWeight(.semibold)
                                    
                                    Text("This card has a shadow effect")
                                        .font(AppTypography.bodyMedium)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            
                            AppCard(style: .outlined) {
                                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                    Text("Outlined Card")
                                        .font(AppTypography.titleMedium)
                                        .fontWeight(.semibold)
                                    
                                    Text("This card has a border")
                                        .font(AppTypography.bodyMedium)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            
                            AppCard(
                                style: .filled,
                                backgroundColor: AppColors.primary.opacity(0.1)
                            ) {
                                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                    Text("Filled Card")
                                        .font(AppTypography.titleMedium)
                                        .fontWeight(.semibold)
                                        .foregroundColor(AppColors.primary)
                                    
                                    Text("This card has a colored background")
                                        .font(AppTypography.bodyMedium)
                                        .foregroundColor(AppColors.primary.opacity(0.8))
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Typography Section
                    VStack(spacing: AppSpacing.md) {
                        Text("Typography")
                            .font(AppTypography.headlineSmall)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Display Large")
                                .font(AppTypography.displayLarge)
                            
                            Text("Headline Large")
                                .font(AppTypography.headlineLarge)
                            
                            Text("Title Large")
                                .font(AppTypography.titleLarge)
                            
                            Text("Body Large - This is body text that shows how readable text appears in the app.")
                                .font(AppTypography.bodyLarge)
                            
                            Text("Label Medium")
                                .font(AppTypography.labelMedium)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(AppSpacing.lg)
            }
            .navigationTitle("Component Showcase")
        }
    }
    
    private func toggleLoading() {
        isLoading.toggle()
        
        if isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isLoading = false
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ComponentsShowcaseView()
}