import SwiftUI

/// Hedef seçimi — çoklu seçim destekli chip'ler
struct GoalSelectionView: View {
    
    @Binding var selectedGoals: Set<HealthGoal>
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: NuvyraSpacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
                    Text("Hedeflerin neler?")
                        .font(NuvyraTypography.onboardingTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    
                    Text("Birden fazla seçebilirsin. Nuvyra sana özel bir plan oluşturacak.")
                        .font(NuvyraTypography.onboardingSubtitle)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
                
                // Goals
                VStack(spacing: NuvyraSpacing.sm) {
                    ForEach(HealthGoal.allCases) { goal in
                        goalRow(goal)
                    }
                }
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .padding(.top, NuvyraSpacing.xl)
        }
    }
    
    private func goalRow(_ goal: HealthGoal) -> some View {
        Button {
            NuvyraHaptics.selection()
            if selectedGoals.contains(goal) {
                selectedGoals.remove(goal)
            } else {
                selectedGoals.insert(goal)
            }
        } label: {
            HStack(spacing: NuvyraSpacing.md) {
                ZStack {
                    Circle()
                        .fill(selectedGoals.contains(goal)
                              ? NuvyraColors.primaryAdaptive.opacity(0.15)
                              : NuvyraColors.textTertiary.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: goal.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(selectedGoals.contains(goal)
                                         ? NuvyraColors.primaryAdaptive
                                         : NuvyraColors.textSecondary)
                }
                
                Text(goal.displayName)
                    .font(NuvyraTypography.bodyBold)
                    .foregroundStyle(NuvyraColors.textPrimary)
                
                Spacer()
                
                Image(systemName: selectedGoals.contains(goal) ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundStyle(selectedGoals.contains(goal)
                                     ? NuvyraColors.primaryAdaptive
                                     : NuvyraColors.textTertiary.opacity(0.4))
            }
            .padding(NuvyraSpacing.md)
            .background(NuvyraColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.cardRadiusSmall, style: .continuous))
            .overlay {
                if selectedGoals.contains(goal) {
                    RoundedRectangle(cornerRadius: NuvyraSpacing.cardRadiusSmall, style: .continuous)
                        .stroke(NuvyraColors.primaryAdaptive.opacity(0.4), lineWidth: 1.5)
                }
            }
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
        .animation(NuvyraMotion.springQuick, value: selectedGoals.contains(goal))
    }
}

#Preview {
    GoalSelectionView(selectedGoals: .constant([.loseWeight, .walkMore]))
        .background(NuvyraColors.background)
}
