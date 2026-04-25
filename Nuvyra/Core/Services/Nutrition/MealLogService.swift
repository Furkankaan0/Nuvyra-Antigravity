import Foundation
import SwiftData

/// Öğün kayıt servisi — CRUD işlemleri ve günlük/haftalık aggregation
final class MealLogService {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - CRUD
    
    func addMeal(_ meal: MealEntry) {
        modelContext.insert(meal)
        try? modelContext.save()
    }
    
    func deleteMeal(_ meal: MealEntry) {
        modelContext.delete(meal)
        try? modelContext.save()
    }
    
    func updateMeal(_ meal: MealEntry) {
        try? modelContext.save()
    }
    
    // MARK: - Queries
    
    func fetchTodayMeals() -> [MealEntry] {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = #Predicate<MealEntry> { $0.timestamp >= startOfDay }
        let descriptor = FetchDescriptor<MealEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchMeals(for date: Date) -> [MealEntry] {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        let predicate = #Predicate<MealEntry> { $0.timestamp >= start && $0.timestamp < end }
        let descriptor = FetchDescriptor<MealEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Aggregation
    
    func todayTotalCalories() -> Int {
        fetchTodayMeals().reduce(0) { $0 + $1.calories }
    }
    
    func todayMacros() -> (protein: Double, carbs: Double, fat: Double) {
        let meals = fetchTodayMeals()
        return (
            protein: meals.reduce(0) { $0 + $1.protein },
            carbs: meals.reduce(0) { $0 + $1.carbs },
            fat: meals.reduce(0) { $0 + $1.fat }
        )
    }
}
