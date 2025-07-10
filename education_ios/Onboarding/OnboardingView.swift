//
//  OnboardingView.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    private let dragThreshold: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Page Views
                TabView(selection: $viewModel.currentPage) {
                    ForEach(Array(viewModel.pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(
                            page: page,
                            isCurrentPage: index == viewModel.currentPage
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: viewModel.currentPage) { _, newValue in
                    viewModel.goToPage(newValue)
                }
                
                // Overlay Controls
                VStack {
                    // Top Bar
                    HStack {
                        // Skip Button
                        if !viewModel.isLastPage {
                            Button("Skip") {
                                viewModel.skipOnboarding()
                            }
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(viewModel.pages[viewModel.currentPage].textColor.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Page Counter
                        Text("\(viewModel.currentPage + 1) of \(viewModel.pages.count)")
                            .font(AppTypography.bodySmall)
                            .foregroundColor(viewModel.pages[viewModel.currentPage].textColor.opacity(0.7))
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    
                    Spacer()
                    
                    // Bottom Controls
                    VStack(spacing: AppSpacing.lg) {
                        // Page Indicator
                        PageIndicator(
                            currentPage: viewModel.currentPage,
                            pageCount: viewModel.pages.count,
                            style: .dots,
                            activeColor: viewModel.pages[viewModel.currentPage].textColor,
                            inactiveColor: viewModel.pages[viewModel.currentPage].textColor.opacity(0.4)
                        )
                        
                        // Navigation Buttons
                        HStack(spacing: AppSpacing.md) {
                            // Previous Button
                            if !viewModel.isFirstPage {
                                AppButton(
                                    "Previous",
                                    style: .outline,
                                    size: .medium
                                ) {
                                    viewModel.previousPage()
                                }
                                .foregroundColor(viewModel.pages[viewModel.currentPage].textColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                        .stroke(viewModel.pages[viewModel.currentPage].textColor, lineWidth: 1)
                                )
                            }
                            
                            Spacer()
                            
                            // Next/Get Started Button
                            AppButton(
                                viewModel.isLastPage ? "Get Started" : "Next",
                                style: .primary,
                                size: .medium
                            ) {
                                viewModel.nextPage()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                    .fill(viewModel.pages[viewModel.currentPage].textColor)
                            )
                            .foregroundColor(viewModel.pages[viewModel.currentPage].backgroundColor)
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                    isDragging = true
                }
                .onEnded { value in
                    let dragDistance = value.translation.width
                    
                    if dragDistance > dragThreshold {
                        // Swipe right - previous page
                        viewModel.previousPage()
                    } else if dragDistance < -dragThreshold {
                        // Swipe left - next page
                        viewModel.nextPage()
                    }
                    
                    dragOffset = .zero
                    isDragging = false
                }
        )
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}