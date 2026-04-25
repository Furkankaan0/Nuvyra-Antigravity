import Foundation
import UIKit

/// Fotoğraftan yemek tahmini servisi — provider-agnostic abstraction.
/// MVP'de mock/lookup tablosu, ileride gerçek AI API entegrasyonu.
protocol FoodEstimationServiceProtocol {
    func estimateFood(from image: UIImage) async throws -> FoodEstimationResult
}

struct FoodEstimationResult {
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let confidence: Double // 0-1 arası
    let isEstimated: Bool
    
    /// Düşük güven uyarı mesajı
    var confidenceMessage: String? {
        if confidence < 0.5 {
            return "Bu tahmin düşük güvenilirlikle yapıldı. Lütfen değerleri kontrol et."
        } else if confidence < 0.75 {
            return "Tahmini değer — düzeltmek istersen dokunabilirsin."
        }
        return nil
    }
}

/// MVP Mock implementasyonu — gerçek AI olmadan basit lookup
final class MockFoodEstimationService: FoodEstimationServiceProtocol {
    
    func estimateFood(from image: UIImage) async throws -> FoodEstimationResult {
        // Simüle edilmiş gecikme
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Rastgele Türk yemeği seç
        let meals = TurkishQuickMeal.all
        let randomMeal = meals.randomElement()!
        
        return FoodEstimationResult(
            name: randomMeal.name,
            calories: randomMeal.calories,
            protein: randomMeal.protein,
            carbs: randomMeal.carbs,
            fat: randomMeal.fat,
            confidence: Double.random(in: 0.55...0.9),
            isEstimated: true
        )
    }
}
