import Foundation

/// Koçluk modelleri — haftalık özet, rozetler, streak
struct WeeklySummary: Identifiable, Codable {
    let id: UUID
    var weekStartDate: Date
    var averageCalories: Int
    var averageSteps: Int
    var bestDay: String?
    var hardestDay: String?
    var mealConsistency: Double // 0-1 arası
    var waterConsistency: Double
    var suggestions: [String]
    var coachMessage: String
    
    init(
        id: UUID = UUID(), weekStartDate: Date = Date(), averageCalories: Int = 0,
        averageSteps: Int = 0, bestDay: String? = nil, hardestDay: String? = nil,
        mealConsistency: Double = 0, waterConsistency: Double = 0,
        suggestions: [String] = [], coachMessage: String = ""
    ) {
        self.id = id; self.weekStartDate = weekStartDate
        self.averageCalories = averageCalories; self.averageSteps = averageSteps
        self.bestDay = bestDay; self.hardestDay = hardestDay
        self.mealConsistency = mealConsistency; self.waterConsistency = waterConsistency
        self.suggestions = suggestions; self.coachMessage = coachMessage
    }
    
    static let mockSummary = WeeklySummary(
        averageCalories: 1850, averageSteps: 7200,
        bestDay: "Salı", hardestDay: "Perşembe",
        mealConsistency: 0.7, waterConsistency: 0.6,
        suggestions: [
            "Akşam yemeğinden sonra 10 dakikalık yürüyüş ekle",
            "Öğle yemeğinde protein miktarını artır",
            "Su içmeyi öğleden sonra hatırla"
        ],
        coachMessage: "Bu hafta Çarşamba sonrası ritmin düştü. Haftaya akşam yemeğinden sonra 10 dakikalık yürüyüş ekleyerek daha dengeli ilerleyebiliriz."
    )
}

struct CoachingTip: Identifiable, Codable {
    let id: UUID
    var message: String
    var category: TipCategory
    var timeOfDay: DayPeriod?
    
    init(id: UUID = UUID(), message: String, category: TipCategory, timeOfDay: DayPeriod? = nil) {
        self.id = id; self.message = message; self.category = category; self.timeOfDay = timeOfDay
    }
    
    enum TipCategory: String, Codable {
        case walking, nutrition, water, general, motivation
    }
    
    static let dailyTips: [CoachingTip] = [
        .init(message: "Akşam yemeğinden sonra 12 dakikalık hafif yürüyüş bugünkü hedefi tamamlamana yeter.", category: .walking, timeOfDay: .evening),
        .init(message: "Bugünkü hedefe 1.200 adım kaldı. 10 dakikalık hafif yürüyüş ritmini toparlar.", category: .walking),
        .init(message: "Öğle yemeğinde protein eklemek enerjini gün boyu stabil tutar.", category: .nutrition, timeOfDay: .midday),
        .init(message: "Son 2 saattir su içmedin. Bir bardak su seni tazeleyebilir.", category: .water),
        .init(message: "Bugün düşük tempoda kalmak da sorun değil. Devamlılık daha önemli.", category: .motivation),
    ]
}

struct Badge: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var description: String
    var isEarned: Bool
    var earnedDate: Date?
    
    init(id: UUID = UUID(), name: String, icon: String, description: String, isEarned: Bool = false, earnedDate: Date? = nil) {
        self.id = id; self.name = name; self.icon = icon; self.description = description
        self.isEarned = isEarned; self.earnedDate = earnedDate
    }
    
    static let allBadges: [Badge] = [
        .init(name: "İlk Adım", icon: "shoe.fill", description: "İlk öğününü kaydettin"),
        .init(name: "Yürüyüşçü", icon: "figure.walk", description: "3 gün üst üste adım hedefini tamamladın"),
        .init(name: "Su Perisi", icon: "drop.fill", description: "5 gün üst üste su hedefini tamamladın"),
        .init(name: "Haftalık Ritim", icon: "calendar", description: "Bir hafta boyunca her gün öğün kaydı girdin"),
    ]
}

struct Streak: Codable {
    var currentDays: Int
    var longestDays: Int
    var lastActiveDate: Date?
    
    static let empty = Streak(currentDays: 0, longestDays: 0, lastActiveDate: nil)
}
