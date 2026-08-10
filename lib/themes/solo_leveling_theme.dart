import 'package:flutter/material.dart';

class SoloLevelingTheme {
  static const Color darkBlue = Color(0xFF0A0E1A); // почти чёрно-синий
  static const Color navyBlue = Color(
    0xFF111B2E,
  ); // глубокий синий (фон карточек)
  static const Color steelBlue = Color.fromARGB(255, 50, 82, 133); // для границ/разделителей
  static const Color glowBlue = Color(0xFF4FC3F7); // основной акцент (свечение)
  static const Color iceBlue = Color(0xFF81D4FA); // более светлый голубой
  static const Color paleBlue = Color(0xFFB3E5FC); // для текста второстепенного
  static const Color textPrimary = Color(0xFFE3F2FD); // почти белый с оттенком
  static const Color textSecondary = Color(0xFF90CAF9);

  static ThemeData get theme {
    return ThemeData(
      // ---- Базовые цвета ----
      brightness: Brightness.dark,
      primaryColor: darkBlue,
      scaffoldBackgroundColor: darkBlue,
      canvasColor: navyBlue,
      cardColor: navyBlue,
      dividerColor: steelBlue.withValues(alpha: 0.5),
      focusColor: glowBlue,
      highlightColor: glowBlue.withValues(alpha: 0.2),
      splashColor: glowBlue.withValues(alpha: 0.1),

      // ---- Цветовая схема (ColorScheme) ----
      colorScheme: const ColorScheme.dark(
        primary: darkBlue,
        secondary: glowBlue,
        surface: navyBlue,
        error: Color(0xFFEF5350),
        onPrimary: textPrimary,
        onSecondary: darkBlue,
        onSurface: textPrimary,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),

      // ---- Текстовые стили (Solo Leveling UI) ----
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          shadows: [Shadow(color: glowBlue, blurRadius: 8)],
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
        labelLarge: TextStyle(
          color: glowBlue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ---- AppBar (как "системное окно") ----
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBlue,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          shadows: [Shadow(color: glowBlue, blurRadius: 6)],
        ),
        iconTheme: IconThemeData(color: glowBlue),
      ),

      // ---- BottomNavigationBar (в стиле Solo Leveling) ----
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBlue, // фон панели
        elevation: 8, // лёгкая тень для отделения
        type: BottomNavigationBarType.fixed, // все иконки видны (без скрытия)
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: glowBlue, // активный элемент — голубое свечение
        unselectedItemColor: steelBlue, // неактивный — тусклый синий
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
        ),
        // Если хочешь добавить индикатор выбранного пункта (как полоску)
        // можно использовать свойство selectedIconTheme, но стандартно
        // BottomNavigationBar не поддерживает полоску, только цвет иконки/текста
      ),

      // ---- Кнопки ----
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: glowBlue,
          foregroundColor: darkBlue,
          elevation: 4,
          shadowColor: glowBlue.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: glowBlue,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: glowBlue,
          side: const BorderSide(color: glowBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: steelBlue,
      ),

      // ---- Поля ввода (как интерфейс системы) ----
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: navyBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: steelBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: steelBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: glowBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        prefixIconColor: glowBlue,
        suffixIconColor: glowBlue,
      ),

      // ---- Карточки (как "окна статуса") ----
      cardTheme: CardThemeData(
        color: navyBlue,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: steelBlue.withValues(alpha: 0.3)),
        ),
        shadowColor: glowBlue.withValues(alpha: 0.1),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      ),

      // ---- Диалоги, BottomSheet ----
      dialogTheme: DialogThemeData(
        backgroundColor: navyBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: textSecondary, fontSize: 16),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: navyBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ---- Чекбоксы, Switch (в стиле системы) ----
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return glowBlue;
          return steelBlue;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return glowBlue;
          return steelBlue;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return glowBlue.withValues(alpha: 0.4);
          }
          return steelBlue.withValues(alpha: 0.3);
        }),
      ),

      // ---- Слайдеры ----
      sliderTheme: SliderThemeData(
        activeTrackColor: glowBlue,
        inactiveTrackColor: steelBlue,
        thumbColor: glowBlue,
        overlayColor: glowBlue.withValues(alpha: 0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),

      // ---- Индикаторы загрузки ----
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: glowBlue,
        linearTrackColor: steelBlue,
        circularTrackColor: steelBlue,
      ),

      // ---- Иконки ----
      iconTheme: const IconThemeData(color: glowBlue, size: 24),
    );
  }
}
