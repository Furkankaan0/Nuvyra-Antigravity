import SwiftUI

/// Günlük rutin tercihleri — öğün sayısı, zorlandığı zaman, yürüyüş zamanı
struct DailyRoutineView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: NuvyraSpacing.xl) {
                VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
                    Text("Günlük rutinin")
                        .font(NuvyraTypography.onboardingTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    Text("Sana uygun öneriler için birkaç alışkanlığını öğrenelim.")
                        .font(NuvyraTypography.onboardingSubtitle)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
                
                // Meal count
                VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
                    Text("Genelde kaç öğün yersin?")
                        .font(NuvyraTypography.cardTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    
                    HStack(spacing: NuvyraSpacing.xs) {
                        ForEach(2...5, id: \.self) { count in
                            NuvyraChip("\(count) öğün", isSelected: viewModel.mealCount == count) {
                                viewModel.mealCount = count
                            }
                        }
                    }
                }
                
                // Difficult time
                VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
                    Text("En zorlandığın zaman dilimi?")
                        .font(NuvyraTypography.cardTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: NuvyraSpacing.xs) {
                            ForEach(DayPeriod.allCases) { period in
                                NuvyraChip(period.displayName, isSelected: viewModel.difficultTime == period) {
                                    viewModel.difficultTime = period
                                }
                            }
                        }
                    }
                }
                
                // Walk time
                VStack(alignment: .leading, spacing: NuvyraSpacing.xs) {
                    Text("Yürüyüş için en uygun zaman?")
                        .font(NuvyraTypography.cardTitle)
                        .foregroundStyle(NuvyraColors.textPrimary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: NuvyraSpacing.xs) {
                            ForEach(DayPeriod.allCases) { period in
                                NuvyraChip(period.displayName, isSelected: viewModel.preferredWalkTime == period) {
                                    viewModel.preferredWalkTime = period
                                }
                            }
                        }
                    }
                }
                
                // Reminders
                Toggle(isOn: $viewModel.wantsReminders) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hatırlatmalar")
                            .font(NuvyraTypography.bodyBold)
                            .foregroundStyle(NuvyraColors.textPrimary)
                        Text("Öğün ve yürüyüş zamanlarını hatırlat")
                            .font(NuvyraTypography.caption)
                            .foregroundStyle(NuvyraColors.textSecondary)
                    }
                }
                .tint(NuvyraColors.primaryAdaptive)
                .padding(NuvyraSpacing.md)
                .background(NuvyraColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .padding(.top, NuvyraSpacing.xl)
            .padding(.bottom, NuvyraSpacing.huge)
        }
    }
}
