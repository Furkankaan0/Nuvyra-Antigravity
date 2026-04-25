import XCTest
@testable import Nuvyra

final class CalorieCalculatorTests: XCTestCase {
    
    // MARK: - BMR Tests
    
    func testBMR_male_standardValues() {
        let bmr = CalorieCalculator.calculateBMR(
            weightKg: 80, heightCm: 180, age: 30, gender: .male
        )
        // Harris-Benedict: 88.362 + (13.397 * 80) + (4.799 * 180) - (5.677 * 30)
        // = 88.362 + 1071.76 + 863.82 - 170.31 = 1853.632
        XCTAssertEqual(bmr, 1853.632, accuracy: 0.01)
    }
    
    func testBMR_female_standardValues() {
        let bmr = CalorieCalculator.calculateBMR(
            weightKg: 65, heightCm: 165, age: 28, gender: .female
        )
        // Harris-Benedict: 447.593 + (9.247 * 65) + (3.098 * 165) - (4.330 * 28)
        // = 447.593 + 601.055 + 511.17 - 121.24 = 1438.578
        XCTAssertEqual(bmr, 1438.578, accuracy: 0.01)
    }
    
    func testBMR_genderNotSpecified_usesAverage() {
        let bmrMale = CalorieCalculator.calculateBMR(weightKg: 70, heightCm: 170, age: 25, gender: .male)
        let bmrFemale = CalorieCalculator.calculateBMR(weightKg: 70, heightCm: 170, age: 25, gender: .female)
        let bmrUnspecified = CalorieCalculator.calculateBMR(weightKg: 70, heightCm: 170, age: 25, gender: nil)
        
        let expectedAverage = (bmrMale + bmrFemale) / 2
        XCTAssertEqual(bmrUnspecified, expectedAverage, accuracy: 0.01)
    }
    
    // MARK: - TDEE Tests
    
    func testTDEE_sedentary() {
        let bmr = 1800.0
        let tdee = CalorieCalculator.calculateTDEE(bmr: bmr, activityLevel: .sedentary)
        XCTAssertEqual(tdee, 2160.0, accuracy: 0.01) // 1800 * 1.2
    }
    
    func testTDEE_active() {
        let bmr = 1800.0
        let tdee = CalorieCalculator.calculateTDEE(bmr: bmr, activityLevel: .active)
        XCTAssertEqual(tdee, 3105.0, accuracy: 0.01) // 1800 * 1.725
    }
    
    // MARK: - Target Calories Tests
    
    func testTargetCalories_loseWeight_reducesCalories() {
        let maintainCalories = CalorieCalculator.calculateTargetCalories(
            weightKg: 80, heightCm: 175, age: 30,
            gender: .male, activityLevel: .moderate,
            goals: [.maintainWeight]
        )
        let loseCalories = CalorieCalculator.calculateTargetCalories(
            weightKg: 80, heightCm: 175, age: 30,
            gender: .male, activityLevel: .moderate,
            goals: [.loseWeight]
        )
        
        XCTAssertLessThan(loseCalories, maintainCalories)
        XCTAssertEqual(maintainCalories - loseCalories, 400) // 400 kcal deficit
    }
    
    func testTargetCalories_neverBelowMinimum() {
        let target = CalorieCalculator.calculateTargetCalories(
            weightKg: 40, heightCm: 150, age: 60,
            gender: .female, activityLevel: .sedentary,
            goals: [.loseWeight]
        )
        XCTAssertGreaterThanOrEqual(target, 1200) // Güvenli minimum
    }
    
    func testTargetCalories_neverAboveMaximum() {
        let target = CalorieCalculator.calculateTargetCalories(
            weightKg: 150, heightCm: 200, age: 20,
            gender: .male, activityLevel: .veryActive,
            goals: []
        )
        XCTAssertLessThanOrEqual(target, 4000) // Güvenli maksimum
    }
    
    // MARK: - Water Target Tests
    
    func testWaterTarget_basedOnWeight() {
        let target = CalorieCalculator.calculateWaterTarget(weightKg: 70)
        XCTAssertEqual(target, 2310) // 70 * 33
    }
    
    // MARK: - Calorie Range Tests
    
    func testCalorieRange_symmetricAroundTarget() {
        let range = CalorieCalculator.calorieRange(targetCalories: 2000)
        XCTAssertEqual(range.min, 1850)
        XCTAssertEqual(range.max, 2150)
    }
}
