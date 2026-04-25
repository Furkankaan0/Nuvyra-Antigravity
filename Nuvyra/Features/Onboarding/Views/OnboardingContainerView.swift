import SwiftUI
import SwiftData

/// Onboarding ana container — sayfa bazlı geçiş ve ilerleme göstergesi
struct OnboardingContainerView: View {
    
    @State private var viewModel = OnboardingViewModel()
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            NuvyraColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                if viewModel.currentStep != .welcome {
                    progressBar
                        .padding(.horizontal, NuvyraSpacing.pageHorizontal)
                        .padding(.top, NuvyraSpacing.sm)
                }
                
                // Content
                TabView(selection: Binding(
                    get: { viewModel.currentStep },
                    set: { viewModel.currentStep = $0 }
                )) {
                    WelcomeView(onContinue: { viewModel.goToNextStep() })
                        .tag(OnboardingStep.welcome)
                    
                    GoalSelectionView(selectedGoals: $viewModel.selectedGoals)
                        .tag(OnboardingStep.goalSelection)
                    
                    ProfileInputView(viewModel: viewModel)
                        .tag(OnboardingStep.profileInput)
                    
                    DailyRoutineView(viewModel: viewModel)
                        .tag(OnboardingStep.dailyRoutine)
                    
                    FirstValueView(viewModel: viewModel)
                        .tag(OnboardingStep.firstValue)
                    
                    HealthKitPermissionView()
                        .tag(OnboardingStep.healthKitPermission)
                    
                    NotificationPermissionView()
                        .tag(OnboardingStep.notificationPermission)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(NuvyraMotion.spring, value: viewModel.currentStep)
                
                // Bottom buttons
                if viewModel.currentStep != .welcome {
                    bottomButtons
                        .padding(.horizontal, NuvyraSpacing.pageHorizontal)
                        .padding(.bottom, NuvyraSpacing.lg)
                }
            }
        }
    }
    
    // MARK: - Progress Bar
    
    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(NuvyraColors.textTertiary.opacity(0.15))
                    .frame(height: 4)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(NuvyraColors.primaryAdaptive)
                    .frame(width: geo.size.width * viewModel.progress, height: 4)
                    .animation(NuvyraMotion.easeSlow, value: viewModel.progress)
            }
        }
        .frame(height: 4)
    }
    
    // MARK: - Bottom Buttons
    
    private var bottomButtons: some View {
        VStack(spacing: NuvyraSpacing.sm) {
            if viewModel.currentStep == .notificationPermission {
                NuvyraPrimaryButton("Nuvyra'ya Başla", icon: "checkmark") {
                    completeOnboarding()
                }
            } else {
                NuvyraPrimaryButton("Devam Et", icon: "arrow.right") {
                    viewModel.goToNextStep()
                }
                .disabled(!viewModel.canProceed)
                .opacity(viewModel.canProceed ? 1 : 0.5)
            }
            
            if viewModel.currentStep == .healthKitPermission || viewModel.currentStep == .notificationPermission {
                Button("Şimdilik Atla") {
                    if viewModel.currentStep == .notificationPermission {
                        completeOnboarding()
                    } else {
                        viewModel.goToNextStep()
                    }
                }
                .font(NuvyraTypography.buttonSmall)
                .foregroundStyle(NuvyraColors.textSecondary)
            }
        }
    }
    
    private func completeOnboarding() {
        let profile = viewModel.createProfile()
        modelContext.insert(profile)
        try? modelContext.save()
        
        withAnimation(NuvyraMotion.springSlow) {
            appState.completeOnboarding()
        }
    }
}
