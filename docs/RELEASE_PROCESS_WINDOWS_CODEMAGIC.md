# Nuvyra — Windows'tan Release Süreci (Codemagic)

## Genel Bakış

Windows ortamında Xcode/iOS Simulator çalışmadığı için tüm iOS build, signing, TestFlight ve release süreçleri **Codemagic** üzerinden yapılır.

## Gerekli Hesaplar

| Hesap | Amaç | URL |
|-------|------|-----|
| Apple Developer Program | iOS geliştirme, App Store | developer.apple.com |
| App Store Connect | Uygulama yönetimi, TestFlight | appstoreconnect.apple.com |
| Codemagic | CI/CD build | codemagic.io |
| GitHub | Kaynak kod yönetimi | github.com |

## Tek Seferlik Kurulum

### 1. Apple Developer Portal

1. **App ID** oluştur: `com.nuvyra.app`
2. **Capabilities** ekle: HealthKit, In-App Purchase
3. **API Key** oluştur (App Store Connect API):
   - Keys > Generate → `.p8` dosyasını indir
   - **Key ID** ve **Issuer ID** not al
   - ⚠️ `.p8` dosyasını sakla, tekrar indirilemez!

### 2. Codemagic Kurulumu

1. Codemagic'te **New Application** → GitHub repo bağla
2. **Settings > Environment variables** bölümünde grup oluştur:

   Grup adı: `app_store_credentials`
   
   | Variable | Değer |
   |----------|-------|
   | APP_STORE_CONNECT_ISSUER_ID | Apple'dan aldığın Issuer ID |
   | APP_STORE_CONNECT_KEY_IDENTIFIER | API Key ID |
   | APP_STORE_CONNECT_PRIVATE_KEY | `.p8` dosyasının içeriği |

3. **Codemagic Integrations** > App Store Connect integration aktifle

### 3. Codemagic Code Signing (Otomatik)

Codemagic `ios_signing` konfigürasyonuyla otomatik signing yapar:
- `codemagic.yaml` dosyasında `distribution_type: app_store` ayarlandı
- Codemagic kendi geçici sertifika ve profil oluşturur
- Manuel `.p12` / `.mobileprovision` yüklemeye **gerek yok**

## Günlük İş Akışı

### Kod Değişikliği → TestFlight

```
1. Windows'ta kodu düzenle (VS Code / herhangi bir editör)
2. Git commit & push to main
3. Codemagic otomatik olarak:
   a. XcodeGen ile .xcodeproj üret
   b. Swift packages çöz
   c. Unit testleri çalıştır
   d. Code signing yap
   e. IPA oluştur
   f. TestFlight'a yükle
4. TestFlight'ta "Internal Testers" grubuna dağıtılır
5. iPhone'da TestFlight uygulamasından test et
```

### Pull Request

```
1. Feature branch oluştur
2. Push to GitHub
3. PR aç (main'e)
4. Codemagic `ios-pr-check` workflow çalışır:
   - Build + Test (signing yok, TestFlight yok)
5. Testler geçerse merge et
```

### App Store Release

```
1. Release branch oluştur: release/1.0.0
2. Push to GitHub
3. Codemagic TestFlight build oluşturur
4. App Store Connect'te:
   a. TestFlight > Build seç
   b. External Testing grubu ekle (beta test)
   c. Hazır olunca: App Store > Version > Build seç
   d. Review'a gönder
5. Apple review sonucu bekle (genelde 24-48 saat)
```

## Sorun Giderme

### Build Başarısız Olursa

1. Codemagic dashboard'da build loglarını kontrol et
2. `xcodebuild_logs/*.log` artifact'larını indir
3. Yaygın hatalar:
   - **Signing hatası**: Codemagic integration'ı kontrol et
   - **Package resolve hatası**: SPM cache temizle
   - **XcodeGen hatası**: `project.yml` syntax kontrol et

### TestFlight'a Yükleme Başarısız Olursa

1. App Store Connect API key'in geçerli mi kontrol et
2. Bundle ID'nin App Store Connect'te kayıtlı olduğunu doğrula
3. Build number'ın öncekinden büyük olduğunu kontrol et (Codemagic otomatik yapar)

## Komut Referansı

Windows'tan yapılacak işlemler:

```bash
# Yeni feature
git checkout -b feature/meal-logging
# ... kod düzenle ...
git add -A
git commit -m "feat: add meal logging"
git push origin feature/meal-logging

# Main'e merge sonrası TestFlight otomatik tetiklenir
git checkout main
git pull
git merge feature/meal-logging
git push origin main

# Release
git checkout -b release/1.0.0
git push origin release/1.0.0
```
