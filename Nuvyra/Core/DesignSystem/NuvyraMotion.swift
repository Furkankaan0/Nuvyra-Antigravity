import SwiftUI

/// Nuvyra animasyon ve hareket sistemi.
/// Reduced Motion desteği ile yumuşak, premium animasyonlar.
enum NuvyraMotion {
    
    // MARK: - Spring Animations
    
    /// Standart spring — kart açılma, sayfa geçişi
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.1)
    
    /// Hızlı spring — buton tap, chip seçimi
    static let springQuick = Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
    
    /// Yavaş spring — onboarding geçişi, modal açılma
    static let springSlow = Animation.spring(response: 0.7, dampingFraction: 0.85, blendDuration: 0.1)
    
    /// Bouncy spring — başarı animasyonu, streak
    static let springBouncy = Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
    
    // MARK: - Ease Animations
    
    /// Standart ease — genel geçişler
    static let ease = Animation.easeInOut(duration: 0.3)
    
    /// Yavaş ease — progress ring dolma
    static let easeSlow = Animation.easeInOut(duration: 0.8)
    
    /// Çok yavaş ease — büyük progress animasyonları
    static let easeVerySlow = Animation.easeInOut(duration: 1.2)
    
    // MARK: - Transitions
    
    /// Standart sayfa geçişi
    static let pageTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )
    
    /// Kart belirme
    static let cardAppear: AnyTransition = .scale(scale: 0.95).combined(with: .opacity)
    
    /// Yukarıdan aşağıya belirme
    static let slideUp: AnyTransition = .move(edge: .bottom).combined(with: .opacity)
    
    /// Fade geçişi
    static let fade: AnyTransition = .opacity
}

// MARK: - Reduced Motion Support

struct MotionSafeModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let animation: Animation
    let reducedAnimation: Animation
    
    func body(content: Content) -> some View {
        content.animation(reduceMotion ? reducedAnimation : animation)
    }
}

extension View {
    /// Reduced Motion tercihine duyarlı animasyon uygular.
    /// Kullanıcı reduced motion açtıysa, basit fade/ease kullanılır.
    func motionSafe(
        _ animation: Animation = NuvyraMotion.spring,
        reduced: Animation = .easeInOut(duration: 0.15)
    ) -> some View {
        modifier(MotionSafeModifier(animation: animation, reducedAnimation: reduced))
    }
    
    /// Conditional animation with reduce motion support
    func nuvyraAnimation<V: Equatable>(
        _ animation: Animation = NuvyraMotion.spring,
        value: V
    ) -> some View {
        self.modifier(NuvyraAnimationModifier(animation: animation, value: value))
    }
}

private struct NuvyraAnimationModifier<V: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let animation: Animation
    let value: V
    
    func body(content: Content) -> some View {
        content.animation(
            reduceMotion ? .easeInOut(duration: 0.15) : animation,
            value: value
        )
    }
}
