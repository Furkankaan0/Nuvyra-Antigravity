import SwiftUI

/// İzin açıklama kartı — HealthKit, Notification gibi sistem izinlerini
/// kullanıcıya açıklamak için pre-permission ekranlarında kullanılır.
struct NuvyraPermissionCard: View {
    
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let bulletPoints: [String]
    
    init(
        icon: String,
        iconColor: Color = NuvyraColors.primaryAdaptive,
        title: String,
        description: String,
        bulletPoints: [String] = []
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.description = description
        self.bulletPoints = bulletPoints
    }
    
    var body: some View {
        VStack(spacing: NuvyraSpacing.lg) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 72, height: 72)
                
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(iconColor)
            }
            
            // Title
            Text(title)
                .font(NuvyraTypography.title)
                .foregroundStyle(NuvyraColors.textPrimary)
                .multilineTextAlignment(.center)
            
            // Description
            Text(description)
                .font(NuvyraTypography.callout)
                .foregroundStyle(NuvyraColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            // Bullet points
            if !bulletPoints.isEmpty {
                VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
                    ForEach(bulletPoints, id: \.self) { point in
                        HStack(alignment: .top, spacing: NuvyraSpacing.sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(iconColor)
                                .padding(.top, 2)
                            
                            Text(point)
                                .font(NuvyraTypography.callout)
                                .foregroundStyle(NuvyraColors.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, NuvyraSpacing.sm)
            }
        }
        .padding(NuvyraSpacing.xl)
        .background(NuvyraColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.cardRadius, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

#Preview("Permission Card") {
    ScrollView {
        VStack(spacing: 16) {
            NuvyraPermissionCard(
                icon: "heart.fill",
                iconColor: .red,
                title: "Apple Sağlık Bağlantısı",
                description: "Adımlarını otomatik almak için Apple Sağlık bağlantısı açabilirsin. İstediğin zaman kapatabilirsin.",
                bulletPoints: [
                    "Günlük adım sayını otomatik okur",
                    "Yürüyüş hedefini kişiselleştirir",
                    "Verilerini kimseyle paylaşmaz"
                ]
            )
            
            NuvyraPermissionCard(
                icon: "bell.badge.fill",
                iconColor: NuvyraColors.secondaryAdaptive,
                title: "Bildirimler",
                description: "Seni rahatsız etmeyen, sadece ritmini hatırlatan bildirimler."
            )
        }
        .padding()
    }
    .background(NuvyraColors.background)
}
