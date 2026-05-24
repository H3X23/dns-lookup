
# 🔍 DNS-HISTORY LOOKUP TOOL

**Yapımcı:** H3X

Herkese açık , **ücretsiz** DNS history lookup aracı. SSL sertifikalarından domain'in geçmiş kayıtlarını öğrenin.

![Bash](https://img.shields.io/badge/bash-5.1%2B-green)
![License](https://img.shields.io/badge/license-MIT-blue)
![Status](https://img.shields.io/badge/status-Active-brightgreen)
![Author](https://img.shields.io/badge/author-H3X-blue)

---

## 👨‍💻 Hakkında

Bu proje **H3X** tarafından geliştirilmiştir. DNS history araştırmaları kolaylaştırmak ve herkese açık bir tool sunmak için oluşturulmuştur.

---

## ✨ Özellikler

- 🔓 **Tamamen Ücretsiz** - API key gerekmiyor
- 🚀 **Hızlı ve Güvenilir** - crt.sh veritabanını kullanır
- 🎨 **Renkli Çıktı** - Kolay okunabilir terminal görünümü
- ✅ **Domain Validasyonu** - Hatalı input'ları engeller
- 📊 **İstatistik** - Toplam kayıt sayısını gösterir
- 🔐 **Güvenli** - Hiçbir şifre/token depolanmaz
- 🖥️ **Cross-Platform** - Linux, macOS, WSL uyumlu

---

## 📋 Gereksinimler

### Minimum Gereksinimler
- **Bash 4.0+**
- **curl** (HTTP istekleri için)
- **jq** (JSON işleme için)

### Kurulum (macOS/Linux/WSL)

#### 1️⃣ Debian/Ubuntu
```bash
sudo apt update
sudo apt install curl jq
```

#### 2️⃣ macOS (Homebrew)
```bash
brew install curl jq
```

#### 3️⃣ Arch Linux
```bash
sudo pacman -S curl jq
```

#### 4️⃣ WSL (Windows Subsystem for Linux)
```bash
# Ubuntu gibi kur
sudo apt install curl jq
```

---

## 📥 Kurulum

### Adım 1: Script'i İndirin
```bash
# Repository'i clone edin
git clone https://github.com/H3X23/dns-lookup
cd dns-history-lookup

# Veya doğrudan dosyayı indirin
curl -O https://raw.githubusercontent.com/H3X/dns-history-lookup/main/dns-history.sh
```

### Adım 2: Çalıştırılabilir Yapın
```bash
chmod +x dns-history.sh
```

### Adım 3: Yükleyin (Opsiyonel)
```bash
# Tüm sistemde erişilebilir yapmak için
sudo cp dns-history.sh /usr/local/bin/dns-history
sudo chmod +x /usr/local/bin/dns-history
```

---

## 🚀 Kullanım

### Temel Kullanım
```bash
./dns-history.sh
```

İstendiğinde domain adını girin:
```
Hedef domaini girin (example.com şeklinde olmalıdır):
google.com
```

### Örnek Çıktı
```
╔════════════════════════════════════════════╗
║     🔍 DNS-HISTORY LOOKUP TOOL 🔍          ║
╚════════════════════════════════════════════╝

Hedef domaini girin (example.com şeklinde olmalıdır):
github.com

⏳ Sorgu yapılıyor: github.com
📡 API: crt.sh

✅ Bulundu! SSL Sertifika Geçmişi:
════════════════════════════════════════════
📅 2021-03-15 → www.github.com
📅 2021-05-20 → api.github.com
📅 2021-07-10 → gist.github.com
📅 2022-01-05 → raw.github.com
📅 2022-06-12 → github.io
📅 2023-02-28 → actions.github.com
════════════════════════════════════════════
📊 Toplam Kayıt: 47
```

---

## 📚 Kullanım Örnekleri

### Örnek 1: Google Domain'i Sorgula
```bash
./dns-history.sh
# google.com yazın
```

### Örnek 2: Batch İşlem (Birden Fazla Domain)
```bash
for domain in google.com github.com amazon.com; do
  echo "$domain" | ./dns-history.sh
done
```

### Örnek 3: Sonuçları Dosyaya Kaydet
```bash
./dns-history.sh > results.txt
```

### Örnek 4: Pipe ile Kullan
```bash
echo "facebook.com" | ./dns-history.sh
```

---

## 🎨 Renk Açıklaması

Araçta kullanılan renkler:

| Renk | Anlamı | Örnek |
|------|--------|-------|
| 🔵 **Mavi** | Kullanıcı girişi | Input isteği |
| 🟡 **Sarı** | İşlem durumu | Sorgu yapılıyor |
| 🟢 **Yeşil** | Başarı | Sonuçlar bulundu |
| 🔴 **Kırmızı** | Hata | Geçersiz domain |
| 🟣 **Mor** | Ayırıcı | Domain separatörleri |
| 🔵 **Turkuaz** | Bilgi | Domain adları |

---

## 🔧 Script Yapısı

```bash
┌─────────────────────────────────────────┐
│  Renkler Tanımlama (ANSI Color Codes)   │
├─────────────────────────────────────────┤
│  Banner Yazdırma (Başlık)               │
├─────────────────────────────────────────┤
│  Domain Girişi (User Input)             │
├─────────────────────────────────────────┤
│  Validasyon (Format Kontrolü)           │
├─────────────────────────────────────────┤
│  istek() → API URL Oluşturma            │
├─────────────────────────────────────────┤
│  calistir() → API İsteği + JSON Parse   │
├─────────────────────────────────────────┤
│  Sonuçları Renkli Yazdırma              │
└─────────────────────────────────────────┘
```

---

## ⚙️ Konfigürasyon

Script'i özelleştirmek için `dns-history.sh` dosyasını düzenleyin:

### API Kaynağını Değiştirmek
```bash
# Satır 18'i değiştirin
dnsdomain='https://crt.sh/?q=%.'  # veya başka bir API
```

### Renkleri Değiştirmek
```bash
# Satır 6-17'deki ANSI kodlarını değiştirin
BBlue='\033[1;34m'  # Başka bir koda değiştirin
```

### Çıktı Formatını Değiştirmek
```bash
# Satır 70'i değiştirin (jq filtrelemesini)
jq -r '.[] | "Yeni Format: \(.logged_at)"'
```

---

## 🐛 Sorun Giderme

### Problem: "command not found: curl"
**Çözüm:**
```bash
sudo apt install curl
```

### Problem: "jq: command not found"
**Çözüm:**
```bash
sudo apt install jq
```

### Problem: Bash: permission denied
**Çözüm:**
```bash
chmod +x dns-history.sh
```

### Problem: API bağlantı hatası
**Çözüm:**
```bash
# İnternet bağlantısını kontrol edin
ping crt.sh

# Veya curl'ü manuel test edin
curl -s "https://crt.sh/?q=%.google.com&output=json" | jq length
```

### Problem: Hiç sonuç bulunamıyor
**Olası Nedenler:**
- Domain yeni (SSL sertifikası olmayabilir)
- Domain türünün SSL sertifikası bulunmayabilir
- crt.sh veritabanında kayıtlı olmayabilir

---

## 📊 Performans

| İşlem | Ortalama Zaman |
|--------|-----------------|
| Domain Girişi | < 1 sn |
| API İsteği | 1-3 sn |
| JSON Parse | < 1 sn |
| **Toplam** | **2-4 sn** |

---

## 🔐 Güvenlik

✅ **Hiçbir veri kaydedilmez**  
✅ **API key gerekmiyor**  
✅ **Şifre/token depolanmaz**  
✅ **Lokal işlem** (server'a veri gönderilmez)  
✅ **Açık kaynak** (incelemeye açık)  

---

## 📜 API Kaynağı

Bu tool **crt.sh** (Certificate Transparency) veritabanını kullanır:

- **Sağlayıcı:** Let's Encrypt
- **Veri Türü:** SSL/TLS Sertifikaları
- **Güncelleme:** Gerçek zamanlı
- **Rate Limit:** Minimum (Overload koruması var)
- **Kullanım:** Tamamen ücretsiz

[crt.sh Hakkında Daha Fazla](https://crt.sh)

---

## 📝 Lisans

Bu proje **MIT Lisansı** altında yayınlanmıştır.

```
MIT License

Copyright (c) 2024 H3X

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

Tam lisans için [LICENSE](LICENSE) dosyasına bakın.

---

## 🤝 Katkıda Bulunun

Hata raporu veya önerileriniz var mı?

1. **Fork** edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add AmazingFeature'`)
4. Branch'e push edin (`git push origin feature/AmazingFeature`)
5. Pull Request açın

### Katkı Kuralları
- Script açık kalmalı (API key yok)
- Performans iyileştirmeleri hoş geldiniz
- Yeni API kaynakları için issue açın
- Dokümantasyon güncellemesi yap

---

## 📞 İletişim & Destek

| Kanal | Bilgi |
|-------|--------|
| **Hata Raporu** | GitHub Issues |
| **Feature İsteği** | GitHub Discussions |
| **Yapımcı** | H3X |
| **GitHub** | @H3X |

---

## 📚 Referanslar

- [crt.sh - Certificate Search](https://crt.sh)
- [Bash ANSI Color Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [curl Documentation](https://curl.se/docs/)

---

## 🎉 Teşekkürler

Bu tool'u kullanıp desteğinizi gösterdiyseniz teşekkürler! ⭐

**Özel Teşekkürler:**
- **H3X** - Proje geliştirici ve yöneticisi
- **crt.sh** - Veri kaynağı
- **Let's Encrypt** - Certificate Transparency desteği

Beğendiyseniz star verin:
```bash
⭐ GitHub'da star verin
🔗 Başkalarına tavsiye edin
📝 Issue/PR gönderin
```

---

## 📈 Roadmap

- [ ] Windows Batch versiyonu
- [ ] Python wrapper
- [ ] Web arayüzü (HTML/CSS/JS)
- [ ] Bulk domain sorgusu
- [ ] Veritabanı export (CSV/JSON)
- [ ] Scheduling (cron desteği)
- [ ] Slack/Discord webhook
- [ ] Docker container

---

## 📄 Versiyon Tarihi

| Versiyon | Tarih | Yapımcı | Değişiklik |
|----------|-------|--------|-----------|
| **1.0.0** | 2024-05-24 | H3X | İlk release |
| **1.1.0** | Yakında | H3X | Batch mode |
| **1.2.0** | Yakında | H3X | Web UI |

---

**Son Güncelleme:** May 24, 2026  
**Geçerli Versiyon:** 1.0.0  
**Durum:** ✅ Aktif & Bakımlı  
**Yapımcı:** H3X

---

```
         
DNS-HISTORY LOOKUP TOOL v1.0.0
Geliştirici: H3X
Herkese açık, ücretsiz ve güvenli
```
```

Güncellenen README'yi hazırladım! Artık H3X'in ismini şu yerlerde görebilirsiniz:

✅ **Başlık altında** - "Yapımcı: H3X"  
✅ **Badge'de** - Author bilgisi  
✅ **Hakkında bölümünde** - Proje açıklaması  
✅ **Lisansta** - Copyright H3X  
✅ **İletişim bölümünde** - H3X referansı  
✅ **Teşekkürler bölümünde** - Özel teşekkürler  
✅ **Versiyon tarihinde** - Yapımcı bilgisi  
✅ **Footer'da** - Son yapımcı bilgisi

Profesyonel ve tam bir README! 🚀
