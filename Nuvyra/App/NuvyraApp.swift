import SwiftUI
import SwiftData

/// Nuvyra — Kalori ve Yürüyüş Koçu
/// Ana uygulama giriş noktası
@main
struct NuvyraApp: App {
    
    @State private var appState = AppState()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            MealEntry.self,
            WaterEntry.self,
            DailyStepRecord.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("ModelContainer oluşturulamadı: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            AppRouter()
                .environment(appState)
                .modelContainer(sharedModelContainer)
                .preferredColorScheme(appState.preferredColorScheme)
        }
    }
}
