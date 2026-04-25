import Foundation
import SwiftData

/// Günlük adım kaydı
@Model
final class DailyStepRecord {
    
    var date: Date
    var stepCount: Int
    var goalSteps: Int
    var source: StepSource
    var distanceMeters: Double?
    var activeEnergyKcal: Double?
    
    /// Hedef tamamlandı mı?
    var isGoalMet: Bool {
        stepCount >= goalSteps
    }
    
    /// İlerleme yüzdesi (0.0 - 1.0+)
    var progress: Double {
        guard goalSteps > 0 else { return 0 }
        return Double(stepCount) / Double(goalSteps)
    }
    
    /// Kalan adım sayısı
    var remainingSteps: Int {
        max(0, goalSteps - stepCount)
    }
    
    /// Tahmini kalan yürüyüş süresi (dakika) — ortalama 100 adım/dk
    var estimatedMinutesRemaining: Int {
        let remaining = remainingSteps
        guard remaining > 0 else { return 0 }
        return max(1, remaining / 100)
    }
    
    init(
        date: Date = Date(),
        stepCount: Int = 0,
        goalSteps: Int = 8000,
        source: StepSource = .healthKit,
        distanceMeters: Double? = nil,
        activeEnergyKcal: Double? = nil
    ) {
        self.date = date
        self.stepCount = stepCount
        self.goalSteps = goalSteps
        self.source = source
        self.distanceMeters = distanceMeters
        self.activeEnergyKcal = activeEnergyKcal
    }
}

// MARK: - Supporting Types

enum StepSource: String, Codable {
    case healthKit = "healthkit"
    case manual = "manual"
    case watch = "watch"
}

/// Yürüyüş oturumu (ileride GPS ile detaylandırılacak)
struct WalkSession: Codable, Identifiable {
    let id: UUID
    var startTime: Date
    var endTime: Date?
    var steps: Int
    var distanceMeters: Double?
    var isActive: Bool
    
    var durationMinutes: Int {
        let end = endTime ?? Date()
        return max(0, Int(end.timeIntervalSince(startTime) / 60))
    }
    
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        steps: Int = 0,
        distanceMeters: Double? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.steps = steps
        self.distanceMeters = distanceMeters
        self.isActive = isActive
    }
}

/// Adım hedefi adaptasyon kuralları
enum StepGoalAdaptation {
    
    /// Son 3 günün verilerine göre yeni hedef öner
    static func suggestNewGoal(
        currentGoal: Int,
        recentDays: [DailyStepRecord]
    ) -> (newGoal: Int, reason: String)? {
        guard recentDays.count >= 3 else { return nil }
        
        let lastThree = recentDays.suffix(3)
        let allMet = lastThree.allSatisfy { $0.isGoalMet }
        let allLow = lastThree.allSatisfy { $0.progress < 0.5 }
        
        if allMet {
            // 3 gün üst üste hedef geçildi — %10 artır
            let increase = max(500, Int(Double(currentGoal) * 0.1))
            let newGoal = currentGoal + increase
            return (
                newGoal: newGoal,
                reason: "Son 3 gün hedefini geçtin! Yeni hedefin \(newGoal.formatted()) adım olabilir."
            )
        }
        
        if allLow {
            // 3 gün çok düşük — %15 düşür (cezalandırmadan)
            let decrease = max(500, Int(Double(currentGoal) * 0.15))
            let newGoal = max(3000, currentGoal - decrease)
            return (
                newGoal: newGoal,
                reason: "Son günlerde biraz düşük kaldın — sorun değil! Hedefini \(newGoal.formatted()) adıma ayarlayarak rahat ilerleyebilirsin."
            )
        }
        
        return nil
    }
}
