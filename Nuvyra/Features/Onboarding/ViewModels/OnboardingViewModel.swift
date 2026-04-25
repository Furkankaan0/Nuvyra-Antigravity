import SwiftUI
import Observation

/// Onboarding ViewModel — çok adımlı onboarding akışını yönetir.
/// BMR/TDEE hesaplaması, hedef belirleme, profil oluşturma.
@Observable
final class OnboardingViewModel {
    
    // MARK: - Navigation
    
    var currentStep: OnboardingStep = .welcome
    var totalSteps: Int { OnboardingStep.allCases.count }
    var currentStepIndex: Int { OnboardingStep.allCases.firstIndex(of: currentStep) ?? 0 }
    var progress: Double { Double(currentStepIndex) / Double(totalSteps - 1) }
    
    // MARK: - Goal Selection
    
    var selectedGoals: Set<HealthGoal> = []
    
    // MARK: - Profile
    
    var age: Int = 25
    var heightCm: Double = 170
    var weightKg: Double = 70
    var targetWeightKg: Double = 65
    var selectedGender: Gender? = nil
    var activityLevel: ActivityLevel = .moderate
    
    // MARK: - Daily Routine
    
    var mealCount: Int = 3
    var difficultTime: DayPeriod? = nil
    var preferredWalkTime: DayPeriod? = nil
    var wantsReminders: Bool = true
    
    // MARK: - Computed Values
    
    var calculatedCalorieTarget: Int {
        CalorieCalculator.calculateTargetCalories(
            weightKg: weightKg, heightCm: heightCm, age: age,
            gender: selectedGender, activityLevel: activityLevel,
            goals: Array(selectedGoals)
        )
    }
    
    var calorieRange: (min: Int, max: Int) {
        CalorieCalculator.calorieRange(targetCalories: calculatedCalorieTarget)
    }
    
    var suggestedStepGoal: Int {
        activityLevel.suggestedStepGoal
    }
    
    var waterTargetMl: Int {
        CalorieCalculator.calculateWaterTarget(weightKg: weightKg)
    }
    
    // MARK: - Navigation Actions
    
    func goToNextStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep),
              currentIndex < OnboardingStep.allCases.count - 1 else { return }
        withAnimation(NuvyraMotion.spring) {
            currentStep = OnboardingStep.allCases[currentIndex + 1]
        }
    }
    
    func goToPreviousStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep),
              currentIndex > 0 else { return }
        withAnimation(NuvyraMotion.spring) {
            currentStep = OnboardingStep.allCases[currentIndex - 1]
        }
    }
    
    var canProceed: Bool {
        switch currentStep {
        case .welcome: true
        case .goalSelection: !selectedGoals.isEmpty
        case .profileInput: age > 0 && heightCm > 0 && weightKg > 0
        case .dailyRoutine: true
        case .firstValue: true
        case .healthKitPermission: true
        case .notificationPermission: true
        }
    }
    
    // MARK: - Profile Creation
    
    func createProfile() -> UserProfile {
        UserProfile(
            age: age, heightCm: heightCm, weightKg: weightKg,
            targetWeightKg: selectedGoals.contains(.loseWeight) ? targetWeightKg : nil,
            gender: selectedGender, activityLevel: activityLevel,
            goals: Array(selectedGoals),
            dailyCalorieTarget: calculatedCalorieTarget,
            dailyStepTarget: suggestedStepGoal,
            dailyWaterTargetMl: waterTargetMl,
            mealCount: mealCount,
            difficultTimeOfDay: difficultTime,
            preferredWalkTime: preferredWalkTime,
            wantsReminders: wantsReminders
        )
    }
}

// MARK: - Onboarding Steps

enum OnboardingStep: Int, CaseIterable, Identifiable {
    case welcome = 0
    case goalSelection = 1
    case profileInput = 2
    case dailyRoutine = 3
    case firstValue = 4
    case healthKitPermission = 5
    case notificationPermission = 6
    
    var id: Int { rawValue }
}
