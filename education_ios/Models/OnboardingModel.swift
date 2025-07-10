//
//  OnboardingModel.swift
//  education_ios
//
//  Created by lynkto_1 on 7/10/25.
//

import SwiftUI

// MARK: - Onboarding Page Model
struct OnboardingPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let backgroundColor: Color
    let textColor: Color
    
    init(
        title: String,
        subtitle: String,
        description: String,
        imageName: String,
        backgroundColor: Color,
        textColor: Color = AppColors.white
    ) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
}

// MARK: - Onboarding Data
struct OnboardingData {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to EduApp",
            subtitle: "Learn Anywhere",
            description: "Access thousands of courses and educational content right from your device. Start your learning journey today.",
            imageName: "graduationcap.fill",
            backgroundColor: AppColors.onboarding1
        ),
        OnboardingPage(
            title: "Interactive Learning",
            subtitle: "Engage & Explore",
            description: "Participate in interactive lessons, quizzes, and hands-on activities designed to enhance your learning experience.",
            imageName: "book.fill",
            backgroundColor: AppColors.onboarding2
        ),
        OnboardingPage(
            title: "Track Progress",
            subtitle: "Stay Motivated",
            description: "Monitor your learning progress, earn achievements, and see how far you've come on your educational journey.",
            imageName: "chart.line.uptrend.xyaxis",
            backgroundColor: AppColors.onboarding3
        ),
        OnboardingPage(
            title: "Connect & Share",
            subtitle: "Learn Together",
            description: "Join a community of learners, share your knowledge, and learn from others around the world.",
            imageName: "person.3.fill",
            backgroundColor: AppColors.onboarding4
        )
    ]
}

// MARK: - Onboarding State
enum OnboardingState {
    case splash
    case onboarding(currentPage: Int)
    case completed
}

// MARK: - Onboarding View Model
@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var state: OnboardingState = .splash
    @Published var currentPage: Int = 0
    @Published var isLoading: Bool = false
    
    let pages = OnboardingData.pages
    
    var isLastPage: Bool {
        currentPage == pages.count - 1
    }
    
    var isFirstPage: Bool {
        currentPage == 0
    }
    
    // MARK: - Actions
    func startOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            state = .onboarding(currentPage: 0)
            currentPage = 0
        }
    }
    
    func nextPage() {
        guard !isLastPage else {
            completeOnboarding()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage += 1
            state = .onboarding(currentPage: currentPage)
        }
    }
    
    func previousPage() {
        guard !isFirstPage else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage -= 1
            state = .onboarding(currentPage: currentPage)
        }
    }
    
    func goToPage(_ page: Int) {
        guard page >= 0 && page < pages.count else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage = page
            state = .onboarding(currentPage: currentPage)
        }
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
    
    func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            state = .completed
            // Here you would typically save to UserDefaults that onboarding is completed
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        }
    }
    
    func resetOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            state = .splash
            currentPage = 0
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        }
    }
    
    // MARK: - Lifecycle
    func checkOnboardingStatus() {
        let hasCompleted = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if hasCompleted {
            state = .completed
        } else {
            state = .splash
        }
    }
}