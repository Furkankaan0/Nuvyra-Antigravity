import Foundation
import HealthKit

/// HealthKit entegrasyon yöneticisi — adım sayısı okuma, izin yönetimi.
/// Yalnızca gereken veri türleri istenir. Veri minimizasyonu prensibi.
@Observable
final class HealthKitManager {
    
    private let healthStore = HKHealthStore()
    
    var isAvailable: Bool { HKHealthStore.isHealthDataAvailable() }
    var authorizationStatus: HKAuthorizationStatus = .notDetermined
    var isAuthorized: Bool { authorizationStatus == .sharingAuthorized }
    
    // MARK: - İstenen Veri Türleri (Minimum)
    
    private let readTypes: Set<HKObjectType> = {
        var types = Set<HKObjectType>()
        if let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            types.insert(stepCount)
        }
        if let distance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
            types.insert(distance)
        }
        if let energy = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(energy)
        }
        return types
    }()
    
    // MARK: - Authorization
    
    /// HealthKit izni iste
    func requestAuthorization() async throws {
        guard isAvailable else { return }
        try await healthStore.requestAuthorization(toShare: [], read: readTypes)
        await updateAuthorizationStatus()
    }
    
    /// İzin durumunu güncelle
    @MainActor
    func updateAuthorizationStatus() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        authorizationStatus = healthStore.authorizationStatus(for: stepType)
    }
    
    // MARK: - Step Count
    
    /// Bugünkü adım sayısını oku
    func fetchTodaySteps() async throws -> Int {
        guard isAvailable else { return 0 }
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                if let error { continuation.resume(throwing: error); return }
                let steps = Int(result?.sumQuantity()?.doubleValue(for: .count()) ?? 0)
                continuation.resume(returning: steps)
            }
            healthStore.execute(query)
        }
    }
    
    /// Belirli bir günün adım sayısı
    func fetchSteps(for date: Date) async throws -> Int {
        guard isAvailable else { return 0 }
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                if let error { continuation.resume(throwing: error); return }
                let steps = Int(result?.sumQuantity()?.doubleValue(for: .count()) ?? 0)
                continuation.resume(returning: steps)
            }
            healthStore.execute(query)
        }
    }
    
    /// Son 7 günün adım verileri
    func fetchWeeklySteps() async throws -> [(date: Date, steps: Int)] {
        var results: [(date: Date, steps: Int)] = []
        let calendar = Calendar.current
        
        for dayOffset in (0..<7).reversed() {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date())!
            let steps = try await fetchSteps(for: date)
            results.append((date: date, steps: steps))
        }
        
        return results
    }
}
