//
//  PageIndicator.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Page Indicator Style
enum PageIndicatorStyle {
    case dots
    case line
    case progress
}

// MARK: - Page Indicator
struct PageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    let style: PageIndicatorStyle
    let activeColor: Color
    let inactiveColor: Color
    
    init(
        currentPage: Int,
        pageCount: Int,
        style: PageIndicatorStyle = .dots,
        activeColor: Color = AppColors.primary,
        inactiveColor: Color = AppColors.textTertiary
    ) {
        self.currentPage = currentPage
        self.pageCount = pageCount
        self.style = style
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    
    var body: some View {
        switch style {
        case .dots:
            DotsPageIndicator(
                currentPage: currentPage,
                pageCount: pageCount,
                activeColor: activeColor,
                inactiveColor: inactiveColor
            )
        case .line:
            LinePageIndicator(
                currentPage: currentPage,
                pageCount: pageCount,
                activeColor: activeColor,
                inactiveColor: inactiveColor
            )
        case .progress:
            ProgressPageIndicator(
                currentPage: currentPage,
                pageCount: pageCount,
                activeColor: activeColor,
                inactiveColor: inactiveColor
            )
        }
    }
}

// MARK: - Dots Page Indicator
struct DotsPageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    let activeColor: Color
    let inactiveColor: Color
    
    private let dotSize: CGFloat = 8
    private let activeDotSize: CGFloat = 10
    private let spacing: CGFloat = 8
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(
                        width: index == currentPage ? activeDotSize : dotSize,
                        height: index == currentPage ? activeDotSize : dotSize
                    )
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

// MARK: - Line Page Indicator
struct LinePageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    let activeColor: Color
    let inactiveColor: Color
    
    private let lineWidth: CGFloat = 24
    private let lineHeight: CGFloat = 4
    private let activeLineWidth: CGFloat = 32
    private let spacing: CGFloat = 8
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<pageCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: lineHeight / 2)
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(
                        width: index == currentPage ? activeLineWidth : lineWidth,
                        height: lineHeight
                    )
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

// MARK: - Progress Page Indicator
struct ProgressPageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    let activeColor: Color
    let inactiveColor: Color
    
    private let totalWidth: CGFloat = 200
    private let height: CGFloat = 4
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background
            RoundedRectangle(cornerRadius: height / 2)
                .fill(inactiveColor.opacity(0.3))
                .frame(width: totalWidth, height: height)
            
            // Progress
            RoundedRectangle(cornerRadius: height / 2)
                .fill(activeColor)
                .frame(
                    width: totalWidth * CGFloat(currentPage + 1) / CGFloat(pageCount),
                    height: height
                )
                .animation(.easeInOut(duration: 0.3), value: currentPage)
        }
    }
}

// MARK: - Interactive Page Indicator
struct InteractivePageIndicator: View {
    @Binding var currentPage: Int
    let pageCount: Int
    let style: PageIndicatorStyle
    let activeColor: Color
    let inactiveColor: Color
    let onPageChanged: ((Int) -> Void)?
    
    init(
        currentPage: Binding<Int>,
        pageCount: Int,
        style: PageIndicatorStyle = .dots,
        activeColor: Color = AppColors.primary,
        inactiveColor: Color = AppColors.textTertiary,
        onPageChanged: ((Int) -> Void)? = nil
    ) {
        self._currentPage = currentPage
        self.pageCount = pageCount
        self.style = style
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.onPageChanged = onPageChanged
    }
    
    var body: some View {
        if style == .dots {
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Button(action: {
                        currentPage = index
                        onPageChanged?(index)
                    }) {
                        Circle()
                            .fill(index == currentPage ? activeColor : inactiveColor)
                            .frame(
                                width: index == currentPage ? 10 : 8,
                                height: index == currentPage ? 10 : 8
                            )
                    }
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
        } else {
            PageIndicator(
                currentPage: currentPage,
                pageCount: pageCount,
                style: style,
                activeColor: activeColor,
                inactiveColor: inactiveColor
            )
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.xl) {
        VStack(spacing: AppSpacing.md) {
            Text("Dots Style")
                .font(AppTypography.titleMedium)
            
            PageIndicator(
                currentPage: 1,
                pageCount: 4,
                style: .dots
            )
        }
        
        VStack(spacing: AppSpacing.md) {
            Text("Line Style")
                .font(AppTypography.titleMedium)
            
            PageIndicator(
                currentPage: 2,
                pageCount: 4,
                style: .line
            )
        }
        
        VStack(spacing: AppSpacing.md) {
            Text("Progress Style")
                .font(AppTypography.titleMedium)
            
            PageIndicator(
                currentPage: 2,
                pageCount: 4,
                style: .progress
            )
        }
    }
    .padding()
}