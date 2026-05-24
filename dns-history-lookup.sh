#!/bin/bash

Reset='\033[0m'       # Her şeyi normale döndürür
Red='\033[0;31m'      # Kırmızı
Green='\033[0;32m'    # Yeşil
Yellow='\033[0;33m'   # Sarı
Blue='\033[0;34m'     # Mavi
Purple='\033[0;35m'   # Mor
Cyan='\033[0;36m'     # Turkuaz
White='\033[0;37m'    # Beyaz

# Kalın (Bold) Renkler - Daha canlı durur
BRed='\033[1;31m'
BGreen='\033[1;32m'
BYellow='\033[1;33m'
BBlue='\033[1;34m'
BCyan='\033[1;36m'

# DNS-HISTORY LOOKUP İÇİN GEREKLİ SİTE/APİ (% işareti URL encode olarak %25 yapıldı)
dnsdomain='https://crt.sh/?q=%25.'

# Banner
echo -e "${BCyan}"
echo "╔════════════════════════════════════════════╗"
echo "║     🔍 DNS-HISTORY LOOKUP TOOL 🔍          ║"
echo "╚════════════════════════════════════════════╝"
echo -e "${Reset}"

# Domain input
echo -e "${BBlue}Hedef domaini girin (example.com şeklinde olmalıdır):${Reset} "
read target

# Validasyon
if [ -z "$target" ]; then
    echo -e "${BRed}❌ Hata: Domain boş olamaz!${Reset}"
    exit 1
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
