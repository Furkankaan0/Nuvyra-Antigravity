import SwiftUI

/// Nuvyra spacing sistemi — 4pt grid tabanlı tutarlı boşluklar.
enum NuvyraSpacing {
    
    // MARK: - Base Grid (4pt)
    
    /// 4pt — minimum boşluk
    static let xxxs: CGFloat = 4
    
    /// 6pt
    static let xxs: CGFloat = 6
    
    /// 8pt — chip padding, ikon boşluğu
    static let xs: CGFloat = 8
    
    /// 12pt — kart iç kenar, eleman arası
    static let sm: CGFloat = 12
    
    /// 16pt — standart padding
    static let md: CGFloat = 16
    
    /// 20pt — bölüm arası
    static let lg: CGFloat = 20
    
    /// 24pt — kart padding
    static let xl: CGFloat = 24
    
    /// 32pt — bölüm başlıkları arası
    static let xxl: CGFloat = 32
    
    /// 40pt — sayfa üst boşluğu
    static let xxxl: CGFloat = 40
    
    /// 48pt — büyük bölüm boşluğu
    static let huge: CGFloat = 48
    
    // MARK: - Semantic
    
    /// Kart iç padding'i
    static let cardPadding: CGFloat = 20
    
    /// Kart köşe yuvarlaklığı
    static let cardRadius: CGFloat = 24
    
    /// Küçük kart köşe yuvarlaklığı
    static let cardRadiusSmall: CGFloat = 16
    
    /// Buton köşe yuvarlaklığı
    static let buttonRadius: CGFloat = 16
    
    /// Chip köşe yuvarlaklığı
    static let chipRadius: CGFloat = 12
    
    /// Sayfa kenar boşluğu
    static let pageHorizontal: CGFloat = 20
    
    /// Kart arası dikey boşluk
    static let cardGap: CGFloat = 16
    
    /// Liste elemanları arası
    static let listItemGap: CGFloat = 12
    
    // MARK: - Specific
    
    /// Progress ring çizgi kalınlığı
    static let progressRingLineWidth: CGFloat = 12
    
    /// Progress ring büyük çizgi kalınlığı
    static let progressRingLineWidthLarge: CGFloat = 16
    
    /// Tab bar yüksekliği
    static let tabBarHeight: CGFloat = 49
    
    /// Bottom safe area ek boşluk
    static let bottomSafeAreaPadding: CGFloat = 20
}
