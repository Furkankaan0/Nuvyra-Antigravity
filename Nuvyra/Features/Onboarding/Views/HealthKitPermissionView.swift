import SwiftUI

/// HealthKit izin açıklama ekranı — sistem popup'ından önce
struct HealthKitPermissionView: View {
    
    @State private var healthKitManager = HealthKitManager()
    @State private var hasRequested = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: NuvyraSpacing.xl) {
                Spacer(minLength: NuvyraSpacing.xxl)
                
                NuvyraPermissionCard(
                    icon: "heart.fill",
                    iconColor: .red,
                    title: "Apple Sağlık Bağlantısı",
                    description: "Adımlarını otomatik almak için Apple Sağlık bağlantısı açabilirsin. İstediğin zaman kapatabilirsin.",
                    bulletPoints: [
                        "Günlük adım sayını otomatik okur",
                        "Yürüyüş hedefini kişiselleştirir",
                        "Verilerini asla reklam amacıyla kullanmaz",
                        "İstediğin zaman bağlantıyı kapatabilirsin"
                    ]
                )
                
                if !hasRequested {
                    NuvyraPrimaryButton("Apple Sağlık'a Bağlan", icon: "heart.fill") {
                        requestHealthKit()
                    }
                } else {
                    HStack(spacing: NuvyraSpacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(NuvyraColors.success)
                        Text("İzin istendi")
                            .font(NuvyraTypography.bodyBold)
                            .foregroundStyle(NuvyraColors.textPrimary)
                    }
                    .padding(NuvyraSpacing.md)
                }
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .padding(.bottom, NuvyraSpacing.huge)
        }
    }
    
    private func requestHealthKit() {
        Task {
            do {
                try await healthKitManager.requestAuthorization()
                hasRequested = true
                NuvyraHaptics.success()
            } catch {
                hasRequested = true
            }
        }
    }
}

/// Bildirim izin açıklama ekranı
struct NotificationPermissionView: View {
    
    @State private var hasRequested = false
    private let scheduler = NotificationScheduler()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: NuvyraSpacing.xl) {
                Spacer(minLength: NuvyraSpacing.xxl)
                
                NuvyraPermissionCard(
                    icon: "bell.badge.fill",
                    iconColor: NuvyraColors.secondaryAdaptive,
                    title: "Akıllı Hatırlatmalar",
                    description: "Seni rahatsız etmeyen, sadece ritmini hatırlatan bildirimler.",
                    bulletPoints: [
                        "Öğün zamanı hatırlatmaları",
                        "Su içme hatırlatmaları",
                        "Yürüyüş hedefi motivasyonu",
                        "Bildirim saatlerini istediğin gibi ayarla"
                    ]
                )
                
                if !hasRequested {
                    NuvyraPrimaryButton("Bildirimleri Aç", icon: "bell.fill") {
                        requestNotifications()
                    }
                } else {
                    HStack(spacing: NuvyraSpacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(NuvyraColors.success)
                        Text("Bildirimler ayarlandı")
                            .font(NuvyraTypography.bodyBold)
                            .foregroundStyle(NuvyraColors.textPrimary)
                    }
                    .padding(NuvyraSpacing.md)
                }
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .padding(.bottom, NuvyraSpacing.huge)
        }
    }
    
    private func requestNotifications() {
        Task {
            let _ = try? await scheduler.requestPermission()
            hasRequested = true
            NuvyraHaptics.success()
        }
    }
}
