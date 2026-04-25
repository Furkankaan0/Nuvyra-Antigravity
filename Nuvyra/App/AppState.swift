import SwiftUI
import Observation

/// Uygulamanın genel durumunu yöneten merkezi state objesi.
/// Onboarding, aktif tab, kullanıcı tercihleri gibi app-wide state'leri tutar.
@Observable
final class AppState {
    
    // MARK: - Onboarding
    
    /// Kullanıcı onboarding'i tamamladı mı?
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
    
    // MARK: - Navigation
    
    /// Aktif ana tab
    var selectedTab: AppTab = .dashboard
    
    /// Sheet presentation state
    var activeSheet: ActiveSheet?
    
    // MARK: - Appearance
    
    /// Kullanıcının tercih ettiği tema (nil = sistem)
    var preferredColorScheme: ColorScheme? = nil
    
    // MARK: - Types
    
    enum AppTab: Int, CaseIterable, Identifiable {
        case dashboard = 0
        case meals = 1
        case walking = 2
        case profile = 3
        
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .dashboard: "Ana Sayfa"
            case .meals: "Öğünler"
            case .walking: "Yürüyüş"
            case .profile: "Profil"
            }
        }
        
        var icon: String {
            switch self {
            case .dashboard: "house.fill"
            case .meals: "fork.knife"
            case .walking: "figure.walk"
            case .profile: "person.fill"
            }
        }
    }
    
    enum ActiveSheet: Identifiable {
        case addMeal
        case photoMeal
        case paywall
        case settings
        case weeklySummary
        
        var id: String {
            switch self {
            case .addMeal: "addMeal"
            case .photoMeal: "photoMeal"
            case .paywall: "paywall"
            case .settings: "settings"
            case .weeklySummary: "weeklySummary"
            }
        }
    }
    
    // MARK: - Keys
    
    private enum Keys {
        static let hasCompletedOnboarding = "nuvyra_has_completed_onboarding"
    }
    
    // MARK: - Actions
    
    /// Onboarding tamamlandığında çağır
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    /// Geliştirme/test için state sıfırla
    func resetForTesting() {
        hasCompletedOnboarding = false
        selectedTab = .dashboard
        activeSheet = nil
    }
}
