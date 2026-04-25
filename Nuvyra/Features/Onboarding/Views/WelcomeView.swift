import SwiftUI

/// İlk karşılama ekranı — premium, sakin, ilham veren
struct WelcomeView: View {
    
    let onContinue: () -> Void
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Logo / İllüstrasyon alanı
            ZStack {
                Circle()
                    .fill(NuvyraColors.primaryAdaptive.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isVisible ? 1.0 : 0.8)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(NuvyraColors.primaryAdaptive)
                    .scaleEffect(isVisible ? 1.0 : 0.5)
            }
            .padding(.bottom, NuvyraSpacing.xxl)
            
            // Başlık
            Text("Katı diyet değil,\nsürdürülebilir ritim.")
                .font(NuvyraTypography.onboardingTitle)
                .foregroundStyle(NuvyraColors.textPrimary)
                .multilineTextAlignment(.center)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .padding(.bottom, NuvyraSpacing.md)
            
            // Alt metin
            Text("Nuvyra öğünlerini, adımlarını ve günlük\nhedeflerini tek bir sade akışta toplar.")
                .font(NuvyraTypography.onboardingSubtitle)
                .foregroundStyle(NuvyraColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 15)
            
            Spacer()
            
            // CTA Butonu
            NuvyraPrimaryButton("Başlayalım", icon: "arrow.right") {
                onContinue()
            }
            .padding(.horizontal, NuvyraSpacing.pageHorizontal)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 30)
            
            // Alt bilgi
            Text("Nuvyra tıbbi tavsiye vermez.\nWellness ve fitness koçluk uygulamasıdır.")
                .font(NuvyraTypography.caption)
                .foregroundStyle(NuvyraColors.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.top, NuvyraSpacing.md)
                .padding(.bottom, NuvyraSpacing.lg)
        }
        .padding(.horizontal, NuvyraSpacing.pageHorizontal)
        .onAppear {
            withAnimation(NuvyraMotion.springSlow.delay(0.2)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    WelcomeView(onContinue: {})
        .background(NuvyraColors.background)
}
