import SwiftUI
import SwiftData

@Observable
final class MealLoggingViewModel {
    var todayMeals: [MealEntry] = []
    
    func loadMeals(modelContext: ModelContext) {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = #Predicate<MealEntry> { $0.timestamp >= startOfDay }
        let descriptor = FetchDescriptor<MealEntry>(predicate: predicate, sortBy: [SortDescriptor(\.timestamp)])
        todayMeals = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addQuickMeal(_ quickMeal: TurkishQuickMeal, modelContext: ModelContext) {
        let meal = MealEntry(
            name: quickMeal.name, calories: quickMeal.calories,
            protein: quickMeal.protein, carbs: quickMeal.carbs, fat: quickMeal.fat,
            mealType: suggestedMealType(), isEstimated: true,
            portionDescription: quickMeal.portionDescription
        )
        modelContext.insert(meal)
        try? modelContext.save()
        NuvyraHaptics.success()
        loadMeals(modelContext: modelContext)
    }
    
    func deleteMeal(_ meal: MealEntry, modelContext: ModelContext) {
        modelContext.delete(meal)
        try? modelContext.save()
        loadMeals(modelContext: modelContext)
    }
    
    private func suggestedMealType() -> MealType {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<11: return .breakfast
        case 11..<15: return .lunch
        case 15..<18: return .snack
        default: return .dinner
        }
    }
}
