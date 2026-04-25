import Foundation
import SwiftData

/// Kullanıcı profili — onboarding'de toplanan ve uygulama boyunca kullanılan veriler.
@Model
final class UserProfile {
    
    var age: Int
    var heightCm: Double
    var weightKg: Double
    var targetWeightKg: Double?
    var gender: Gender?
    var activityLevel: ActivityLevel
    var goals: [HealthGoal]
    var dailyCalorieTarget: Int
    var dailyStepTarget: Int
    var dailyWaterTargetMl: Int
    var mealCount: Int // günlük öğün sayısı
    var difficultTimeOfDay: DayPeriod?
    var preferredWalkTime: DayPeriod?
    var wantsReminders: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(
        age: Int = 25,
        heightCm: Double = 170,
        weightKg: Double = 70,
        targetWeightKg: Double? = nil,
        gender: Gender? = nil,
        activityLevel: ActivityLevel = .moderate,
        goals: [HealthGoal] = [],
        dailyCalorieTarget: Int = 2000,
        dailyStepTarget: Int = 8000,
        dailyWaterTargetMl: Int = 2500,
        mealCount: Int = 3,
        difficultTimeOfDay: DayPeriod? = nil,
        preferredWalkTime: DayPeriod? = nil,
        wantsReminders: Bool = true
    ) {
        self.age = age
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.targetWeightKg = targetWeightKg
        self.gender = gender
        self.activityLevel = activityLevel
        self.goals = goals
        self.dailyCalorieTarget = dailyCalorieTarget
        self.dailyStepTarget = dailyStepTarget
        self.dailyWaterTargetMl = dailyWaterTargetMl
        self.mealCount = mealCount
        self.difficultTimeOfDay = difficultTimeOfDay
        self.preferredWalkTime = preferredWalkTime
        self.wantsReminders = wantsReminders
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Supporting Types

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male = "male"
    case female = "female"
    case other = "other"
    case preferNotToSay = "prefer_not_to_say"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .male: "Erkek"
        case .female: "Kadın"
        case .other: "Diğer"
        case .preferNotToSay: "Belirtmek istemiyorum"
        }
    }
}

enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case sedentary = "sedentary"
    case light = "light"
    case moderate = "moderate"
    case active = "active"
    case veryActive = "very_active"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .sedentary: "Hareketsiz"
        case .light: "Hafif aktif"
        case .moderate: "Orta aktif"
        case .active: "Aktif"
        case .veryActive: "Çok aktif"
        }
    }
    
    var description: String {
        switch self {
        case .sedentary: "Masa başı iş, az hareket"
        case .light: "Hafif yürüyüşler, günlük aktivite"
        case .moderate: "Düzenli yürüyüş veya hafif egzersiz"
        case .active: "Düzenli egzersiz veya aktif iş"
        case .veryActive: "Yoğun egzersiz veya fiziksel iş"
        }
    }
    
    /// TDEE hesaplaması için çarpan
    var multiplier: Double {
        switch self {
        case .sedentary: 1.2
        case .light: 1.375
        case .moderate: 1.55
        case .active: 1.725
        case .veryActive: 1.9
        }
    }
    
    /// Önerilen başlangıç adım hedefi
    var suggestedStepGoal: Int {
        switch self {
        case .sedentary: 5000
        case .light: 6500
        case .moderate: 8000
        case .active: 10000
        case .veryActive: 12000
        }
    }
}

enum HealthGoal: String, Codable, CaseIterable, Identifiable {
    case loseWeight = "lose_weight"
    case eatBetter = "eat_better"
    case walkMore = "walk_more"
    case maintainWeight = "maintain_weight"
    case healthRhythm = "health_rhythm"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .loseWeight: "Kilo vermek"
        case .eatBetter: "Daha düzenli beslenmek"
        case .walkMore: "Daha çok yürümek"
        case .maintainWeight: "Kilomu korumak"
        case .healthRhythm: "Genel sağlık ritmi kurmak"
        }
    }
    
    var icon: String {
        switch self {
        case .loseWeight: "scalemass"
        case .eatBetter: "leaf.fill"
        case .walkMore: "figure.walk"
        case .maintainWeight: "arrow.left.arrow.right"
        case .healthRhythm: "heart.fill"
        }
    }
}

enum DayPeriod: String, Codable, CaseIterable, Identifiable {
    case morning = "morning"
    case midday = "midday"
    case afternoon = "afternoon"
    case evening = "evening"
    case night = "night"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .morning: "Sabah"
        case .midday: "Öğle"
        case .afternoon: "Öğleden sonra"
        case .evening: "Akşam"
        case .night: "Gece"
        }
    }
}
