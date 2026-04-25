import Foundation

/// HealthKit adım verilerini SwiftData ile senkronize eden servis
@Observable
final class StepSyncService {
    
    private let healthKitManager: HealthKitManager
    
    var todaySteps: Int = 0
    var weeklySteps: [(date: Date, steps: Int)] = []
    var isLoading: Bool = false
    var lastSyncDate: Date?
    
    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }
    
    /// Bugünkü adımları senkronize et
    @MainActor
    func syncTodaySteps() async {
        guard healthKitManager.isAvailable else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            todaySteps = try await healthKitManager.fetchTodaySteps()
            lastSyncDate = Date()
        } catch {
            print("Adım senkronizasyonu hatası: \(error.localizedDescription)")
        }
    }
    
    /// Haftalık adım verilerini senkronize et
    @MainActor
    func syncWeeklySteps() async {
        guard healthKitManager.isAvailable else { return }
        
        do {
            weeklySteps = try await healthKitManager.fetchWeeklySteps()
        } catch {
            print("Haftalık adım senkronizasyonu hatası: \(error.localizedDescription)")
        }
    }
}
