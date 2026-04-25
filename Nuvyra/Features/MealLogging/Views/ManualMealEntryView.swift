import SwiftUI
import SwiftData

/// Manuel öğün girişi
struct ManualMealEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    @State private var selectedType: MealType = .lunch
    @State private var portion = ""
    
    var body: some View {
        Form {
            Section("Yemek Bilgisi") {
                TextField("Yemek adı", text: $name)
                Picker("Öğün", selection: $selectedType) {
                    ForEach(MealType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                TextField("Porsiyon (opsiyonel)", text: $portion)
            }
            Section("Besin Değerleri") {
                TextField("Kalori (kcal)", text: $calories).keyboardType(.numberPad)
                TextField("Protein (g)", text: $protein).keyboardType(.decimalPad)
                TextField("Karbonhidrat (g)", text: $carbs).keyboardType(.decimalPad)
                TextField("Yağ (g)", text: $fat).keyboardType(.decimalPad)
            }
            Section {
                Text("Besin değerleri tahmini olabilir. Sonradan düzeltebilirsin.")
                    .font(NuvyraTypography.caption)
                    .foregroundStyle(NuvyraColors.textTertiary)
            }
        }
        .navigationTitle("Öğün Ekle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("İptal") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Kaydet") { saveMeal() }.disabled(name.isEmpty || calories.isEmpty)
            }
        }
    }
    
    private func saveMeal() {
        let meal = MealEntry(
            name: name, calories: Int(calories) ?? 0,
            protein: Double(protein) ?? 0, carbs: Double(carbs) ?? 0, fat: Double(fat) ?? 0,
            mealType: selectedType, isEstimated: false,
            portionDescription: portion.isEmpty ? nil : portion
        )
        modelContext.insert(meal)
        try? modelContext.save()
        NuvyraHaptics.success()
        dismiss()
    }
}

/// Fotoğrafla öğün kaydı
struct PhotoMealView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var isProcessing = false
    @State private var result: FoodEstimationResult?
    @State private var editableName = ""
    @State private var editableCalories = ""
    
    private let estimationService: FoodEstimationServiceProtocol = MockFoodEstimationService()
    
    var body: some View {
        VStack(spacing: NuvyraSpacing.xl) {
            if isProcessing {
                Spacer()
                ProgressView("Yemek analiz ediliyor...")
                    .font(NuvyraTypography.callout)
                Spacer()
            } else if let result {
                resultView(result)
            } else {
                cameraPlaceholder
            }
        }
        .padding(NuvyraSpacing.pageHorizontal)
        .navigationTitle("Fotoğrafla Kaydet")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("İptal") { dismiss() }
            }
        }
    }
    
    private var cameraPlaceholder: some View {
        VStack(spacing: NuvyraSpacing.lg) {
            Spacer()
            ZStack {
                Circle()
                    .fill(NuvyraColors.primaryAdaptive.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: "camera.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(NuvyraColors.primaryAdaptive)
            }
            Text("Öğününü fotoğrafla")
                .font(NuvyraTypography.title)
                .foregroundStyle(NuvyraColors.textPrimary)
            Text("Fotoğrafı çek, Nuvyra tahmini besin değerlerini hesaplasın.")
                .font(NuvyraTypography.callout)
                .foregroundStyle(NuvyraColors.textSecondary)
                .multilineTextAlignment(.center)
            
            NuvyraPrimaryButton("Fotoğraf Çek", icon: "camera") { simulatePhoto() }
            NuvyraSecondaryButton("Galeriden Seç", icon: "photo.on.rectangle") { simulatePhoto() }
            Spacer()
        }
    }
    
    private func resultView(_ result: FoodEstimationResult) -> some View {
        ScrollView {
            VStack(spacing: NuvyraSpacing.lg) {
                NuvyraGlassCard {
                    VStack(spacing: NuvyraSpacing.sm) {
                        Text(result.name).font(NuvyraTypography.title).foregroundStyle(NuvyraColors.textPrimary)
                        if result.isEstimated {
                            Text("⚠️ Tahmini değer — düzeltmek için dokunabilirsin")
                                .font(NuvyraTypography.caption).foregroundStyle(NuvyraColors.warningAdaptive)
                        }
                        HStack(spacing: NuvyraSpacing.lg) {
                            VStack { Text("\(result.calories)").font(NuvyraTypography.metricCard); Text("kcal").font(NuvyraTypography.caption) }
                            VStack { Text("\(Int(result.protein))g").font(NuvyraTypography.metricCard).foregroundStyle(NuvyraColors.protein); Text("Protein").font(NuvyraTypography.caption) }
                            VStack { Text("\(Int(result.carbs))g").font(NuvyraTypography.metricCard).foregroundStyle(NuvyraColors.carbs); Text("Karb").font(NuvyraTypography.caption) }
                            VStack { Text("\(Int(result.fat))g").font(NuvyraTypography.metricCard).foregroundStyle(NuvyraColors.fat); Text("Yağ").font(NuvyraTypography.caption) }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                NuvyraPrimaryButton("Kaydet") { saveEstimated(result) }
                NuvyraSecondaryButton("Düzenle") {}
            }
        }
    }
    
    private func simulatePhoto() {
        isProcessing = true
        Task {
            do {
                let image = UIImage()
                result = try await estimationService.estimateFood(from: image)
                isProcessing = false
            } catch {
                isProcessing = false
            }
        }
    }
    
    private func saveEstimated(_ result: FoodEstimationResult) {
        let meal = MealEntry(
            name: result.name, calories: result.calories,
            protein: result.protein, carbs: result.carbs, fat: result.fat,
            mealType: .lunch, isEstimated: true
        )
        modelContext.insert(meal)
        try? modelContext.save()
        NuvyraHaptics.success()
        dismiss()
    }
}
