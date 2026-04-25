import Foundation
import UserNotifications

/// Bildirim zamanlayıcı — öğün, su, yürüyüş, haftalık özet hatırlatmaları.
/// Satış odaklı değil, ritim odaklı bildirimler.
final class NotificationScheduler {
    
    private let center = UNUserNotificationCenter.current()
    
    // MARK: - Permission
    
    func requestPermission() async throws -> Bool {
        let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
        return granted
    }
    
    func getPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Schedule
    
    /// Öğün hatırlatma
    func scheduleMealReminder(mealType: MealType, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Öğün Zamanı 🍽️"
        content.body = "\(mealType.displayName) saati geldi. Bugün ne yedin?"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "meal_reminder_\(mealType.rawValue)",
            content: content, trigger: trigger
        )
        
        center.add(request)
    }
    
    /// Su hatırlatma
    func scheduleWaterReminder(intervalHours: Int = 2) {
        let content = UNMutableNotificationContent()
        content.title = "Su İç 💧"
        content.body = "Bir bardak su seni tazeleyebilir."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(intervalHours * 3600), repeats: true
        )
        let request = UNNotificationRequest(
            identifier: "water_reminder", content: content, trigger: trigger
        )
        
        center.add(request)
    }
    
    /// Yürüyüş hatırlatma
    func scheduleWalkReminder(remainingSteps: Int, hour: Int = 18) {
        let minutes = max(1, remainingSteps / 100)
        let content = UNMutableNotificationContent()
        content.title = "Yürüyüş Zamanı 🚶"
        content.body = "Bugünkü hedefe \(remainingSteps) adım kaldı. \(minutes) dakikalık kısa bir yürüyüş yeterli olabilir."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: "walk_reminder_\(Date().timeIntervalSince1970)",
            content: content, trigger: trigger
        )
        
        center.add(request)
    }
    
    /// Tüm zamanlanmış bildirimleri kaldır
    func removeAllScheduled() {
        center.removeAllPendingNotificationRequests()
    }
}
