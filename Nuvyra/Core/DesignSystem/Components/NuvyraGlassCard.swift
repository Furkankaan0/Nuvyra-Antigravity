import SwiftUI

/// Cam efektli (glassmorphism) kart container.
/// Hafif blur, yarı-şeffaf arka plan, premium his.
struct NuvyraGlassCard<Content: View>: View {
    
    let cornerRadius: CGFloat
    @ViewBuilder let content: () -> Content
    
    init(
        cornerRadius: CGFloat = NuvyraSpacing.cardRadius,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(NuvyraSpacing.cardPadding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(NuvyraColors.glassGradient)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

#Preview("Glass Card") {
    ZStack {
        NuvyraColors.background.ignoresSafeArea()
        
        VStack(spacing: 16) {
            NuvyraGlassCard {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bugün için önerim")
                            .font(NuvyraTypography.cardTitle)
                            .foregroundStyle(NuvyraColors.textPrimary)
                        
                        Text("Akşam yemeğinden sonra 12 dakikalık hafif yürüyüş bugünkü hedefi tamamlamana yeter.")
                            .font(NuvyraTypography.callout)
                            .foregroundStyle(NuvyraColors.textSecondary)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
}
