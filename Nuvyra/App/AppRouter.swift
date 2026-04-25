import SwiftUI

/// Ana navigasyon yöneticisi.
/// Onboarding tamamlanmadıysa onboarding'e, tamamlandıysa ana tab bar'a yönlendirir.
struct AppRouter: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingContainerView()
            }
        }
        .animation(.smooth(duration: 0.5), value: appState.hasCompletedOnboarding)
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var state = appState
        
        TabView(selection: $state.selectedTab) {
            DashboardView()
                .tabItem {
                    Label(AppState.AppTab.dashboard.title,
                          systemImage: AppState.AppTab.dashboard.icon)
                }
                .tag(AppState.AppTab.dashboard)
            
            MealLoggingView()
                .tabItem {
                    Label(AppState.AppTab.meals.title,
                          systemImage: AppState.AppTab.meals.icon)
                }
                .tag(AppState.AppTab.meals)
            
            WalkingView()
                .tabItem {
                    Label(AppState.AppTab.walking.title,
                          systemImage: AppState.AppTab.walking.icon)
                }
                .tag(AppState.AppTab.walking)
            
            ProfileView()
                .tabItem {
                    Label(AppState.AppTab.profile.title,
                          systemImage: AppState.AppTab.profile.icon)
                }
                .tag(AppState.AppTab.profile)
        }
        .tint(NuvyraColors.primary)
        .sheet(item: $state.activeSheet) { sheet in
            sheetContent(for: sheet)
        }
    }
    
    @ViewBuilder
    private func sheetContent(for sheet: AppState.ActiveSheet) -> some View {
        switch sheet {
        case .addMeal:
            NavigationStack {
                ManualMealEntryView()
            }
        case .photoMeal:
            NavigationStack {
                PhotoMealView()
            }
        case .paywall:
            PaywallView()
        case .settings:
            NavigationStack {
                SettingsView()
            }
        case .weeklySummary:
            NavigationStack {
                WeeklySummaryView()
            }
        }
    }
}

#Preview {
    AppRouter()
        .environment(AppState())
}
