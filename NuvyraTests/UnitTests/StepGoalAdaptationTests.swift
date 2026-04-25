import XCTest
@testable import Nuvyra

final class StepGoalAdaptationTests: XCTestCase {
    
    func testSuggestNewGoal_threeConsecutiveDaysMet_increasesGoal() {
        let currentGoal = 8000
        let records = [
            DailyStepRecord(stepCount: 9000, goalSteps: 8000),
            DailyStepRecord(stepCount: 8500, goalSteps: 8000),
            DailyStepRecord(stepCount: 10000, goalSteps: 8000)
        ]
        
        let suggestion = StepGoalAdaptation.suggestNewGoal(
            currentGoal: currentGoal, recentDays: records
        )
        
        XCTAssertNotNil(suggestion)
        XCTAssertGreaterThan(suggestion!.newGoal, currentGoal)
    }
    
    func testSuggestNewGoal_threeConsecutiveDaysLow_decreasesGoal() {
        let currentGoal = 10000
        let records = [
            DailyStepRecord(stepCount: 3000, goalSteps: 10000),
            DailyStepRecord(stepCount: 2500, goalSteps: 10000),
            DailyStepRecord(stepCount: 4000, goalSteps: 10000)
        ]
        
        let suggestion = StepGoalAdaptation.suggestNewGoal(
            currentGoal: currentGoal, recentDays: records
        )
        
        XCTAssertNotNil(suggestion)
        XCTAssertLessThan(suggestion!.newGoal, currentGoal)
    }
    
    func testSuggestNewGoal_neverBelow3000() {
        let currentGoal = 3500
        let records = [
            DailyStepRecord(stepCount: 500, goalSteps: 3500),
            DailyStepRecord(stepCount: 200, goalSteps: 3500),
            DailyStepRecord(stepCount: 100, goalSteps: 3500)
        ]
        
        let suggestion = StepGoalAdaptation.suggestNewGoal(
            currentGoal: currentGoal, recentDays: records
        )
        
        XCTAssertNotNil(suggestion)
        XCTAssertGreaterThanOrEqual(suggestion!.newGoal, 3000)
    }
    
    func testSuggestNewGoal_lessThanThreeDays_returnsNil() {
        let records = [
            DailyStepRecord(stepCount: 9000, goalSteps: 8000),
            DailyStepRecord(stepCount: 8500, goalSteps: 8000)
        ]
        
        let suggestion = StepGoalAdaptation.suggestNewGoal(
            currentGoal: 8000, recentDays: records
        )
        
        XCTAssertNil(suggestion)
    }
    
    func testSuggestNewGoal_mixedResults_returnsNil() {
        let records = [
            DailyStepRecord(stepCount: 9000, goalSteps: 8000),
            DailyStepRecord(stepCount: 3000, goalSteps: 8000),
            DailyStepRecord(stepCount: 8500, goalSteps: 8000)
        ]
        
        let suggestion = StepGoalAdaptation.suggestNewGoal(
            currentGoal: 8000, recentDays: records
        )
        
        XCTAssertNil(suggestion) // Karışık sonuçlarda değişiklik önerme
    }
    
    // MARK: - DailyStepRecord Tests
    
    func testDailyStepRecord_goalMet() {
        let record = DailyStepRecord(stepCount: 10000, goalSteps: 8000)
        XCTAssertTrue(record.isGoalMet)
        XCTAssertEqual(record.remainingSteps, 0)
    }
    
    func testDailyStepRecord_goalNotMet() {
        let record = DailyStepRecord(stepCount: 5000, goalSteps: 8000)
        XCTAssertFalse(record.isGoalMet)
        XCTAssertEqual(record.remainingSteps, 3000)
    }
    
    func testDailyStepRecord_estimatedMinutes() {
        let record = DailyStepRecord(stepCount: 7000, goalSteps: 8000)
        XCTAssertEqual(record.estimatedMinutesRemaining, 10) // 1000 / 100
    }
    
    func testDailyStepRecord_progress() {
        let record = DailyStepRecord(stepCount: 6000, goalSteps: 8000)
        XCTAssertEqual(record.progress, 0.75, accuracy: 0.001)
    }
}
