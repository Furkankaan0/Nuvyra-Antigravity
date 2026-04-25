import SwiftUI

/// Büyük metrik rakam kartı — kalori, adım, su gibi sayısal değerler için.
/// Premium, sade görünüm. Arka plan cam efektli veya düz kart.
struct NuvyraMetricCard: View {
    
    let title: String
    let value: String
    let unit: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let progress: Double? // 0.0 - 1.0 arası, nil ise progress bar gösterme
    let progressColor: Color
    
    init(
        title: String,
        value: String,
        unit: String = "",
        subtitle: String? = nil,
        icon: String,
        iconColor: Color = NuvyraColors.primaryAdaptive,
        progress: Double? = nil,
        progressColor: Color = NuvyraColors.primaryAdaptive
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.progress = progress
        self.progressColor = progressColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
            // Header
            HStack(spacing: NuvyraSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(iconColor)
                
                Text(title)
                    .font(NuvyraTypography.caption2)
                    .foregroundStyle(NuvyraColors.textSecondary)
                
                Spacer()
            }
            
            // Value
            HStack(alignment: .firstTextBaseline, spacing: NuvyraSpacing.xxxs) {
                Text(value)
                    .font(NuvyraTypography.metricCard)
                    .foregroundStyle(NuvyraColors.textPrimary)
                    .contentTransition(.numericText())
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(NuvyraTypography.caption)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
            }
            
            // Subtitle
            if let subtitle {
                Text(subtitle)
                    .font(NuvyraTypography.caption)
                    .foregroundStyle(NuvyraColors.textTertiary)
            }
            
            // Progress bar
            if let progress {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(progressColor.opacity(0.15))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(progressColor)
                            .frame(
                                width: geo.size.width * min(max(progress, 0), 1),
                                height: 6
                            )
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(NuvyraSpacing.cardPadding)
        .background(NuvyraColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.cardRadius, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

#Preview("Metric Card - Kalori") {
    VStack(spacing: 16) {
        NuvyraMetricCard(
            title: "Alınan Kalori",
            value: "1.240",
            unit: "kcal",
            subtitle: "Hedef: 2.100 kcal",
            icon: "flame.fill",
            iconColor: .orange,
            progress: 0.59,
            progressColor: .orange
        )
        
        NuvyraMetricCard(
            title: "Adımlar",
            value: "7.832",
            unit: "adım",
            subtitle: "Hedefe 2.168 adım kaldı",
            icon: "figure.walk",
            iconColor: NuvyraColors.primaryAdaptive,
            progress: 0.78
        )
        
        NuvyraMetricCard(
            title: "Su",
            value: "1.5",
            unit: "L",
            icon: "drop.fill",
            iconColor: NuvyraColors.water,
            progress: 0.6,
            progressColor: NuvyraColors.water
        )
    }
    .padding()
    .background(NuvyraColors.background)
}
