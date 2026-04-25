import SwiftUI

/// Profil bilgi girişi — yaş, boy, kilo, cinsiyet, aktivite seviyesi
struct ProfileInputView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: NuvyraSpacing.xl) {
                VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
                    Text("Seni tanıyalım")
                        .font(NuvyraTypography.onboardingTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    Text("Kalori ve adım hedefini kişiselleştirmek için birkaç bilgi yeterli.")
                        .font(NuvyraTypography.onboardingSubtitle)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
                
                // Age
                inputField(title: "Yaş", value: $viewModel.age, range: 13...100, unit: "yaş")
                
                // Height
                doubleInputField(title: "Boy", value: $viewModel.heightCm, range: 100...250, unit: "cm")
                
                // Weight
                doubleInputField(title: "Kilo", value: $viewModel.weightKg, range: 30...300, unit: "kg")
                
                // Target weight (if losing weight)
                if viewModel.selectedGoals.contains(.loseWeight) {
                    doubleInputField(title: "Hedef Kilo", value: $viewModel.targetWeightKg, range: 30...300, unit: "kg")
                }
                
                // Gender
                VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
                    Text("Cinsiyet")
                        .font(NuvyraTypography.caption2)
                        .foregroundStyle(NuvyraColors.textSecondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: NuvyraSpacing.xs) {
                            ForEach(Gender.allCases) { gender in
                                NuvyraChip(gender.displayName, isSelected: viewModel.selectedGender == gender) {
                                    viewModel.selectedGender = gender
                                }
                            }
                        }
                    }
                }
                
                // Activity Level
                VStack(alignment: .leading, spacing: NuvyraSpacing.sm) {
                    Text("Aktivite Seviyesi")
                        .font(NuvyraTypography.caption2)
                        .foregroundStyle(NuvyraColors.textSecondary)
                    
                    ForEach(ActivityLevel.allCases) { level in
                        activityRow(level)
                    }
                }
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .padding(.top, NuvyraSpacing.xl)
            .padding(.bottom, NuvyraSpacing.huge)
        }
    }
    
    private func inputField(title: String, value: Binding<Int>, range: ClosedRange<Int>, unit: String) -> some View {
        VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
            Text(title)
                .font(NuvyraTypography.caption2)
                .foregroundStyle(NuvyraColors.textSecondary)
            
            HStack {
                Stepper("", value: value, in: range)
                    .labelsHidden()
                
                Text("\(value.wrappedValue)")
                    .font(NuvyraTypography.metricCard)
                    .foregroundStyle(NuvyraColors.textPrimary)
                    .contentTransition(.numericText())
                
                Text(unit)
                    .font(NuvyraTypography.caption)
                    .foregroundStyle(NuvyraColors.textSecondary)
                
                Spacer()
            }
            .padding(NuvyraSpacing.sm)
            .background(NuvyraColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
        }
    }
    
    private func doubleInputField(title: String, value: Binding<Double>, range: ClosedRange<Double>, unit: String) -> some View {
        let intBinding = Binding<Int>(
            get: { Int(value.wrappedValue) },
            set: { value.wrappedValue = Double($0) }
        )
        return inputField(title: title, value: intBinding, range: Int(range.lowerBound)...Int(range.upperBound), unit: unit)
    }
    
    private func activityRow(_ level: ActivityLevel) -> some View {
        Button {
            NuvyraHaptics.selection()
            viewModel.activityLevel = level
        } label: {
            HStack(spacing: NuvyraSpacing.sm) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(level.displayName)
                        .font(NuvyraTypography.bodyBold)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    Text(level.description)
                        .font(NuvyraTypography.caption)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
                Spacer()
                Image(systemName: viewModel.activityLevel == level ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(viewModel.activityLevel == level ? NuvyraColors.primaryAdaptive : NuvyraColors.textTertiary.opacity(0.4))
                    .font(.system(size: 22))
            }
            .padding(NuvyraSpacing.sm)
            .background(NuvyraColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
            .overlay {
                if viewModel.activityLevel == level {
                    RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous)
                        .stroke(NuvyraColors.primaryAdaptive.opacity(0.3), lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
