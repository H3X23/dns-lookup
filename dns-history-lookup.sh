#!/bin/bash

# Renk Tanımlamaları
Reset='\033[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'

BRed='\033[1;31m'
BGreen='\033[1;32m'
BYellow='\033[1;33m'
BBlue='\033[1;34m'
BCyan='\033[1;36m'

# CertSpotter API (Include_subdomains parametresi ile tüm alt domainleri de getirir)
api_base='https://api.certspotter.com/v1/issuances?domain='

# Banner
echo -e "${BCyan}"
echo "╔════════════════════════════════════════════╗"
echo "║     🔍 DNS-HISTORY LOOKUP TOOL 🔍          ║"
echo "╚════════════════════════════════════════════╝"
echo -e "${Reset}"

# Domain input
echo -e "${BBlue}Hedef domaini girin (example.com):${Reset} "
read target

# Boş veri kontrolü
if [ -z "$target" ]; then
    echo -e "${BRed}❌ Hata: Domain boş olamaz!${Reset}"
    exit 1
fi

# Format kontrolü
if ! [[ "$target" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${BRed}❌ Hata: Geçersiz domain formatı!${Reset}"
    exit 1
fi

calistir() {
    # Alt domainleri (subdomains) de sorguya dahil ediyoruz
    local api_url="${api_base}${target}&include_subdomains=true&expand=dns_names"

    echo -e "${BYellow}⏳ Sorgu yapılıyor: ${Cyan}${target}${Reset}"
    echo -e "${BYellow}📡 API: ${Cyan}CertSpotter (SSLMate)${Reset}"
    echo ""

    # İstek atılıyor
    response=$(curl -s -m 30 "$api_url" 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo -e "${BRed}❌ Bağlantı hatası veya zaman aşımı!${Reset}"
        exit 1
    fi

    # API hatası, boş dönme veya limitsel uyarı kontrolü
    if [ "$response" = "[]" ] || [ -z "$response" ] || [[ "$response" == *"error"* ]] || [[ "$response" =~ "<html" ]]; then
        echo -e "${BYellow}⚠️  Sonuç bulunamadı, API limiti aşıldı veya sunucu yanıt vermiyor!${Reset}"
        exit 0
    fi

    echo -e "${BGreen}✅ Bulundu! DNS / Sertifika Geçmişi:${Reset}"
    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # JSON Parse İşlemi: CertSpotter 'not_before' tarihi ve 'dns_names' dizisi döndürür
    # Tarihi alıp, dns_names içindeki her bir alan adı ile eşleştiriyoruz
    echo "$response" | jq -r '.[] | .not_before[0:10] as $tarih | .dns_names[] | "\($tarih)|\(.)"' 2>/dev/null | sort -u | \
    while IFS='|' read -r tarih domain_name; do
        if [ -n "$tarih" ] && [ -n "$domain_name" ] && [ "$tarih" != "null" ]; then
            echo -e "${Green}📅 ${tarih}${Reset} ${Purple}→${Reset} ${Cyan}${domain_name}${Reset}"
        fi
    done

    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # Toplam kayıt sayısı hesabı (jq ile dns_names içindeki toplam öğeyi sayıyoruz)
    toplam=$(echo "$response" | jq '[.[].dns_names[]] | length' 2>/dev/null)
    if [ -z "$toplam" ] || [ "$toplam" == "null" ]; then
        toplam="0"
    fi
    echo -e "${BGreen}📊 Toplam Kayıt:${Reset} ${BYellow}${toplam}${Reset}"
}

# Fonksiyonu çağır
calistir

# Format kontrolü
if ! [[ "$target" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${BRed}❌ Hata: Geçersiz domain formatı!${Reset}"
    exit 1
fi

calistir() {
    local api_url="${dnsdomain}${target}&output=json"

    echo -e "${BYellow}⏳ Sorgu yapılıyor: ${Cyan}${target}${Reset}"
    echo -e "${BYellow}📡 API: ${Cyan}crt.sh${Reset}"
    echo ""

    # İstek atılırken timeout (30sn) ve browser user-agent eklendi
    response=$(curl -s -m 30 -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$api_url" 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo -e "${BRed}❌ Bağlantı hatası veya zaman aşımı!${Reset}"
        exit 1
    fi

    # API bazen JSON yerine HTML hata sayfası fırlatabilir, bunu kontrol ediyoruz
    if [ "$response" = "[]" ] || [ -z "$response" ] || [[ "$response" =~ "<html" ]] || [[ "$response" =~ "Error" ]]; then
        echo -e "${BYellow}⚠️  Sonuç bulunamadı veya API yoğun yanıt vermiyor!${Reset}"
        exit 0
    fi

    echo -e "${BGreen}✅ Bulundu! SSL Sertifika Geçmişi:${Reset}"
    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # JSON Parse İşlemi: logged_at yerine not_before kullanıldı ve common_name çekildi
    echo "$response" | jq -r '.[] | "\((.not_before // .entry_timestamp)[0:10])|\(.common_name)"' 2>/dev/null | sort -u | \
    while IFS='|' read -r tarih domain_name; do
        
        # Sadece tarih ve domain doluysa ekrana bas (Döngü çökmesine karşı koruma)
        if [ -n "$tarih" ] && [ -n "$domain_name" ] && [ "$tarih" != "null" ]; then
            echo -e "${Green}📅 ${tarih}${Reset} ${Purple}→${Reset} ${Cyan}${domain_name}${Reset}"
        fi
        
    done

    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # Toplam kayıt sayısı hesabı
    toplam=$(echo "$response" | jq 'length' 2>/dev/null)
    if [ -z "$toplam" ]; then
        toplam="0"
    fi
    echo -e "${BGreen}📊 Toplam Kayıt:${Reset} ${BYellow}${toplam}${Reset}"
}

# Fonksiyonu çağır
calistir
fi

# Domain format kontrolü
if ! [[ "$target" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${BRed}❌ Hata: Geçersiz domain formatı!${Reset}"
    exit 1
fi

istek() {
    # crt.sh API isteğini oluştur
    local url="${dnsdomain}${target}&output=json"
    echo "$url"
}

calistir() {
    local api_url=$(istek)

    echo -e "${BYellow}⏳ Sorgu yapılıyor: ${Cyan}${target}${Reset}"
    echo -e "${BYellow}📡 API: ${Cyan}crt.sh${Reset}"
    echo ""

    # API isteğini yap ve kontrol et
    response=$(curl -s -A "Mozilla/5.0" "$api_url" 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo -e "${BRed}❌ Bağlantı hatası!${Reset}"
        exit 1
    fi

    # JSON boş mu kontrol et
    if [ "$response" = "[]" ] || [ -z "$response" ] || [[ "$response" == *"Error"* ]]; then
        echo -e "${BYellow}⚠️  Sonuç bulunamadı veya API yoğun!${Reset}"
        exit 0
    fi

    # Başlık
    echo -e "${BGreen}✅ Bulundu! SSL Sertifika Geçmişi:${Reset}"
    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # JSON'u parse et ve göster (Güvenli split ekledici)
    echo "$response" | jq -r '.[] | "\(.logged_at | select(. != null) | .[0:10]) | \(.name_value)"' 2>/dev/null | \
    sort -u | while IFS='|' read -r tarih domain_name; do
        # Boş satırları atla
        [ -z "$tarih" ] && continue
        echo -e "${Green}📅 ${tarih:1}${Reset} ${Purple}→${Reset} ${Cyan}${domain_name:1}${Reset}"
    done

    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # İstatistik
    toplam=$(echo "$response" | jq 'length' 2>/dev/null)
    echo -e "${BGreen}📊 Toplam Kayıt:${Reset} ${BYellow}${toplam}${Reset}"
}

# Script'i çalıştır
calistir
fi

# Domain format kontrolü
if ! [[ "$target" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${BRed}❌ Hata: Geçersiz domain formatı!${Reset}"
    exit 1
fi

istek() {
    # crt.sh API isteğini oluştur
    local url="${dnsdomain}${target}&output=json"
    echo "$url"
}

calistir() {
    local api_url=$(istek)

    echo -e "${BYellow}⏳ Sorgu yapılıyor: ${Cyan}${target}${Reset}"
    echo -e "${BYellow}📡 API: ${Cyan}crt.sh${Reset}"
    echo ""

    # API isteğini yap ve kontrol et
    response=$(curl -s "$api_url" 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo -e "${BRed}❌ Bağlantı hatası!${Reset}"
        exit 1
    fi

    # JSON boş mu kontrol et
    if [ "$response" = "[]" ] || [ -z "$response" ]; then
        echo -e "${BYellow}⚠️  Sonuç bulunamadı!${Reset}"
        exit 0
    fi

    # Başlık
    echo -e "${BGreen}✅ Bulundu! SSL Sertifika Geçmişi:${Reset}"
    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # JSON'u parse et ve göster
    echo "$response" | jq -r '.[] | "\(.logged_at | split("T")[0]) | \(.name_value)"' | \
    sort -u | while IFS='|' read tarih domain_name; do
        echo -e "${Green}📅 ${tarih}${Reset} ${Purple}→${Reset} ${Cyan}${domain_name}${Reset}"
    done

    echo -e "${BCyan}════════════════════════════════════════════${Reset}"

    # İstatistik
    toplam=$(echo "$response" | jq 'length')
    echo -e "${BGreen}📊 Toplam Kayıt:${Reset} ${BYellow}${toplam}${Reset}"
}

# Script'i çalıştır
calistir
