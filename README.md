# Özel Ders Takip Uygulaması (geçici ad)

Özel ders veren hocalar için, haftalık dersleri, hatırlatmaları ve öğrenciyle iletişimi tek yerden yönetmeyi hedefleyen bir iOS uygulaması. Flutter ile geliştiriliyor, veri önce telefonda tutuluyor (local-first), sunucu ve cihazlar arası senkron sonraki aşamada eklenecek.

> **Durum:** Erken geliştirme aşaması. Aşağıda "planlanan" olarak işaretlenen her şey henüz yapılmadı.

## Problem

Özel ders veren hocalar dersleri çoğunlukla WhatsApp yazışmaları, platform panelleri ve hafızayla takip ediyor:

- Gün ve saat yazışmayla belirleniyor, saat değişince herkese tek tek yazılıyor.
- Haftalık programlar ayrıca bir platforma girilmek zorunda kalıyor.
- Ders öncesi hazırlık (materyal, ödev kontrolü) kolayca unutuluyor.
- Öğrenci sayısı arttıkça bu yük büyüyor.

Problemi kendim yaşıyorum çünkü matematik özel dersi veriyorum.

## Çözüm (planlanan özellikler)

- **Haftalık tekrar eden ders kuralı:** Bir kez "her hafta Salı 19:00" tanımlanır, dersler otomatik oluşur.
- **İstisna yönetimi:** Tek seferlik erteleme ve iptaller kuralı bozmadan işlenir.
- **Hatırlatmalar:** Ders günü, ders öncesi hazırlık ve haftalık programı sisteme girme bildirimi.
- **Hızlı iletişim:** Meet bağlantısına tek dokunuşla erişim, değişiklikte öğrenciye gidecek mesajın hazır taslak olarak paylaşılması.
- **Ders notu ve hazırlık listesi:** Her ders için kısa not ve kontrol listesi.

## Teknolojiler ve nedenleri

| Teknoloji | Durum | Neden |
|---|---|---|
| Flutter (Dart) | Kullanılıyor | Tek kod tabanıyla iOS, ileride Android ve macOS. Hot reload ile hızlı geliştirme. |
| Git ve GitHub | Kullanılıyor | Sürüm takibi ve yedekleme (özel depo). |
| SQLite (Drift) | Planlanan | Veri önce cihazda tutulur, internet olmadan çalışır. İlişkisel yapı öğrenci, ders kuralı ve istisna ilişkileri için uygun. |
| Repository katmanı | Planlanan | Ekranlar verinin nereden geldiğini bilmez. Sunucu eklenince arayüz baştan yazılmaz. |
| Riverpod | Planlanan | Sayfalar arası durum yönetimi. |
| Yerel bildirimler, iOS paylaş menüsü | Planlanan | Sunucusuz hatırlatma ve WhatsApp'a mesaj aktarma. |
| FastAPI, PostgreSQL, Docker | Sonraki aşama | Cihazlar arası senkron. Kayıtlarda UUID, `updatedAt`, `deletedAt` alanları ve "son yazan kazanır" kuralı. |
| Planlama agent'ı | Sonraki aşama | WhatsApp Business API üzerinden taslak mesaj üretimi, hoca onayıyla. |

## Mimari kararlar

- **Local-first:** Telefondaki veritabanı asıl kaynak, sunucu sonradan kopya ve köprü olacak.
- **Senkrona hazır modeller:** Her kayıtta cihazın ürettiği benzersiz `id`, `updatedAt` ve silme yerine `deletedAt` işareti.
- **Katmanlı yapı (planlanan):** `models/` (veri modelleri), `data/` (repository'ler), `screens/` (ekranlar).
- **Sunucu şimdilik yok:** Öğrenci ve veli bilgileri çocuklara ait kişisel veri olduğundan, ilk sürümde veri yalnızca cihazda kalır.

## Yol haritası

- [x] Geliştirme ortamı kurulumu
- [x] İlk ders listesi ekranı (sahte veriyle)
- [x] Git ve GitHub kurulumu
- [ ] Klasör yapısı ve gerçek veri modelleri (öğrenci, ders kuralı, istisna)
- [ ] Repository katmanı
- [ ] State management ve ders ekleme formu
- [ ] SQLite ile kalıcı depolama
- [ ] Tekrar eden ders mantığı ve istisnalar
- [ ] Bildirimler ve paylaş menüsü
- [ ] TestFlight ve ilk yayın (yerel sürüm)
- [ ] Sunucu ve cihazlar arası senkron
- [ ] Planlama agent'ı
- [ ] Öğrenci tarafı (takvim aboneliği, tek bağlantı sayfası, saat seçme bağlantısı)

## Haftalık rapor

### Hafta 1

**Yapılanlar**

- Mac üzerinde Flutter, Xcode, CocoaPods ve VS Code kurulumu tamamlandı.
- Uygulama iOS simülatöründe çalıştırıldı ve hot reload test edildi.
- `ders_takip` projesi oluşturuldu (`flutter create --org ...`).
- Demo sayaç uygulaması, sabit veriyle çalışan bir ders listesine dönüştürüldü: `Ders` sınıfı, `ListView.builder` ve `setState` ile listeye eleman ekleme.
- Git ile yerel depo oluşturuldu, GitHub'da özel depoya bağlandı ve ilk kayıt gönderildi.
- Projenin mimarisi (local-first, repository, sunucunun sonradan eklenmesi) planlandı.

**Öğrenilenler**

- Flutter'da ekran bir widget ağacıdır; `StatelessWidget` ve `StatefulWidget` farkı.
- `build` fonksiyonu ve `setState`: veri değişse bile ekran, Flutter'a haber verilmeden yenilenmez.
- `child` ve `children` parametreleri, `final` ile `const` farkı (değerin derleme anında bilinmesi gerekliliği).
- Sınıf, constructor ve nesne kavramları.
- Git (yerel depo, commit) ile GitHub (uzak depo, push) arasındaki fark.

**Karşılaşılan sorunlar ve çözümleri**

- `flutter` komutu bulunamadı: Klasör ana dizinde değil masaüstündeydi, PATH ayarı yanlış yolu gösteriyordu. Klasör taşınarak çözüldü.
- Xcode 27'de Simulator uygulaması yok: Yerine geçen Device Hub üzerinden simülatör başlatıldı.
- VS Code'dan kaydedince hot reload çalışmadı: Klasör "Restricted Mode"daydı, güvenilir klasör olarak işaretlenmesi gerekiyordu. Şimdilik uygulama terminalden çalıştırılıyor.
- Xcode lisansı kabul edilmediği için `flutter doctor` hata verdi: `sudo xcodebuild -license` ile çözüldü.

**Sonraki hafta**

- Klasör yapısını kurmak, gerçek veri modellerini ayrı dosyalara yazmak.
- Repository katmanı ve ders ekleme formu.

## Çalıştırma

Flutter ve Xcode kurulu olmalı. Proje klasöründe:

```
flutter pub get
flutter run
```

## Gizlilik

Öğrenci ve veli bilgileri çocuklara ait kişisel veri olduğundan gereksiz veri toplanmayacak. İlk sürümde veri yalnızca cihazda kalacak, sunucu aşamasında KVKK uyumu ayrıca ele alınacak. Bu depoya gerçek öğrenci verisi eklenmemelidir.
