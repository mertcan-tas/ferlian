# Ferlian — Kod Kalite ve Stil Kuralları

## 2. Renk ve Tema Kullanımı

- renk paletim lib/core/theme/app_theme.dart burda tüm renklerimi buradan al
- `Color.withOpacity(...)` **kullanma**; yerine `Color.withValues(alpha: …)` kullan.
- `ColorScheme.surfaceVariant`, `ColorScheme.background`, `ColorScheme.onBackground` gibi deprecated roller **kullanma**; yerine `surfaceContainerHighest`, `surface`, `onSurface` gibi yeni roller kullan.
- Tema tanımlamaları `ThemeData.colorScheme = …` şeklinde yapılmalı; eski `backgroundColor`, `accentColor` gibi özellikler mümkünse bırakılmalı.
