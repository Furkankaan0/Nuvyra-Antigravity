import Foundation

/// Koçluk motoru — günlük ipuçları, haftalık özet üretimi,
/// adaptif hedef önerileri.
final class CoachingEngine {
    
    /// Günün saati ve duruma göre uygun ipucu seç
    static func selectTip(
        remainingSteps: Int,
        remainingCalories: Int,
        waterProgress: Double,
        timeOfDay: DayPeriod? = nil
    ) -> CoachingTip {
        let currentPeriod = timeOfDay ?? currentDayPeriod()
        
        // Öncelik sırası: en çok ihtiyaç duyulan alana göre
        if remainingSteps > 0 && remainingSteps < 3000 && (currentPeriod == .evening || currentPeriod == .afternoon) {
            let minutes = max(1, remainingSteps / 100)
            return CoachingTip(
                message: "Bugünkü hedefe \(remainingSteps.formatted()) adım kaldı. \(minutes) dakikalık hafif yürüyüş ritmini toparlar.",
                category: .walking,
                timeOfDay: currentPeriod
            )
        }
        
        if waterProgress < 0.4 && currentPeriod == .afternoon {
            return CoachingTip(
                message: "Son birkaç saattir su içmedin gibi görünüyor. Bir bardak su seni tazeleyebilir.",
                category: .water,
                timeOfDay: .afternoon
            )
        }
        
        if remainingCalories > 500 && currentPeriod == .evening {
            return CoachingTip(
                message: "Bugün kalori hedefinize hâlâ alan var. Dengeli bir akşam yemeği planla.",
                category: .nutrition,
                timeOfDay: .evening
            )
        }
        
        // Genel motivasyon
        return CoachingTip.dailyTips.randomElement() ?? CoachingTip(
            message: "Bugün düşük tempoda kalmak da sorun değil. Devamlılık daha önemli.",
            category: .motivation
        )
    }
    
    /// Haftalık özet üret (mock — gerçek veriler SwiftData'dan gelecek)
    static func generateWeeklySummary(
        dailyCalories: [Int],
        dailySteps: [Int],
        mealCounts: [Int],
        waterEntries: [Int]
    ) -> WeeklySummary {
        let avgCalories = dailyCalories.isEmpty ? 0 : dailyCalories.reduce(0, +) / dailyCalories.count
        let avgSteps = dailySteps.isEmpty ? 0 : dailySteps.reduce(0, +) / dailySteps.count
        
        let days = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"]
        let bestDayIndex = dailySteps.enumerated().max(by: { $0.element < $1.element })?.offset
        let hardestDayIndex = dailySteps.enumerated().min(by: { $0.element < $1.element })?.offset
        
        var suggestions: [String] = []
        if avgSteps < 7000 {
            suggestions.append("Akşam yemeğinden sonra 10 dakikalık yürüyüş ekle")
        }
        if avgCalories > 2200 {
            suggestions.append("Öğle yemeğinde porsiyon boyutunu hafif azaltmayı dene")
        }
        suggestions.append("Su içmeyi öğleden sonra hatırla")
        
        return WeeklySummary(
            averageCalories: avgCalories,
            averageSteps: avgSteps,
            bestDay: bestDayIndex.map { days[min($0, days.count - 1)] },
            hardestDay: hardestDayIndex.map { days[min($0, days.count - 1)] },
            mealConsistency: Double(mealCounts.filter { $0 >= 3 }.count) / max(1, Double(mealCounts.count)),
            waterConsistency: Double(waterEntries.filter { $0 >= 2000 }.count) / max(1, Double(waterEntries.count)),
            suggestions: suggestions,
            coachMessage: generateCoachMessage(avgSteps: avgSteps, avgCalories: avgCalories)
        )
    }
    
    // MARK: - Private
    
    private static func currentDayPeriod() -> DayPeriod {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return .morning
        case 12..<14: return .midday
        case 14..<18: return .afternoon
        case 18..<22: return .evening
        default: return .night
        }
    }
    
    private static func generateCoachMessage(avgSteps: Int, avgCalories: Int) -> String {
        if avgSteps >= 8000 && avgCalories < 2200 {
            return "Bu hafta harika bir denge kurdun. Aynı ritmi koruyarak devam edebilirsin."
        } else if avgSteps < 5000 {
            return "Bu hafta adım sayın biraz düşük kaldı — sorun değil! Haftaya akşam yemeğinden sonra kısa yürüyüşler ekleyerek ritmi toparla."
        } else {
            return "Bu hafta dengeli ilerledin. Küçük iyileştirmelerle daha da iyi olabilirsin."
        }
    }
}
