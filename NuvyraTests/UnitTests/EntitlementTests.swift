import XCTest
@testable import Nuvyra

final class EntitlementTests: XCTestCase {
    
    func testFreeEntitlement_isNotPremium() {
        let status = EntitlementStatus.free
        XCTAssertEqual(status.tier, .free)
        XCTAssertTrue(status.isActive)
        XCTAssertFalse(status.isPremiumOrAbove)
        XCTAssertFalse(status.isPremiumPlus)
    }
    
    func testPremiumEntitlement_isPremiumOrAbove() {
        let status = EntitlementStatus(
            tier: .premium, isActive: true,
            expirationDate: Date().addingTimeInterval(86400 * 30),
            isTrialActive: false, lastVerifiedAt: Date()
        )
        XCTAssertTrue(status.isPremiumOrAbove)
        XCTAssertFalse(status.isPremiumPlus)
    }
    
    func testPremiumPlusEntitlement_isPremiumAndPlus() {
        let status = EntitlementStatus(
            tier: .premiumPlus, isActive: true,
            expirationDate: nil, isTrialActive: false, lastVerifiedAt: Date()
        )
        XCTAssertTrue(status.isPremiumOrAbove)
        XCTAssertTrue(status.isPremiumPlus)
    }
    
    func testInactiveSubscription_isNotPremium() {
        let status = EntitlementStatus(
            tier: .premium, isActive: false,
            expirationDate: Date().addingTimeInterval(-86400),
            isTrialActive: false, lastVerifiedAt: Date()
        )
        XCTAssertFalse(status.isPremiumOrAbove)
    }
    
    func testSubscriptionTier_productIDs() {
        XCTAssertTrue(SubscriptionTier.free.productIds.isEmpty)
        XCTAssertEqual(SubscriptionTier.premium.productIds.count, 2)
        XCTAssertEqual(SubscriptionTier.premiumPlus.productIds.count, 2)
        XCTAssertTrue(SubscriptionTier.premium.productIds.contains("com.nuvyra.premium.monthly"))
        XCTAssertTrue(SubscriptionTier.premiumPlus.productIds.contains("com.nuvyra.plus.yearly"))
    }
    
    func testEntitlementStatus_encoding() throws {
        let status = EntitlementStatus(
            tier: .premium, isActive: true,
            expirationDate: Date(), isTrialActive: true, lastVerifiedAt: Date()
        )
        let data = try JSONEncoder().encode(status)
        let decoded = try JSONDecoder().decode(EntitlementStatus.self, from: data)
        XCTAssertEqual(decoded.tier, .premium)
        XCTAssertTrue(decoded.isActive)
        XCTAssertTrue(decoded.isTrialActive)
    }
}
