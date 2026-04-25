import SwiftUI
import UIKit

/// Nuvyra haptic feedback yöneticisi.
/// Premium hissiyat için yerinde kullanılan dokunsal geri bildirimler.
enum NuvyraHaptics {
    
    // MARK: - Impact
    
    /// Hafif dokunuş — chip seçimi, toggle
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    /// Orta dokunuş — buton tap, kart seçimi
    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    /// Güçlü dokunuş — önemli aksiyon, yürüyüş tamamlama
    static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    /// Yumuşak dokunuş — su ekleme, küçük görev tamamlama
    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    /// Sert dokunuş — hata, uyarı
    static func rigid() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
    // MARK: - Notification
    
    /// Başarı — hedef tamamlama, streak kazanma
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    /// Uyarı — kalori aşımı yaklaşma
    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    /// Hata — işlem başarısız
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    // MARK: - Selection
    
    /// Seçim değişikliği — picker, segmented control
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
