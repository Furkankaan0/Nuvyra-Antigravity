import SwiftUI
import SwiftData

/// Öğün kayıt ana ekranı — bugünkü öğünlerin listesi ve ekleme seçenekleri
struct MealLoggingView: View {
    
    @State private var viewModel = MealLoggingViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: NuvyraSpacing.cardGap) {
                    // Quick add chips
                    turkishQuickMeals
                    
                    // Today's meals by type
                    ForEach(MealType.allCases) { mealType in
                        mealSection(for: mealType)
                    }
                    
                    Spacer(minLength: NuvyraSpacing.huge)
                }
                .padding(.horizontal, NuvyraSpacing.pageHorizontal)
                .padding(.top, NuvyraSpacing.sm)
            }
            .background(NuvyraColors.background.ignoresSafeArea())
            .navigationTitle("Öğünler")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button { appState.activeSheet = .addMeal } label: {
                            Label("Manuel Ekle", systemImage: "pencil")
                        }
                        Button { appState.activeSheet = .photoMeal } label: {
                            Label("Fotoğrafla Ekle", systemImage: "camera")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(NuvyraColors.primaryAdaptive)
                    }
                }
            }
            .task { viewModel.loadMeals(modelContext: modelContext) }
        }
    }
    
    private var turkishQuickMeals: some View {
        VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
            Text("Hızlı Ekle")
                .font(NuvyraTypography.cardTitle)
                .foregroundStyle(NuvyraColors.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: NuvyraSpacing.xs) {
                    ForEach(TurkishQuickMeal.all.prefix(8)) { meal in
                        NuvyraChip("\(meal.emoji) \(meal.name)") {
                            viewModel.addQuickMeal(meal, modelContext: modelContext)
                        }
                    }
                }
            }
        }
    }
    
    private func mealSection(for type: MealType) -> some View {
        let meals = viewModel.todayMeals.filter { $0.mealType == type }
        return VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundStyle(NuvyraColors.primaryAdaptive)
                Text(type.displayName)
                    .font(NuvyraTypography.cardTitle)
                    .foregroundStyle(NuvyraColors.textPrimary)
                Spacer()
                if !meals.isEmpty {
                    Text("\(meals.reduce(0) { $0 + $1.calories }) kcal")
                        .font(NuvyraTypography.caption2)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
            }
            
            if meals.isEmpty {
                Text("Henüz kayıt yok")
                    .font(NuvyraTypography.caption)
                    .foregroundStyle(NuvyraColors.textTertiary)
                    .padding(.vertical, NuvyraSpacing.xs)
            }
            
            ForEach(meals) { meal in
                MealDetailCard(meal: meal) {
                    viewModel.deleteMeal(meal, modelContext: modelContext)
                }
            }
        }
    }
}

struct MealDetailCard: View {
    let meal: MealEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: NuvyraSpacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: NuvyraSpacing.xxxs) {
                    Text(meal.name).font(NuvyraTypography.bodyBold).foregroundStyle(NuvyraColors.textPrimary)
                    if meal.isEstimated {
                        Text("Tahmini")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(NuvyraColors.warningAdaptive.opacity(0.8))
                            .clipShape(Capsule())
                    }
                }
                HStack(spacing: NuvyraSpacing.sm) {
                    macroText("P", value: meal.protein, color: NuvyraColors.protein)
                    macroText("K", value: meal.carbs, color: NuvyraColors.carbs)
                    macroText("Y", value: meal.fat, color: NuvyraColors.fat)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(meal.calories) kcal").font(NuvyraTypography.caption2).foregroundStyle(NuvyraColors.textPrimary)
                Text(NuvyraDateFormatters.time.string(from: meal.timestamp))
                    .font(NuvyraTypography.caption).foregroundStyle(NuvyraColors.textTertiary)
            }
        }
        .padding(NuvyraSpacing.sm)
        .background(NuvyraColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
        .contextMenu {
            Button(role: .destructive) { onDelete() } label: { Label("Sil", systemImage: "trash") }
        }
    }
    
    private func macroText(_ label: String, value: Double, color: Color) -> some View {
        Text("\(label): \(Int(value))g").font(NuvyraTypography.caption).foregroundStyle(color)
    }
}
