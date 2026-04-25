import SwiftUI

/// Yürüyüş ve adım koçluğu ekranı
struct WalkingView: View {
    
    @State private var viewModel = WalkingViewModel()
    @State private var healthKitManager = HealthKitManager()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: NuvyraSpacing.cardGap) {
                    // Main progress ring
                    NuvyraGlassCard {
                        VStack(spacing: NuvyraSpacing.md) {
                            NuvyraProgressRing(
                                progress: viewModel.stepProgress,
                                size: 180,
                                gradientColors: [NuvyraColors.primaryAdaptive, NuvyraColors.secondaryAdaptive],
                                value: viewModel.todaySteps.formatted(),
                                unit: "adım",
                                label: "bugün"
                            )
                            
                            if viewModel.remainingSteps > 0 {
                                Text("Hedefe \(viewModel.remainingSteps.formatted()) adım kaldı")
                                    .font(NuvyraTypography.callout)
                                    .foregroundStyle(NuvyraColors.textSecondary)
                                
                                Text("≈ \(viewModel.estimatedMinutes) dakika yürüyüş")
                                    .font(NuvyraTypography.caption)
                                    .foregroundStyle(NuvyraColors.textTertiary)
                            } else {
                                HStack(spacing: NuvyraSpacing.xs) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(NuvyraColors.success)
                                    Text("Bugünkü hedefini tamamladın! 🎉")
                                        .font(NuvyraTypography.bodyBold)
                                        .foregroundStyle(NuvyraColors.success)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Motivation card
                    NuvyraGlassCard {
                        HStack(alignment: .top, spacing: NuvyraSpacing.sm) {
                            Image(systemName: "bubble.left.fill")
                                .foregroundStyle(NuvyraColors.primaryAdaptive)
                            Text(viewModel.motivationMessage)
                                .font(NuvyraTypography.callout)
                                .foregroundStyle(NuvyraColors.textPrimary)
                                .lineSpacing(3)
                            Spacer()
                        }
                    }
                    
                    // Weekly chart placeholder
                    VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
                        Text("Haftalık Adımlar")
                            .font(NuvyraTypography.cardTitle)
                            .foregroundStyle(NuvyraColors.textPrimary)
                        
                        HStack(alignment: .bottom, spacing: NuvyraSpacing.xs) {
                            ForEach(viewModel.weeklyData, id: \.day) { data in
                                VStack(spacing: NuvyraSpacing.xxxs) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(data.isToday ? NuvyraColors.primaryAdaptive : NuvyraColors.primaryAdaptive.opacity(0.3))
                                        .frame(height: max(4, CGFloat(data.steps) / CGFloat(viewModel.stepGoal) * 80))
                                    Text(data.day)
                                        .font(NuvyraTypography.caption2)
                                        .foregroundStyle(data.isToday ? NuvyraColors.textPrimary : NuvyraColors.textTertiary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 100)
                        .padding(NuvyraSpacing.md)
                        .background(NuvyraColors.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.cardRadiusSmall))
                    }
                    
                    // Mini walk task
                    NuvyraGlassCard {
                        HStack(spacing: NuvyraSpacing.sm) {
                            Image(systemName: "figure.walk.motion")
                                .font(.system(size: 28))
                                .foregroundStyle(NuvyraColors.primaryAdaptive)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mini Yürüyüş Görevi")
                                    .font(NuvyraTypography.cardTitle)
                                    .foregroundStyle(NuvyraColors.textPrimary)
                                Text("10 dakikalık hafif yürüyüş ritmini toparlar.")
                                    .font(NuvyraTypography.caption)
                                    .foregroundStyle(NuvyraColors.textSecondary)
                            }
                            Spacer()
                        }
                    }
                    
                    Spacer(minLength: NuvyraSpacing.huge)
                }
                .padding(.horizontal, NuvyraSpacing.pageHorizontal)
                .padding(.top, NuvyraSpacing.sm)
            }
            .background(NuvyraColors.background.ignoresSafeArea())
            .navigationTitle("Yürüyüş")
            .task { await viewModel.loadData(healthKitManager: healthKitManager) }
        }
    }
}

@Observable
final class WalkingViewModel {
    var todaySteps: Int = 0
    var stepGoal: Int = 8000
    var remainingSteps: Int { max(0, stepGoal - todaySteps) }
    var estimatedMinutes: Int { max(1, remainingSteps / 100) }
    var stepProgress: Double { guard stepGoal > 0 else { return 0 }; return Double(todaySteps) / Double(stepGoal) }
    
    struct WeekDay: Identifiable { let id = UUID(); let day: String; let steps: Int; let isToday: Bool }
    var weeklyData: [WeekDay] = []
    
    var motivationMessage: String {
        if remainingSteps <= 0 { return "Harika! Bugünkü hedefini tamamladın. Devamlılık en önemli adım." }
        if remainingSteps < 2000 { return "Hedefe çok yakınsın! \(estimatedMinutes) dakikalık kısa bir yürüyüş yeterli." }
        return "Bugün düşük tempoda kalmak da sorun değil. Devamlılık daha önemli."
    }
    
    @MainActor
    func loadData(healthKitManager: HealthKitManager) async {
        todaySteps = (try? await healthKitManager.fetchTodaySteps()) ?? 0
        let days = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"]
        let todayIndex = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
        weeklyData = days.enumerated().map { i, d in
            WeekDay(day: d, steps: i == todayIndex ? todaySteps : Int.random(in: 3000...12000), isToday: i == todayIndex)
        }
    }
}
