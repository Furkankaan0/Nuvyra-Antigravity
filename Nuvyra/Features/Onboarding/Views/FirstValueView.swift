import SwiftUI

/// İlk değer anı — hesaplanan kalori ve adım hedefini gösterir
struct FirstValueView: View {
    
    let viewModel: OnboardingViewModel
    @State private var isVisible = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: NuvyraSpacing.xxl) {
                VStack(spacing: NuvyraSpacing.sm) {
                    Text("Senin için hesapladık ✨")
                        .font(NuvyraTypography.onboardingTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    Text("Bu hedefler başlangıç için. İstediğin zaman ayarlayabilirsin.")
                        .font(NuvyraTypography.onboardingSubtitle)
                        .foregroundStyle(NuvyraColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(isVisible ? 1 : 0)
                
                // Calorie target
                NuvyraGlassCard {
                    VStack(spacing: NuvyraSpacing.sm) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.orange)
                        
                        Text("Günlük Kalori Hedefi")
                            .font(NuvyraTypography.caption2)
                            .foregroundStyle(NuvyraColors.textSecondary)
                        
                        Text("\(viewModel.calorieRange.min) — \(viewModel.calorieRange.max)")
                            .font(NuvyraTypography.metricMedium)
                            .foregroundStyle(NuvyraColors.textPrimary)
                        
                        Text("kcal / gün")
                            .font(NuvyraTypography.caption)
                            .foregroundStyle(NuvyraColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .scaleEffect(isVisible ? 1 : 0.9)
                .opacity(isVisible ? 1 : 0)
                
                // Step target
                NuvyraGlassCard {
                    VStack(spacing: NuvyraSpacing.sm) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 28))
                            .foregroundStyle(NuvyraColors.primaryAdaptive)
                        
                        Text("Günlük Adım Hedefi")
                            .font(NuvyraTypography.caption2)
                            .foregroundStyle(NuvyraColors.textSecondary)
                        
                        Text("\(viewModel.suggestedStepGoal.formatted())")
                            .font(NuvyraTypography.metricMedium)
                            .foregroundStyle(NuvyraColors.textPrimary)
                        
                        Text("adım / gün")
                            .font(NuvyraTypography.caption)
                            .foregroundStyle(NuvyraColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .scaleEffect(isVisible ? 1 : 0.9)
                .opacity(isVisible ? 1 : 0)
                
                // Motivational copy
                Text("Bugün için hedefin 10.000 adım olmak zorunda değil.\nBaşlangıç için \(viewModel.suggestedStepGoal.formatted()) adım yeterli.")
                    .font(NuvyraTypography.callout)
                    .foregroundStyle(NuvyraColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, NuvyraSpacing.md)
                    .opacity(isVisible ? 1 : 0)
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .padding(.top, NuvyraSpacing.xl)
            .padding(.bottom, NuvyraSpacing.huge)
        }
        .onAppear {
            withAnimation(NuvyraMotion.springSlow.delay(0.3)) {
                isVisible = true
            }
        }
    }
}
