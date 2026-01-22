# Strong Password Generator / Güçlü Şifre Oluşturucu

[![Languages](https://img.shields.io/badge/Language-TR%20%7C%20EN-blue)](#)

[👇 English](#english) | [👇 Türkçe](#türkçe)

---

<a name="türkçe"></a>
# Proje: Güçlü Şifre Oluşturucu

**Dil:** Türkçe

## Proje Özeti
Bu proje, mobil kullanıcıların güvenli parola oluşturma ve bu parolaları cihaz üzerinde güvenli bir şekilde saklama ihtiyacını karşılayan bir Flutter uygulamasıdır. Çevrimdışı çalışarak veri gizliliğini önceler ve karmaşıklık/uzunluk parametrelerine dayalı özelleştirilebilir bir parola üretim mekanizması sunar.

## Teknik Öne Çıkanlar
*   **Algoritma Tasarımı**: Parola üretiminde kullanılan özel algoritma, kriptografik açıdan güçlü rastgelelik sağlarken (secure random), kullanıcı tarafından belirtilen anahtar kelimelerin parolanın içine homojen dağıtılmasını sağlar.
*   **Yerel Veritabanı Mimarisi**: Uygulama verileri, `sqflite` kütüphanesi kullanılarak SQLite tabanlı ilişkisel bir veritabanında saklanır. CRUD operasyonları asenkron mimari ile yönetilerek UI bloklanmasının önüne geçilmiştir.
*   **Lokalizasyon Yönetimi**: `easy_localization` paketi ile dinamik dil değiştirme altyapısı kurulmuş, uygulamanın yeniden başlatılmasına gerek kalmadan çalışma zamanında dil değişimi sağlanmıştır.
*   **UI/UX Implementasyonu**: Standart Material Design prensiplerine sadık kalınarak, platform bağımsız bir kullanıcı deneyimi hedeflenmiştir.

## Kullanılan Teknolojiler
*   **Framework**: Flutter (Dart)
*   **Veritabanı**: SQLite (`sqflite`)
*   **Uluslararasılaştırma**: `easy_localization`
*   **Monetizasyon**: Google Mobile Ads SDK

## Bu Proje Neyi Gösteriyor
Bu proje, aşağıdaki teknik yetkinlikleri ve mühendislik pratiklerini sergilemektedir:
*   Cross-platform mobil uygulama geliştirme döngüsü.
*   İlişkisel veritabanı tasarımı ve asenkron veri yönetimi.
*   Temel algoritma mantığı ve string manipülasyonu.
*   Üçüncü parti kütüphane entegrasyonu ve paket yönetimi.
*   Temiz kod prensipleri ve proje yapılandırması 

---

<a name="english"></a>
# Project: Strong Password Generator

**Language:** English

## Project Summary
This project is a Flutter application designed to address the need for secure password generation and local storage on mobile devices. Operating offline to prioritize data privacy, it offers a customizable password generation mechanism based on complexity and length parameters.

## Technical Highlights
*   **Algorithm Design**: A custom generation algorithm employs cryptographically secure randomness while ensuring the homogeneous distribution of user-defined keywords within the password string.
*   **Local Database Architecture**: Application data is persisted in a relational SQLite database using the `sqflite` library. CRUD operations are managed asynchronously to prevent UI blocking.
*   **Localization Management**: Dynamic language switching is implemented via `easy_localization`, allowing for runtime context changes without requiring an application restart.
*   **UI/UX Implementation**: Adheres to Material Design principles to ensure a consistent, platform-independent user experience.

## Technologies Used
*   **Framework**: Flutter (Dart)
*   **Database**: SQLite (`sqflite`)
*   **Internationalization**: `easy_localization`
*   **Monetization**: Google Mobile Ads SDK

## What This Project Demonstrates
This project demonstrates the following technical competencies and engineering practices:
*   Full lifecycle cross-platform mobile application development.
*   Relational database design and asynchronous data handling.
*   Core algorithmic logic and string manipulation.
*   Integration of third-party libraries and package management.
