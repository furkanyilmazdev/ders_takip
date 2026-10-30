# Özel Ders Takip Uygulaması (geçici ad)

Özel ders veren hocalar için, haftalık dersleri, hatırlatmaları ve öğrenciyle iletişimi tek yerden yönetmeyi hedefleyen bir iOS uygulaması. Flutter ile geliştiriliyor, veri önce telefonda tutuluyor (local-first), sunucu ve cihazlar arası senkron sonraki aşamada eklenecek.

> **Durum:** Erken geliştirme aşaması. "Planlanan" ve "sonraki aşama" olarak işaretlenen her şey henüz yapılmadı.

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
| Repository katmanı | Kullanılıyor (bellek içi) | Ekranlar verinin nereden geldiğini bilmez. Sunucu eklenince arayüz baştan yazılmaz. |
| Riverpod (`flutter_riverpod`) | Kullanılıyor | Sayfalar arası ortak durum yönetimi. Veri widget'ların dışında tutulur, ekranlar izler. |
| SQLite (Drift) | Planlanan | Veri cihazda kalıcı tutulur, internet olmadan çalışır. İlişkisel yapı öğrenci, ders kuralı ve istisna ilişkileri için uygun. |
| Yerel bildirimler, iOS paylaş menüsü | Planlanan | Sunucusuz hatırlatma ve WhatsApp'a mesaj aktarma. |
| FastAPI, PostgreSQL, Docker | Sonraki aşama | Cihazlar arası senkron. Kayıtlarda UUID, `updatedAt`, `deletedAt` alanları ve "son yazan kazanır" kuralı. |
| Planlama agent'ı | Sonraki aşama | WhatsApp Business API üzerinden taslak mesaj üretimi, hoca onayıyla. |

## Mimari kararlar

- **Local-first:** Telefondaki veritabanı asıl kaynak olacak, sunucu sonradan kopya ve köprü olacak.
- **Senkrona hazır modeller:** Her kayıtta cihazın ürettiği benzersiz `id` (UUID), `updatedAt` ve silme yerine `deletedAt` işareti.
- **Katmanlı yapı (uygulandı):**
  - `lib/models/`: veri modelleri
  - `lib/data/`: repository'ler ve Riverpod provider'ları
  - `lib/screens/`: ekranlar ve diyaloglar
- **Sözleşme tabanlı veri erişimi:** `StudentRepository` soyut sınıfı bir sözleşmedir. Bellek içi uygulama şimdilik onu yerine getirir, SQLite ve sunucu uygulamaları aynı sözleşmeyi yerine getirecek, ekranlar değişmeyecek.
- **Zaman:** Kayıt zamanları UTC olarak tutulur, böylece farklı saat dilimlerindeki cihazlarda "hangisi daha yeni" karşılaştırması doğru çalışır.
- **Sunucu şimdilik yok:** Öğrenci ve veli bilgileri çocuklara ait kişisel veri olduğundan, ilk sürümde veri yalnızca cihazda kalır.

## Yol haritası

- [x] Geliştirme ortamı kurulumu
- [x] İlk ders listesi ekranı (sahte veriyle)
- [x] Git ve GitHub kurulumu
- [x] Klasör yapısı ve temel veri modelleri (öğrenci, ders kuralı)
- [x] Repository katmanı (öğrenci için, bellek içi)
- [x] State management (Riverpod) ve öğrenci ekleme diyaloğu
- [ ] Kalıcı depolama (SQLite)
- [ ] Ders kuralı repository'si, ders kuralı ekleme formu ve "Bu hafta" ekranı
- [ ] İstisna modeli (erteleme, iptal) ve tekrar eden ders mantığı
- [ ] Bildirimler ve paylaş menüsü
- [ ] TestFlight ve ilk yayın (yerel sürüm)
- [ ] Sunucu ve cihazlar arası senkron
- [ ] Planlama agent'ı
- [ ] Öğrenci tarafı (takvim aboneliği, tek bağlantı sayfası, saat seçme bağlantısı)

## Haftalık rapor

### Hafta 2

**Yapılanlar**

