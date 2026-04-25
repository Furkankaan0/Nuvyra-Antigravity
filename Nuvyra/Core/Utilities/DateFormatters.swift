import Foundation

/// Tarih formatlama yardımcıları — Türkçe lokale ayarlanmış
enum NuvyraDateFormatters {
    
    private static let turkishLocale = Locale(identifier: "tr_TR")
    
    /// "25 Nisan 2026, Cumartesi"
    static let fullDate: DateFormatter = {
        let f = DateFormatter()
        f.locale = turkishLocale
        f.dateFormat = "d MMMM yyyy, EEEE"
        return f
    }()
    
    /// "25 Nisan"
    static let dayMonth: DateFormatter = {
        let f = DateFormatter()
        f.locale = turkishLocale
        f.dateFormat = "d MMMM"
        return f
    }()
    
    /// "14:30"
    static let time: DateFormatter = {
        let f = DateFormatter()
        f.locale = turkishLocale
        f.dateFormat = "HH:mm"
        return f
    }()
    
    /// "Pzt", "Sal" gibi kısa gün adı
    static let shortWeekday: DateFormatter = {
        let f = DateFormatter()
        f.locale = turkishLocale
        f.dateFormat = "EEE"
        return f
    }()
    
    /// Zaman bazlı selamlama
    static func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Günaydın"
        case 12..<18: return "İyi günler"
        case 18..<22: return "İyi akşamlar"
        default: return "İyi geceler"
        }
    }
    
    /// Bugünün tarih metni
    static func todayString() -> String {
        fullDate.string(from: Date())
    }
    
    /// Başlangıç tarihi
    static func startOfDay(_ date: Date = Date()) -> Date {
        Calendar.current.startOfDay(for: date)
    }
    
    /// Haftanın başlangıcı
    static func startOfWeek(_ date: Date = Date()) -> Date {
        var calendar = Calendar.current
        calendar.locale = turkishLocale
        calendar.firstWeekday = 2 // Pazartesi
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? date
    }
}
