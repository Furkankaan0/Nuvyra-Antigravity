import SwiftUI
import SwiftData

/// Dashboard ViewModel — günlük verileri toplar ve gösterir
@Observable
final class DashboardViewModel {
    
    // MARK: - State
    var todayCalories: Int = 0
    var calorieTarget: Int = 2000
    var todaySteps: Int = 0
    var stepTarget: Int = 8000
    var todayWaterMl: Int = 0
    var waterTargetMl: Int = 2500
    var todayMeals: [MealEntry] = []
    var dailyTip: CoachingTip?
    var isLoading: Bool = false
    var greeting: String { NuvyraDateFormatters.greeting() }
    var todayDate: String { NuvyraDateFormatters.fullDate.string(from: Date()) }
    
    var calorieProgress: Double {
        guard calorieTarget > 0 else { return 0 }
        return Double(todayCalories) / Double(calorieTarget)
    }
    var remainingCalories: Int { max(0, calorieTarget - todayCalories) }
    var stepProgress: Double {
        guard stepTarget > 0 else { return 0 }
        return Double(todaySteps) / Double(stepTarget)
    }
    var remainingSteps: Int { max(0, stepTarget - todaySteps) }
    var waterProgress: Double {
        guard waterTargetMl > 0 else { return 0 }
        return Double(todayWaterMl) / Double(waterTargetMl)
    }
    
    // MARK: - Load Data
    @MainActor
    func loadData(modelContext: ModelContext, healthKitManager: HealthKitManager) async {
        isLoading = true
        defer { isLoading = false }
        
        // Load profile targets
        let profileDescriptor = FetchDescriptor<UserProfile>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        if let profile = try? modelContext.fetch(profileDescriptor).first {
            calorieTarget = profile.dailyCalorieTarget
            stepTarget = profile.dailyStepTarget
            waterTargetMl = profile.dailyWaterTargetMl
        }
        
        // Load today meals
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let mealPredicate = #Predicate<MealEntry> { $0.timestamp >= startOfDay }
        let mealDescriptor = FetchDescriptor<MealEntry>(predicate: mealPredicate, sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        todayMeals = (try? modelContext.fetch(mealDescriptor)) ?? []
        todayCalories = todayMeals.reduce(0) { $0 + $1.calories }
        
        // Load today water
        let waterPredicate = #Predicate<WaterEntry> { $0.timestamp >= startOfDay }
        let waterDescriptor = FetchDescriptor<WaterEntry>(predicate: waterPredicate)
        let waterEntries = (try? modelContext.fetch(waterDescriptor)) ?? []
        todayWaterMl = waterEntries.reduce(0) { $0 + $1.amountMl }
        
        // Load steps from HealthKit
        if healthKitManager.isAvailable {
            todaySteps = (try? await healthKitManager.fetchTodaySteps()) ?? 0
        }
        
        // Pick a daily tip
        dailyTip = CoachingTip.dailyTips.randomElement()
    }
    
    func addWater(ml: Int, modelContext: ModelContext) {
        let entry = WaterEntry(amountMl: ml)
        modelContext.insert(entry)
        try? modelContext.save()
        todayWaterMl += ml
        NuvyraHaptics.soft()
    }
}
