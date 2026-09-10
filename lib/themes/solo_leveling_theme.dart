import 'package:flutter/material.dart';

class SoloLevelingTheme {
  static const Color back1 = Color(0xFF0A0E1A); // почти чёрно-синий
  static const Color back2 = Color(0xFF111B2E); // глубокий синий (фон карточек)
  static const Color details1 = Color.fromARGB(255, 13, 48, 103); // для границ/разделителей
  static const Color details2 = Color.fromARGB(255, 30, 66, 126); // для границ/разделителей
  static const Color active1 = Color.fromARGB(255, 66, 193, 252); // основной акцент (свечение)
  static const Color active2 = Color(0xFF81D4FA); // более светлый голубой
  static const Color text3 = Color.fromARGB(255, 117, 174, 200); // для текста второстепенного
  static const Color text2 = Color(0xFFB3E5FC); // для текста второстепенного
  static const Color text1 = Color(0xFFE3F2FD); // почти белый с оттенком

  static ThemeData get theme {
    return ThemeData(
      // ---- Базовые цвета ----
      brightness: Brightness.dark,
      primaryColor: back1,
      scaffoldBackgroundColor: back1.withAlpha(230),
      canvasColor: back2,
      cardColor: back2,
      dividerColor: details1.withValues(alpha: 0.5),
      focusColor: active1,
      highlightColor: active1.withValues(alpha: 0.2),
      splashColor: active1.withValues(alpha: 0.1),

      // ---- Цветовая схема (ColorScheme) ----
      colorScheme: const ColorScheme.dark(
        primary: back1,
        secondary: active1,
        surface: back2,
        error: Color(0xFFEF5350),
        onPrimary: text1,
        onSecondary: back1,
        onSurface: text2,
        onError: text1,
        brightness: Brightness.dark,
      ),

      // ---- Текстовые стили (Solo Leveling UI) ----
      textTheme: const TextTheme(
        // Шапки
        headlineLarge: TextStyle(
          color: text1,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          shadows: [Shadow(color: active1, blurRadius: 8)],
        ),
        headlineMedium: TextStyle(
          color: text2,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),

        
        
        // Заголовки
        titleLarge: TextStyle(
          color: text1,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: text2,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: text3,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        
        // Текст
        bodyLarge: TextStyle(color: text1, fontSize: 16),
        bodyMedium: TextStyle(color: text2, fontSize: 14),

        // Метки
        labelLarge: TextStyle(
          color: active1,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ---- AppBar (как "системное окно") ----
      appBarTheme: const AppBarTheme(
        backgroundColor: back1,
        foregroundColor: text1,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: text1,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          shadows: [Shadow(color: active1, blurRadius: 6)],
        ),
        iconTheme: IconThemeData(color: active1),
      ),

      // ---- BottomNavigationBar (в стиле Solo Leveling) ----
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: back1, // фон панели
        elevation: 8, // лёгкая тень для отделения
        type: BottomNavigationBarType.fixed, // все иконки видны (без скрытия)
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: active1, // активный элемент — голубое свечение
        unselectedItemColor: details1, // неактивный — тусклый синий
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

      // ---- ListTile ----
      listTileTheme: ListTileThemeData(
        iconColor: active1
      ),

      // ---- Кнопки ----
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: active1,
          foregroundColor: back1,
          elevation: 4,
          shadowColor: active1.withValues(alpha: 0.4),
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
          foregroundColor: active1,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: active1,
          side: const BorderSide(color: active1, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: details1,
      ),

      // ---- Поля ввода (как интерфейс системы) ----
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: back2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: details1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: details1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: active1, width: 2),
        ),
        labelStyle: const TextStyle(color: text2),
        hintStyle: const TextStyle(color: text2, fontSize: 14),
        prefixIconColor: active1,
        suffixIconColor: active1,
      ),

      // ---- Карточки (как "окна статуса") ----
      cardTheme: CardThemeData(
        color: back2,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: details1.withValues(alpha: 0.3)),
        ),
        shadowColor: active1.withValues(alpha: 0.1),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      ),

      // ---- Диалоги, BottomSheet ----
      dialogTheme: DialogThemeData(
        backgroundColor: back2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: text1,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: text2, fontSize: 16),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: back2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ---- Чекбоксы, Switch (в стиле системы) ----
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return active1;
          return details1;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return active1;
          return details1;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return active1.withValues(alpha: 0.4);
          }
          return details1.withValues(alpha: 0.3);
        }),
      ),

      // ---- Слайдеры ----
      sliderTheme: const SliderThemeData(
        activeTrackColor: active1,
        inactiveTrackColor: details1,
        thumbColor: active1,
        overlayColor: active2,
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
      ),

      // ---- Индикаторы загрузки ----
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: active1,
        linearTrackColor: details1,
        circularTrackColor: details1,
      ),

      // ---- Иконки ----
      primaryIconTheme: const IconThemeData(color: active1, size: 24),
      iconTheme: const IconThemeData(color: active1, size: 24),
    );
  }
}