- Kod `models/`, `data/` ve `screens/` olarak üç katmana ayrıldı. Eski oyuncak `Ders` sınıfı ve ona bağlı ekranlar silindi.
- Gerçek veri modelleri yazıldı: `Student`, `Subject` ve `LessonRule` (haftanın günü, dakika olarak başlangıç saati, süre). Hepsinde UUID, `updatedAt` (UTC) ve `deletedAt` alanları var.
- Repository sözleşmesi (`StudentRepository` soyut sınıfı) ve bellek içi uygulaması yazıldı.
- Riverpod eklendi: repository için `Provider`, öğrenci listesi için `AsyncNotifier`, ekran için `ConsumerWidget`. Veri gelme, bekleme ve hata durumları ayrı ayrı çiziliyor.
- Öğrenci ekleme diyaloğu yapıldı: metin kutusu, boş isim kontrolü, "Vazgeç" ve "Ekle" davranışları, Enter ile gönderme.
- Her adımdan sonra `flutter analyze` ile kontrol edip küçük, anlamlı commit'lerle GitHub'a gönderme düzeni oturdu.

**Öğrenilenler**

- Constructor, zorunlu isimli parametreler (`required`), `null` olabilen alanlar (`String?`) ve `final` ile `const` farkı.
- UUID ve UTC zamanın senkronda neden gerektiği; silmek yerine `deletedAt` ile işaretlemenin nedeni.
- `abstract class`, `implements` ve `@override`: sözleşme tabanlı tasarım.
- `Future`, `async` ve `await`: sonradan gelecek verilerle çalışma.
- Riverpod: `ref.watch` ile `ref.read` farkı (`build` içinde izle, butonda bir kez oku), `AsyncValue.when`.
- `StatefulWidget` neden gerekir: `TextEditingController` gibi nesnelerin widget yenilense bile yaşaması için. `dispose()` ile temizlik.
- `showDialog` ile diyaloğun değer döndürmesi (`Navigator.pop(context, değer)`) ve `null` kontrolü.
- Git geçmişine bakma (`git log`, `git status`, `git show`).

**Karşılaşılan sorunlar ve çözümleri**

- Yeni `main` fonksiyonu eskisinin içine yazılınca ve eski ekran silinince çok sayıda hata çıktı: Kullanılmayan eski kodu silip `main.dart`'ı temiz bir halde baştan yazarak çözüldü.
- `Student` sınıfı tanınmadı: Dart'ta bir dosyayı import etmek, o dosyanın kendi import ettiklerini getirmez, gerekli import'u açıkça yazmak gerekiyor.
- Commit mesajındaki `!` terminalin kapanmamış tırnak beklemesine yol açtı: Komut iptal edilip özel karakter içermeyen mesajla tekrarlandı.
- Simülatörde telefon klavyesi görünmüyor: Simülatör Mac klavyesini telefon klavyesi sayıyor, ekran klavyesi Device Hub araç çubuğundan ayrıca açılmalı. Gerçek cihazda test edilecek.

**Açık konular**

- Veri şimdilik yalnızca bellekte, uygulama yeniden başlatılınca sıfırlanıyor.
- Öğrenci ekleme diyaloğunda henüz Meet linki alanı yok (modelde alan hazır).

**Sonraki hafta**

- SQLite ile kalıcı depolama (bellek içi repository'nin yerine geçecek).
- Ders kuralı repository'si ve ekleme formu, "Bu hafta" ekranı.

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
- `child` ve `children` parametreleri, `final` ile `const` farkı.
- Sınıf, constructor ve nesne kavramları.
- Git (yerel depo, commit) ile GitHub (uzak depo, push) arasındaki fark.

**Karşılaşılan sorunlar ve çözümleri**

- `flutter` komutu bulunamadı: Klasör ana dizinde değil masaüstündeydi, PATH ayarı yanlış yolu gösteriyordu. Klasör taşınarak çözüldü.
- Xcode 27'de Simulator uygulaması yok: Yerine geçen Device Hub üzerinden simülatör başlatıldı.
- VS Code'dan kaydedince hot reload çalışmadı: Klasör "Restricted Mode"daydı. Şimdilik uygulama terminalden çalıştırılıyor.
- Xcode lisansı kabul edilmediği için `flutter doctor` hata verdi: `sudo xcodebuild -license` ile çözüldü.

## Çalıştırma

Flutter ve Xcode kurulu olmalı. Proje klasöründe:

```
flutter pub get
flutter run
```

## Gizlilik

Öğrenci ve veli bilgileri çocuklara ait kişisel veri olduğundan gereksiz veri toplanmayacak. İlk sürümde veri yalnızca cihazda kalacak, sunucu aşamasında KVKK uyumu ayrıca ele alınacak. Bu depoya gerçek öğrenci verisi eklenmemelidir.
