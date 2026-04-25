import SwiftUI
import SwiftData

/// Profil ve ayarlar ekranı
struct ProfileView: View {
    
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @State private var profile: UserProfile?
    
    var body: some View {
        NavigationStack {
            List {
                if let profile {
                    Section("Profil") {
                        profileRow("Yaş", value: "\(profile.age)")
                        profileRow("Boy", value: "\(Int(profile.heightCm)) cm")
                        profileRow("Kilo", value: "\(Int(profile.weightKg)) kg")
                        if let target = profile.targetWeightKg { profileRow("Hedef Kilo", value: "\(Int(target)) kg") }
                        profileRow("Aktivite", value: profile.activityLevel.displayName)
                    }
                    
                    Section("Günlük Hedefler") {
                        profileRow("Kalori", value: "\(profile.dailyCalorieTarget) kcal")
                        profileRow("Adım", value: "\(profile.dailyStepTarget.formatted())")
                        profileRow("Su", value: "\(profile.dailyWaterTargetMl) ml")
                    }
                }
                
                Section("Abonelik") {
                    Button { appState.activeSheet = .paywall } label: {
                        HStack {
                            Image(systemName: "sparkles").foregroundStyle(NuvyraColors.primaryAdaptive)
                            Text("Premium'a Geç").foregroundStyle(NuvyraColors.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(NuvyraColors.textTertiary)
                        }
                    }
                }
                
                Section("Uygulama") {
                    Button { appState.activeSheet = .settings } label: {
                        HStack {
                            Image(systemName: "gearshape").foregroundStyle(NuvyraColors.textSecondary)
                            Text("Ayarlar").foregroundStyle(NuvyraColors.textPrimary)
                        }
                    }
                    Button { appState.activeSheet = .weeklySummary } label: {
                        HStack {
                            Image(systemName: "doc.text").foregroundStyle(NuvyraColors.textSecondary)
                            Text("Haftalık Özet").foregroundStyle(NuvyraColors.textPrimary)
                        }
                    }
                }
                
                Section {
                    Text("Nuvyra tıbbi tavsiye vermez. Wellness ve fitness koçluk uygulamasıdır. Sağlık durumunuzla ilgili profesyonel destek almanızı öneririz.")
                        .font(NuvyraTypography.caption)
                        .foregroundStyle(NuvyraColors.textTertiary)
                }
            }
            .navigationTitle("Profil")
            .task { loadProfile() }
        }
    }
    
    private func profileRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title).foregroundStyle(NuvyraColors.textSecondary)
            Spacer()
            Text(value).foregroundStyle(NuvyraColors.textPrimary).font(NuvyraTypography.bodyBold)
        }
    }
    
    private func loadProfile() {
        let descriptor = FetchDescriptor<UserProfile>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        profile = try? modelContext.fetch(descriptor).first
    }
}

/// Ayarlar ekranı
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    
    var body: some View {
        List {
            Section("Bildirimler") {
                NavigationLink("Bildirim Ayarları") {}
            }
            Section("Veri") {
                NavigationLink("Gizlilik Politikası") {}
                NavigationLink("KVKK Aydınlatma Metni") {}
                Button("Verilerimi Sil", role: .destructive) {}
            }
            Section("Geliştirici") {
                #if DEBUG
                Button("Onboarding'i Sıfırla") {
                    appState.resetForTesting()
                    dismiss()
                }
                #endif
            }
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Nuvyra").font(NuvyraTypography.caption2).foregroundStyle(NuvyraColors.textSecondary)
                        Text("Versiyon 1.0.0").font(NuvyraTypography.caption).foregroundStyle(NuvyraColors.textTertiary)
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Ayarlar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Kapat") { dismiss() }
            }
        }
    }
}
