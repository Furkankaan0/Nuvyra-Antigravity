import SwiftUI
import SwiftData

/// Ana Dashboard ekranı
struct DashboardView: View {
    
    @State private var viewModel = DashboardViewModel()
    @State private var healthKitManager = HealthKitManager()
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: NuvyraSpacing.cardGap) {
                    // Header
                    headerSection
                    
                    // Main calorie ring
                    calorieSection
                    
                    // Step & Water cards
                    HStack(spacing: NuvyraSpacing.cardGap) {
                        StepSummaryCard(steps: viewModel.todaySteps, goal: viewModel.stepTarget)
                        WaterTrackingCard(
                            currentMl: viewModel.todayWaterMl,
                            targetMl: viewModel.waterTargetMl,
                            onAddWater: { addWater() }
                        )
                    }
                    
                    // Daily tip
                    if let tip = viewModel.dailyTip {
                        DailyTipCard(tip: tip)
                    }
                    
                    // Quick actions
                    QuickActionsBar(appState: appState)
                    
                    // Recent meals
                    recentMealsSection
                    
                    Spacer(minLength: NuvyraSpacing.huge)
                }
                .padding(.horizontal, NuvyraSpacing.pageHorizontal)
                .padding(.top, NuvyraSpacing.sm)
            }
            .background(NuvyraColors.background.ignoresSafeArea())
            .refreshable { await loadData() }
            .task { await loadData() }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: NuvyraSpacing.xxxs) {
            Text(viewModel.greeting)
                .font(NuvyraTypography.largeTitle)
                .foregroundStyle(NuvyraColors.textPrimary)
            Text("Bugünkü ritmin")
                .font(NuvyraTypography.callout)
                .foregroundStyle(NuvyraColors.textSecondary)
            Text(viewModel.todayDate)
                .font(NuvyraTypography.caption)
                .foregroundStyle(NuvyraColors.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Calorie Section
    private var calorieSection: some View {
        NuvyraGlassCard {
            VStack(spacing: NuvyraSpacing.md) {
                NuvyraProgressRing(
                    progress: viewModel.calorieProgress,
                    size: 160,
                    gradientColors: [.orange, NuvyraColors.primaryAdaptive],
                    value: "\(viewModel.todayCalories)",
                    unit: "kcal",
                    label: "alındı"
                )
                
                HStack(spacing: NuvyraSpacing.xl) {
                    macroLabel(title: "Hedef", value: "\(viewModel.calorieTarget)", color: NuvyraColors.textSecondary)
                    macroLabel(title: "Kalan", value: "\(viewModel.remainingCalories)", color: NuvyraColors.primaryAdaptive)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func macroLabel(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(NuvyraTypography.caption2)
                .foregroundStyle(NuvyraColors.textTertiary)
            Text(value)
                .font(NuvyraTypography.metricCard)
                .foregroundStyle(color)
                .contentTransition(.numericText())
        }
    }
    
    // MARK: - Recent Meals
    private var recentMealsSection: some View {
        VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
            Text("Son Öğünler")
                .font(NuvyraTypography.cardTitle)
                .foregroundStyle(NuvyraColors.textPrimary)
            
            if viewModel.todayMeals.isEmpty {
                emptyMealsCard
            } else {
                ForEach(viewModel.todayMeals.prefix(3)) { meal in
                    mealRow(meal)
                }
            }
        }
    }
    
    private var emptyMealsCard: some View {
        NuvyraGlassCard {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.system(size: 24))
                    .foregroundStyle(NuvyraColors.textTertiary)
                VStack(alignment: .leading, spacing: 2) {
                    Text("İlk öğününü ekleyelim")
                        .font(NuvyraTypography.bodyBold)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    Text("Bugün ne yedin?")
                        .font(NuvyraTypography.caption)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(NuvyraColors.primaryAdaptive)
            }
        }
        .onTapGesture {
            appState.activeSheet = .addMeal
        }
    }
    
    private func mealRow(_ meal: MealEntry) -> some View {
        HStack(spacing: NuvyraSpacing.sm) {
            Image(systemName: meal.mealType.icon)
                .font(.system(size: 16))
                .foregroundStyle(NuvyraColors.primaryAdaptive)
                .frame(width: 32, height: 32)
                .background(NuvyraColors.primaryAdaptive.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(meal.name)
                    .font(NuvyraTypography.bodyBold)
                    .foregroundStyle(NuvyraColors.textPrimary)
                Text(NuvyraDateFormatters.time.string(from: meal.timestamp))
                    .font(NuvyraTypography.caption)
                    .foregroundStyle(NuvyraColors.textTertiary)
            }
            Spacer()
            Text("\(meal.calories) kcal")
                .font(NuvyraTypography.caption2)
                .foregroundStyle(NuvyraColors.textSecondary)
        }
        .padding(NuvyraSpacing.sm)
        .background(NuvyraColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
    }
    
    // MARK: - Actions
    private func loadData() async {
        await viewModel.loadData(modelContext: modelContext, healthKitManager: healthKitManager)
    }
    
    private func addWater() {
        viewModel.addWater(ml: 250, modelContext: modelContext)
    }
}

// MARK: - Sub-cards

struct StepSummaryCard: View {
    let steps: Int
    let goal: Int
    var progress: Double { guard goal > 0 else { return 0 }; return Double(steps) / Double(goal) }
    
    var body: some View {
        NuvyraMetricCard(
            title: "Adımlar",
            value: steps.formatted(),
            unit: "adım",
            subtitle: "Hedef: \(goal.formatted())",
            icon: "figure.walk",
            iconColor: NuvyraColors.primaryAdaptive,
            progress: progress
        )
    }
}

struct WaterTrackingCard: View {
    let currentMl: Int
    let targetMl: Int
    let onAddWater: () -> Void
    var liters: String { String(format: "%.1f", Double(currentMl) / 1000.0) }
    var progress: Double { guard targetMl > 0 else { return 0 }; return Double(currentMl) / Double(targetMl) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
            NuvyraMetricCard(
                title: "Su",
                value: liters,
                unit: "L",
                icon: "drop.fill",
                iconColor: NuvyraColors.water,
                progress: progress,
                progressColor: NuvyraColors.water
            )
        }
        .onTapGesture { onAddWater() }
    }
}

struct DailyTipCard: View {
    let tip: CoachingTip
    
    var body: some View {
        NuvyraGlassCard {
            HStack(alignment: .top, spacing: NuvyraSpacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.yellow)
                
                VStack(alignment: .leading, spacing: NuvyraSpacing.xxxs) {
                    Text("Bugün için önerim")
                        .font(NuvyraTypography.caption2)
                        .foregroundStyle(NuvyraColors.textSecondary)
                    Text(tip.message)
                        .font(NuvyraTypography.callout)
                        .foregroundStyle(NuvyraColors.textPrimary)
                        .lineSpacing(3)
                }
                Spacer()
            }
        }
    }
}

struct QuickActionsBar: View {
    let appState: AppState
    
    var body: some View {
        HStack(spacing: NuvyraSpacing.sm) {
            quickActionButton(icon: "plus.circle.fill", title: "Öğün Ekle") {
                appState.activeSheet = .addMeal
            }
            quickActionButton(icon: "camera.fill", title: "Fotoğrafla") {
                appState.activeSheet = .photoMeal
            }
            quickActionButton(icon: "drop.fill", title: "Su İçtim") {}
        }
    }
    
    private func quickActionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: { NuvyraHaptics.light(); action() }) {
            VStack(spacing: NuvyraSpacing.xxxs) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(NuvyraColors.primaryAdaptive)
                Text(title)
                    .font(NuvyraTypography.caption2)
                    .foregroundStyle(NuvyraColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, NuvyraSpacing.sm)
            .background(NuvyraColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
