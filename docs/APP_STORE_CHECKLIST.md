# Nuvyra — App Store Submission Checklist

## App Bilgileri

| Alan | Değer |
|------|-------|
| App Name | Nuvyra |
| Subtitle | Kalori ve Yürüyüş Koçu |
| Bundle ID | com.nuvyra.app |
| Category | Health & Fitness |
| Age Rating | 4+ |
| Minimum iOS | 17.0 |
| Supported Devices | iPhone |

## App Store Metinleri

### App Adı
**Nuvyra: Kalori ve Yürüyüş Koçu**

### Alt Başlık
Fotoğrafla öğün kaydet, adımlarını senkronize et

### Promosyon Metni (170 karakter)
Türkçe beslenme takibi, akıllı yürüyüş hedefleri ve haftalık koç özetleriyle sürdürülebilir sağlık ritmi kur.

### Açıklama
Nuvyra, katı diyet listeleri yerine günlük ritim kurmana yardımcı olur.

🍽️ **Beslenme Takibi**
- Öğününü fotoğrafla veya elle kaydet
- Türk mutfağına özel hızlı yemek seçenekleri
- Kalori, protein, karbonhidrat ve yağ takibi
- Tahmini değerler, her zaman düzenlenebilir

👟 **Yürüyüş Koçluğu**
- Apple Sağlık'tan otomatik adım senkronizasyonu
- Kişiselleştirilmiş günlük adım hedefi
- Adaptif hedef: tempona göre ayarlanır
- Mini yürüyüş görevleri ve motivasyon

💧 **Su Takibi**
- Günlük su hedefi
- Tek dokunuşla su ekleme
- Hatırlatmalar

📊 **Haftalık Koç Özeti (Premium)**
- Ortalama kalori ve adım analizi
- En iyi ve zorlanılan günler
- Kişisel öneriler

Nuvyra tıbbi tavsiye vermez. Wellness ve fitness koçluk uygulamasıdır.

### Anahtar Kelimeler
kalori sayacı,beslenme takibi,diyet,kilo verme,adım sayar,yürüyüş,makro,su takibi,HealthKit,Türk yemekleri

## Ekran Görüntüsü Planı (6.7" ve 6.5")

1. **Öğününü saniyeler içinde kaydet** — Meal logging ekranı, Türk yemeği chip'leri
2. **Adımların Apple Sağlık'tan otomatik gelsin** — Dashboard adım kartı
3. **Bugün için gerçekçi kalori ve adım hedefi** — Dashboard kalori ring
4. **Mini yürüyüş planları** — Walking ekranı motivasyon kartı
5. **Haftalık koç özetin hazır** — Weekly summary ekranı
6. **Premium deneyim** — Paywall ekranı

## App Review Gereksinimleri

### HealthKit
- [x] NSHealthShareUsageDescription yazıldı
- [x] NSHealthUpdateUsageDescription yazıldı
- [x] Yalnızca gereken veri türleri isteniyor (stepCount, distanceWalkingRunning, activeEnergyBurned)
- [x] İzin reddedilirse uygulama çalışmaya devam ediyor
- [x] HealthKit verisi reklam amacıyla kullanılmıyor

### Kamera / Fotoğraf
- [x] NSCameraUsageDescription yazıldı
- [x] NSPhotoLibraryUsageDescription yazıldı

### In-App Purchase
- [x] StoreKit 2 kullanılıyor
- [x] Restore Purchases butonu var
- [x] Fiyatlar net gösteriliyor
- [x] İptal bilgisi paywall'da yer alıyor
- [x] Terms ve Privacy linkleri var

### Gizlilik
- [x] PrivacyInfo.xcprivacy oluşturuldu
- [x] NSPrivacyTracking: false
- [x] Reklam SDK'sı yok
- [x] AppTrackingTransparency kullanılmıyor

### Medikal İddia
- [x] Uygulama tıbbi tavsiye vermiyor
- [x] "Wellness ve fitness koçluk uygulamasıdır" uyarısı var
- [x] Profesyonel destek yönlendirmesi var

## Gerekli URL'ler

| URL | Durum |
|-----|-------|
| Privacy Policy | TODO: nuvyra.com/privacy |
| Terms of Use | TODO: nuvyra.com/terms |
| Support URL | TODO: nuvyra.com/support |
| KVKK Aydınlatma | TODO: nuvyra.com/kvkk |

## Pre-Submission Checklist

- [ ] Demo hesap oluştur (App Review ekibi için)
- [ ] Ekran görüntüleri hazırla (6.7" iPhone 16 Pro Max, 6.5" iPhone 11 Pro Max)
- [ ] App Preview videosu (opsiyonel)
- [ ] Privacy Policy URL aktif
- [ ] Support URL aktif
- [ ] StoreKit ürünleri App Store Connect'te tanımlandı
- [ ] TestFlight build başarılı
- [ ] Codemagic pipeline çalışıyor
- [ ] Son test: onboarding → meal log → step sync → paywall
