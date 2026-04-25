import SwiftUI

/// Haftalık koç özeti — premium değerin ana parçası
struct WeeklySummaryView: View {
    
    @Environment(\.dismiss) private var dismiss
    private let summary = WeeklySummary.mockSummary
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: NuvyraSpacing.xl) {
                // Header
                VStack(spacing: NuvyraSpacing.sm) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(NuvyraColors.primaryAdaptive)
                    Text("Haftalık Koç Özetin")
                        .font(NuvyraTypography.title)
                        .foregroundStyle(NuvyraColors.textPrimary)
                }
                
                // Stats grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: NuvyraSpacing.sm) {
                    statCard(title: "Ort. Kalori", value: "\(summary.averageCalories)", unit: "kcal", icon: "flame.fill", color: .orange)
                    statCard(title: "Ort. Adım", value: summary.averageSteps.formatted(), unit: "adım", icon: "figure.walk", color: NuvyraColors.primaryAdaptive)
                    statCard(title: "En İyi Gün", value: summary.bestDay ?? "-", unit: "", icon: "star.fill", color: .yellow)
                    statCard(title: "Zorlanılan Gün", value: summary.hardestDay ?? "-", unit: "", icon: "cloud.fill", color: NuvyraColors.textTertiary)
                }
                
                // Coach message
                NuvyraGlassCard {
                    VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
                        HStack {
                            Image(systemName: "bubble.left.fill").foregroundStyle(NuvyraColors.primaryAdaptive)
                            Text("Koç Notu").font(NuvyraTypography.cardTitle).foregroundStyle(NuvyraColors.textPrimary)
                        }
                        Text(summary.coachMessage)
                            .font(NuvyraTypography.callout)
                            .foregroundStyle(NuvyraColors.textSecondary)
                            .lineSpacing(4)
                    }
                }
                
                // Suggestions
                VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
                    Text("Gelecek Hafta İçin Öneriler")
                        .font(NuvyraTypography.cardTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    
                    ForEach(summary.suggestions, id: \.self) { suggestion in
                        HStack(alignment: .top, spacing: NuvyraSpacing.sm) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundStyle(.yellow)
                                .font(.system(size: 14))
                                .padding(.top, 2)
                            Text(suggestion)
                                .font(NuvyraTypography.callout)
                                .foregroundStyle(NuvyraColors.textPrimary)
                        }
                    }
                }
                
                Spacer(minLength: NuvyraSpacing.huge)
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .padding(.top, NuvyraSpacing.xl)
        }
        .background(NuvyraColors.background.ignoresSafeArea())
        .navigationTitle("Haftalık Özet")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func statCard(title: String, value: String, unit: String, icon: String, color: Color) -> some View {
        VStack(spacing: NuvyraSpacing.xs) {
            Image(systemName: icon).foregroundStyle(color).font(.system(size: 18))
            Text(value).font(NuvyraTypography.metricCard).foregroundStyle(NuvyraColors.textPrimary)
            if !unit.isEmpty { Text(unit).font(NuvyraTypography.caption).foregroundStyle(NuvyraColors.textTertiary) }
            Text(title).font(NuvyraTypography.caption2).foregroundStyle(NuvyraColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(NuvyraSpacing.md)
        .background(NuvyraColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
    }
}
