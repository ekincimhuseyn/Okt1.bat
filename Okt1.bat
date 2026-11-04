@echo off
title Wi-Fi Kamerası Tespit ve Link Çıkarıcı
setlocal enabledelayedexpansion

echo Ağ tarama başlatılıyor...
arp -a > arp_listesi.txt

echo Tespit edilen cihazlar:
findstr /i "dhcp" arp_listesi.txt >NUL
for /f "tokens=2" %%a in (arp_listesi.txt) do (
    set "IP=%%a"
    echo IP: !IP!
    
    :: Basit HTTP bağlantı testi (genel kamera portları)
    curl -s -o nul -w "HTTP %%{http_code} -> !IP!" http://!IP!:80 2>&1 || echo HTTP -> !IP! (bağlantı hatası)
    
    :: Özel kamera portları için test (isteğe göre düzenlenebilir)
    curl -s -o nul -w "Port8080 %%{http_code} -> !IP!" http://!IP!:8080 2>&1 || echo Port8080 -> !IP! (bağlantı hatası)
)

echo Taraması tamamlandı. Sonuçlar arp_listesi.txt içinde.
pause
