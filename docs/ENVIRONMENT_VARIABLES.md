# Nuvyra — Environment Variables

## Codemagic Environment Variables

Aşağıdaki değişkenler Codemagic dashboard'da **Environment variables** bölümüne eklenmelidir.

### Grup: `app_store_credentials`

| Variable | Açıklama | Nasıl Alınır |
|----------|----------|-------------|
| `APP_STORE_CONNECT_ISSUER_ID` | App Store Connect API Issuer ID | App Store Connect > Users and Access > Keys |
| `APP_STORE_CONNECT_KEY_IDENTIFIER` | API Key ID | Aynı sayfada Key ID sütunu |
| `APP_STORE_CONNECT_PRIVATE_KEY` | `.p8` dosyasının tam içeriği | Key oluşturulduğunda indirilen dosya |

### Otomatik Değişkenler (Codemagic tarafından sağlanır)

| Variable | Açıklama |
|----------|----------|
| `CM_BUILD_DIR` | Repo kök dizini |
| `PROJECT_BUILD_NUMBER` | Otomatik artan build numarası |
| `CM_BRANCH` | Build edilen branch |
| `CM_COMMIT` | Commit hash |

### Proje Değişkenleri (codemagic.yaml'da tanımlı)

| Variable | Değer |
|----------|-------|
| `BUNDLE_ID` | `com.nuvyra.app` |
| `XCODE_SCHEME` | `Nuvyra` |
| `XCODE_PROJECT` | `Nuvyra.xcodeproj` |

## Güvenlik Notları

> ⚠️ **ASLA** şu dosyaları Git'e commitleme:
> - `.p8` dosyaları (App Store Connect API key)
> - `.p12` dosyaları (sertifikalar)
> - `.mobileprovision` dosyaları
> - `.env` dosyaları

Bu dosyalar `.gitignore`'a eklendi. Tüm hassas bilgiler Codemagic'in şifreli environment variable sistemi üzerinden yönetilir.

## Kurulum Adımları

1. Apple Developer Portal'da App Store Connect API Key oluştur
2. `.p8` dosyasını indir ve güvenli bir yerde sakla
3. Codemagic dashboard → Settings → Environment variables
4. `app_store_credentials` grubu oluştur
5. Üç değişkeni ekle (yukarıdaki tablo)
6. "Secure" olarak işaretle (loglardan gizlenir)
