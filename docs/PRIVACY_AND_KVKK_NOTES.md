# Nuvyra — Gizlilik, KVKK ve Veri Yönetimi

## Uygulamanın Niteliği

Nuvyra bir **wellness/fitness koçluk** uygulamasıdır.
- Tıbbi teşhis veya tedavi önerisi **vermez**.
- Kalori ve besin değerleri **tahminidir**.
- Kullanıcıya profesyonel sağlık desteği alması önerilir.

## Veri Minimizasyonu Prensibi

| Veri Türü | Toplanıyor mu? | Amaç | 3. Tarafla Paylaşılıyor mu? |
|-----------|---------------|------|----------------------------|
| Yaş, boy, kilo | ✅ | Kalori/adım hedefi hesaplama | ❌ |
| Cinsiyet | ✅ (opsiyonel) | BMR hesaplama | ❌ |
| Adım sayısı | ✅ (HealthKit) | Yürüyüş koçluğu | ❌ |
| Öğün verileri | ✅ (lokal) | Beslenme takibi | ❌ |
| Öğün fotoğrafları | ✅ (lokal) | Besin tahmini | ❌ |
| Konum | ❌ (ileride GPS yürüyüş) | — | — |
| Reklam kimliği | ❌ | — | — |

## HealthKit Kullanımı

### İstenen Veri Türleri
- `HKQuantityType.stepCount` — Günlük adım sayısı
- `HKQuantityType.distanceWalkingRunning` — Yürüyüş mesafesi
- `HKQuantityType.activeEnergyBurned` — Aktif enerji

### Kurallar
1. **Yalnızca okuma** izni istenir (yazma izni ileride)
2. HealthKit verisi **hiçbir şekilde reklam SDK'sına gönderilmez**
3. İzin reddedilirse uygulama çalışmaya devam eder
4. Kullanıcı istediği zaman izni geri alabilir

## KVKK Uyumu

### Veri Sorumlusu
[Şirket adı ve iletişim bilgileri eklenecek]

### İşlenen Kişisel Veriler
- Fiziksel ölçüler (boy, kilo, yaş)
- Sağlık/fitness verileri (adım, kalori)
- Beslenme verileri (öğün kayıtları)
- Fotoğraflar (öğün fotoğrafları, yalnızca cihazda)

### İşleme Amaçları
- Kişiselleştirilmiş kalori/adım hedefi hesaplama
- Beslenme takibi
- Yürüyüş koçluğu
- Haftalık özet üretimi

### Hukuki Dayanak
- **Açık rıza**: Sağlık verileri için kullanıcıdan açık rıza alınır
- **Sözleşme ifası**: Uygulama işlevselliği için gereken veriler

### Kullanıcı Hakları
- Verilerine erişim hakkı
- Verilerin düzeltilmesini isteme hakkı
- Verilerin silinmesini isteme hakkı
- İşlemenin kısıtlanmasını isteme hakkı
- Veri taşınabilirliği hakkı
- İtiraz hakkı

### Veri Saklama
- Tüm veriler **cihaz üzerinde** (local-first) saklanır
- Cloud senkronizasyonu MVP'de yoktur
- Kullanıcı uygulamayı sildiğinde tüm veriler silinir
- Uygulama içi "Verilerimi Sil" seçeneği mevcuttur

## Apple Privacy Manifest

PrivacyInfo.xcprivacy dosyası:
- `NSPrivacyTracking`: **false**
- `NSPrivacyTrackingDomains`: boş (hiçbir tracking domain'i yok)
- Kullanılan API'ler: UserDefaults (CA92.1), FileTimestamp (C617.1)
- Toplanan veri: Health & Fitness, Photos — yalnızca uygulama işlevselliği için

## Üçüncü Taraf SDK'lar

| SDK | Kullanılıyor mu? | Not |
|-----|-----------------|-----|
| Firebase Analytics | ❌ | Privacy-first analytics tercih edildi |
| AdMob | ❌ | Reklam yok |
| Facebook SDK | ❌ | Takip yok |
| Adjust/AppsFlyer | ❌ | Attribution tracking yok |
| StoreKit 2 | ✅ | Apple native, 1. taraf |
| HealthKit | ✅ | Apple native, 1. taraf |

## App Review İçin Notlar

1. HealthKit kullanım açıklamaları Info.plist'te Türkçe yazıldı
2. Uygulama demo veriyle çalışabilir (onboarding sonrası mock data)
3. Medikal iddia yapılmıyor — "tahmini değer" etiketleri kullanılıyor
4. Paywall şeffaf — fiyat, deneme süresi ve iptal yöntemi net
5. ATT (AppTrackingTransparency) kullanılmıyor
