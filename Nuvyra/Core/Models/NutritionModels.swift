import Foundation
import SwiftData

/// Öğün kaydı — elle veya fotoğrafla girilen yemek verisi.
@Model
final class MealEntry {
    
    var name: String
    var calories: Int
    var protein: Double // gram
    var carbs: Double // gram
    var fat: Double // gram
    var mealType: MealType
    var timestamp: Date
    var photoData: Data? // JPEG thumbnail
    var isEstimated: Bool // AI tahmini mi yoksa manuel mi?
    var notes: String?
    var portionDescription: String? // "1 porsiyon", "2 dilim" gibi
    
    init(
        name: String,
        calories: Int,
        protein: Double = 0,
        carbs: Double = 0,
        fat: Double = 0,
        mealType: MealType = .snack,
        timestamp: Date = Date(),
        photoData: Data? = nil,
        isEstimated: Bool = false,
        notes: String? = nil,
        portionDescription: String? = nil
    ) {
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.mealType = mealType
        self.timestamp = timestamp
        self.photoData = photoData
        self.isEstimated = isEstimated
        self.notes = notes
        self.portionDescription = portionDescription
    }
}

/// Su kaydı
@Model
final class WaterEntry {
    
    var amountMl: Int
    var timestamp: Date
    
    init(amountMl: Int = 250, timestamp: Date = Date()) {
        self.amountMl = amountMl
        self.timestamp = timestamp
    }
}

// MARK: - Enums

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case snack = "snack"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .breakfast: "Kahvaltı"
        case .lunch: "Öğle Yemeği"
        case .dinner: "Akşam Yemeği"
        case .snack: "Atıştırmalık"
        }
    }
    
    var icon: String {
        switch self {
        case .breakfast: "sun.horizon.fill"
        case .lunch: "sun.max.fill"
        case .dinner: "moon.fill"
        case .snack: "carrot.fill"
        }
    }
    
    var suggestedTime: String {
        switch self {
        case .breakfast: "07:00 - 10:00"
        case .lunch: "12:00 - 14:00"
        case .dinner: "18:00 - 21:00"
        case .snack: "Her zaman"
        }
    }
}

// MARK: - Turkish Quick Meals

/// Hızlı Türk yemeği şablonları — tahmini besin değerleri ile
struct TurkishQuickMeal: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let portionDescription: String
    
    /// Yaygın Türk yemekleri — tahmini 1 porsiyon değerleri
    static let all: [TurkishQuickMeal] = [
        TurkishQuickMeal(name: "Menemen", emoji: "🍳", calories: 250, protein: 12, carbs: 8, fat: 18, portionDescription: "1 porsiyon"),
        TurkishQuickMeal(name: "Mercimek Çorbası", emoji: "🥣", calories: 180, protein: 10, carbs: 28, fat: 4, portionDescription: "1 kase"),
        TurkishQuickMeal(name: "Pilav Üstü Tavuk", emoji: "🍗", calories: 450, protein: 35, carbs: 45, fat: 12, portionDescription: "1 porsiyon"),
        TurkishQuickMeal(name: "Ayran", emoji: "🥛", calories: 65, protein: 3, carbs: 4, fat: 4, portionDescription: "1 bardak"),
        TurkishQuickMeal(name: "Simit", emoji: "🥯", calories: 280, protein: 8, carbs: 50, fat: 5, portionDescription: "1 adet"),
        TurkishQuickMeal(name: "Yumurta (Haşlanmış)", emoji: "🥚", calories: 78, protein: 6, carbs: 1, fat: 5, portionDescription: "1 adet"),
        TurkishQuickMeal(name: "Tavuk Döner", emoji: "🌯", calories: 380, protein: 28, carbs: 35, fat: 14, portionDescription: "1 porsiyon"),
        TurkishQuickMeal(name: "Izgara Köfte", emoji: "🥩", calories: 300, protein: 25, carbs: 5, fat: 20, portionDescription: "4 adet"),
        TurkishQuickMeal(name: "Yoğurt", emoji: "🥄", calories: 120, protein: 8, carbs: 10, fat: 5, portionDescription: "1 kase"),
        TurkishQuickMeal(name: "Salata", emoji: "🥗", calories: 90, protein: 3, carbs: 12, fat: 4, portionDescription: "1 porsiyon"),
        TurkishQuickMeal(name: "Lahmacun", emoji: "🫓", calories: 210, protein: 10, carbs: 28, fat: 7, portionDescription: "1 adet"),
        TurkishQuickMeal(name: "Ev Yemeği", emoji: "🍲", calories: 350, protein: 18, carbs: 35, fat: 15, portionDescription: "1 porsiyon"),
        TurkishQuickMeal(name: "Çay", emoji: "🍵", calories: 2, protein: 0, carbs: 0, fat: 0, portionDescription: "1 bardak"),
        TurkishQuickMeal(name: "Türk Kahvesi", emoji: "☕", calories: 15, protein: 0, carbs: 3, fat: 0, portionDescription: "1 fincan"),
        TurkishQuickMeal(name: "Peynirli Tost", emoji: "🥪", calories: 320, protein: 14, carbs: 30, fat: 16, portionDescription: "1 adet"),
        TurkishQuickMeal(name: "Kuru Fasulye", emoji: "🫘", calories: 280, protein: 16, carbs: 42, fat: 5, portionDescription: "1 porsiyon"),
    ]
}
