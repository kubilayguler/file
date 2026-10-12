# Yönetici yetkisi kontrolü
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Lutfen bu scripti Yonetici (Administrator) olarak calistirin!" -ForegroundColor Red
    Exit
}

Write-Host "1. Uzak Masaustu servisi ve kayit defteri ayarlaniyor..." -ForegroundColor Cyan
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1

Write-Host "2. Guvenlik duvarinda Uzak Masaustu kurallari aciliyor..." -ForegroundColor Cyan
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue

Write-Host "3. Aktif ag profili 'Private' (Ozel) olarak ayarlaniyor..." -ForegroundColor Cyan
$profile = Get-NetConnectionProfile
if ($profile) {
    Set-NetConnectionProfile -InterfaceIndex $profile.InterfaceIndex -NetworkCategory Private
}

Write-Host "Islem tamamlandi! Uzak Masaustu artik aktif ve erisime hazir." -ForegroundColor Green