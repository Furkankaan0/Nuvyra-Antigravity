import Foundation

/// Analitik event tanımları — privacy-safe, aggregate payload'lar.
/// Kişisel sağlık detaylarını asla doğrudan payload'a ekleme.
enum AnalyticsEvent {
    // Onboarding
    case onboardingStarted
    case goalSelected(goalType: String)
    case onboardingCompleted
    
    // HealthKit
    case healthKitPrePromptViewed
    case healthKitGrantedSteps
    case healthKitDeniedSteps
    
    // Meals
    case mealLoggedFirst
    case mealLogged(mealType: String)
    case photoMealStarted
    case photoMealCompleted
    
    // Walking
    case walkGoalCompleted
    
    // Weekly
    case weeklySummaryOpened
    
    // Subscription
    case paywallViewed(source: String)
    case trialStarted
    case subscriptionPurchased(tier: String)
    case restorePurchasesTapped
    case subscriptionCancelIntent
    
    // Notifications
    case notificationPermissionGranted
    case notificationPermissionDenied
    
    // Watch
    case watchConnected
    
    var name: String {
        switch self {
        case .onboardingStarted: "onboarding_started"
        case .goalSelected: "goal_selected"
        case .onboardingCompleted: "onboarding_completed"
        case .healthKitPrePromptViewed: "healthkit_preprompt_viewed"
        case .healthKitGrantedSteps: "healthkit_granted_steps"
        case .healthKitDeniedSteps: "healthkit_denied_steps"
        case .mealLoggedFirst: "meal_logged_first"
        case .mealLogged: "meal_logged"
        case .photoMealStarted: "photo_meal_started"
        case .photoMealCompleted: "photo_meal_completed"
        case .walkGoalCompleted: "walk_goal_completed"
        case .weeklySummaryOpened: "weekly_summary_opened"
        case .paywallViewed: "paywall_viewed"
        case .trialStarted: "trial_started"
        case .subscriptionPurchased: "subscription_purchased"
        case .restorePurchasesTapped: "restore_purchases_tapped"
        case .subscriptionCancelIntent: "subscription_cancel_intent"
        case .notificationPermissionGranted: "notification_permission_granted"
        case .notificationPermissionDenied: "notification_permission_denied"
        case .watchConnected: "watch_connected"
        }
    }
    
    /// Privacy-safe parametreler — kişisel veri içermez
    var parameters: [String: String] {
        switch self {
        case .goalSelected(let goalType): ["goal_type": goalType]
        case .mealLogged(let mealType): ["meal_type": mealType]
        case .paywallViewed(let source): ["source": source]
        case .subscriptionPurchased(let tier): ["tier": tier]
        default: [:]
        }
    }
}
