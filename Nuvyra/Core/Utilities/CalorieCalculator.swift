import Foundation

/// Kalori hesaplama motoru — BMR, TDEE ve hedef kalori
enum CalorieCalculator {
    
    /// Harris-Benedict BMR hesaplama
    static func calculateBMR(
        weightKg: Double, heightCm: Double, age: Int, gender: Gender?
    ) -> Double {
        switch gender {
        case .male:
            return 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * Double(age))
        case .female:
            return 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * Double(age))
        default:
            // Cinsiyet belirtilmemişse ortalamasını al
            let male = 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * Double(age))
            let female = 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * Double(age))
            return (male + female) / 2
        }
    }
    
    /// TDEE (Total Daily Energy Expenditure)
    static func calculateTDEE(bmr: Double, activityLevel: ActivityLevel) -> Double {
        bmr * activityLevel.multiplier
    }
    
    /// Hedef kalorisi — hedefe göre ayarlanmış
    static func calculateTargetCalories(
        weightKg: Double, heightCm: Double, age: Int,
        gender: Gender?, activityLevel: ActivityLevel, goals: [HealthGoal]
    ) -> Int {
        let bmr = calculateBMR(weightKg: weightKg, heightCm: heightCm, age: age, gender: gender)
        let tdee = calculateTDEE(bmr: bmr, activityLevel: activityLevel)
        
        var adjustment: Double = 0
        if goals.contains(.loseWeight) {
            adjustment = -400 // Hafif kalori açığı
        } else if goals.contains(.maintainWeight) {
            adjustment = 0
        }
        
        let target = Int(tdee + adjustment)
        return max(1200, min(target, 4000)) // Güvenli aralık
    }
    
    /// Kalori aralığı — kullanıcıya gösterilen tahmini aralık
    static func calorieRange(targetCalories: Int) -> (min: Int, max: Int) {
        let min = targetCalories - 150
        let max = targetCalories + 150
        return (min: Swift.max(1200, min), max: Swift.min(4000, max))
    }
    
    /// Günlük su hedefi (ml) — kilo bazlı
    static func calculateWaterTarget(weightKg: Double) -> Int {
        Int(weightKg * 33) // 33ml/kg genel önerisi
    }
}
