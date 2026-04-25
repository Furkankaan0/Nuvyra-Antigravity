import Foundation
import Observation

/// Kullanıcının aktif premium durumunu yöneten servis.
/// Offline durumda son bilinen entitlement güvenli şekilde saklanır.
@Observable
final class EntitlementManager {
    
    private let storeKitService: StoreKitService
    private let defaults = UserDefaults.standard
    
    var currentStatus: EntitlementStatus
    
    init(storeKitService: StoreKitService) {
        self.storeKitService = storeKitService
        // Kaydedilmiş durumu yükle
        if let data = UserDefaults.standard.data(forKey: Keys.entitlementStatus),
           let status = try? JSONDecoder().decode(EntitlementStatus.self, from: data) {
            self.currentStatus = status
        } else {
            self.currentStatus = .free
        }
    }
    
    /// Entitlement durumunu güncelle
    @MainActor
    func refresh() async {
        await storeKitService.refreshEntitlements()
        let purchased = storeKitService.purchasedProductIDs
        
        if purchased.contains(where: { $0.contains("plus") }) {
            currentStatus = EntitlementStatus(
                tier: .premiumPlus, isActive: true, expirationDate: nil,
                isTrialActive: false, lastVerifiedAt: Date()
            )
        } else if purchased.contains(where: { $0.contains("premium") }) {
            currentStatus = EntitlementStatus(
                tier: .premium, isActive: true, expirationDate: nil,
                isTrialActive: false, lastVerifiedAt: Date()
            )
        } else {
            currentStatus = .free
        }
        
        saveStatus()
    }
    
    /// Premium feature'a erişim var mı?
    var canAccessPremium: Bool { currentStatus.isPremiumOrAbove }
    
    /// Premium Plus feature'a erişim var mı?
    var canAccessPlus: Bool { currentStatus.isPremiumPlus }
    
    private func saveStatus() {
        if let data = try? JSONEncoder().encode(currentStatus) {
            defaults.set(data, forKey: Keys.entitlementStatus)
        }
    }
    
    private enum Keys {
        static let entitlementStatus = "nuvyra_entitlement_status"
    }
}
