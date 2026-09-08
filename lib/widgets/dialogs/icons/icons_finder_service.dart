import 'package:flutter/material.dart';

class NamedIcon {
  final IconData icon;
  final String name;
  final String category;
  final List<String> tags; // для дополнительного поиска

  const NamedIcon({
    required this.icon,
    required this.name,
    required this.category,
    this.tags = const [],
  });

  // Проверка соответствия поисковому запросу
  bool matchesSearch(String query) {
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
           category.toLowerCase().contains(q) ||
           tags.any((tag) => tag.toLowerCase().contains(q));
  }

  @override
  String toString() => name;
}

class GameficationIcons {
  static final List<NamedIcon> allIcons = [
    // === КЛАССЫ (Class) ===
    NamedIcon(
      icon: Icons.shield,
      name: 'Защитник',
      category: 'Классы',
      tags: ['щит', 'защита', 'танк', 'shield', 'protect'],
    ),
    NamedIcon(
      icon: Icons.bolt,
      name: 'Маг Молний',
      category: 'Классы',
      tags: ['магия', 'молния', 'электричество', 'lightning', 'mage'],
    ),
    NamedIcon(
      icon: Icons.whatshot,
      name: 'Маг Огня',
      category: 'Классы',
      tags: ['огонь', 'пиромант', 'пламя', 'fire', 'pyro'],
    ),
    NamedIcon(
      icon: Icons.ac_unit,
      name: 'Маг Льда',
      category: 'Классы',
      tags: ['лёд', 'криомант', 'холод', 'ice', 'cryo'],
    ),
    NamedIcon(
      icon: Icons.self_improvement,
      name: 'Монах',
      category: 'Классы',
      tags: ['дух', 'медитация', 'ки', 'monk', 'spirit'],
    ),
    NamedIcon(
      icon: Icons.sports_kabaddi,
      name: 'Боец',
      category: 'Классы',
      tags: ['бой', 'рукопашный', 'fighter', 'martial'],
    ),
    NamedIcon(
      icon: Icons.gavel,
      name: 'Паладин',
      category: 'Классы',
      tags: ['рыцарь', 'святой', 'правосудие', 'paladin', 'knight'],
    ),
    NamedIcon(
      icon: Icons.school,
      name: 'Ученик',
      category: 'Классы',
      tags: ['студент', 'обучение', 'школа', 'student', 'learn'],
    ),
    NamedIcon(
      icon: Icons.science,
      name: 'Учёный',
      category: 'Классы',
      tags: ['наука', 'исследование', 'лаборатория', 'scientist', 'research'],
    ),
    NamedIcon(
      icon: Icons.construction,
      name: 'Инженер',
      category: 'Классы',
      tags: ['строитель', 'механик', 'постройка', 'engineer', 'build'],
    ),
    NamedIcon(
      icon: Icons.brush,
      name: 'Художник',
      category: 'Классы',
      tags: ['рисование', 'живопись', 'творчество', 'artist', 'paint'],
    ),
    NamedIcon(
      icon: Icons.music_note,
      name: 'Музыкант',
      category: 'Классы',
      tags: ['музыка', 'инструмент', 'песня', 'musician', 'music'],
    ),
    NamedIcon(
      icon: Icons.computer,
      name: 'Программист',
      category: 'Классы',
      tags: ['код', 'разработка', 'айти', 'programmer', 'code'],
    ),
    NamedIcon(
      icon: Icons.medical_services,
      name: 'Лекарь',
      category: 'Классы',
      tags: ['врач', 'лечение', 'здоровье', 'healer', 'doctor'],
    ),
    NamedIcon(
      icon: Icons.restaurant,
      name: 'Повар',
      category: 'Классы',
      tags: ['еда', 'готовка', 'кухня', 'cook', 'chef'],
    ),
    NamedIcon(
      icon: Icons.agriculture,
      name: 'Фермер',
      category: 'Классы',
      tags: ['земля', 'урожай', 'растение', 'farmer', 'grow'],
    ),
    NamedIcon(
      icon: Icons.business_center,
      name: 'Предприниматель',
      category: 'Классы',
      tags: ['бизнес', 'коммерция', 'стартап', 'business', 'entrepreneur'],
    ),
    NamedIcon(
      icon: Icons.auto_awesome,
      name: 'Маг',
      category: 'Классы',
      tags: ['волшебство', 'магия', 'заклинание', 'wizard', 'magic'],
    ),
    NamedIcon(
      icon: Icons.nightlight,
      name: 'Тёмный Маг',
      category: 'Классы',
      tags: ['тьма', 'некромант', 'shadow', 'dark', 'necromancer'],
    ),
    NamedIcon(
      icon: Icons.wb_sunny,
      name: 'Светлый Маг',
      category: 'Классы',
      tags: ['свет', 'солнце', 'священник', 'light', 'priest'],
    ),
    NamedIcon(
      icon: Icons.nature_people,
      name: 'Друид',
      category: 'Классы',
      tags: ['природа', 'животные', 'лес', 'druid', 'nature'],
    ),
    NamedIcon(
      icon: Icons.psychology,
      name: 'Псионик',
      category: 'Классы',
      tags: ['разум', 'телепатия', 'психика', 'psychic', 'mind'],
    ),
    NamedIcon(
      icon: Icons.hexagon,
      name: 'Алхимик',
      category: 'Классы',
      tags: ['зелья', 'трансмутация', 'химия', 'alchemist', 'potion'],
    ),
    NamedIcon(
      icon: Icons.stars,
      name: 'Звёздный Маг',
      category: 'Классы',
      tags: ['космос', 'звёзды', 'астрология', 'astral', 'cosmic'],
    ),

    // === НАВЫКИ (Skills) ===
    NamedIcon(
      icon: Icons.fitness_center,
      name: 'Сила',
      category: 'Навыки',
      tags: ['тренировка', 'спорт', 'мышцы', 'strength', 'gym'],
    ),
    NamedIcon(
      icon: Icons.directions_run,
      name: 'Скорость',
      category: 'Навыки',
      tags: ['бег', 'быстрота', 'ловкость', 'speed', 'run'],
    ),
    NamedIcon(
      icon: Icons.health_and_safety,
      name: 'Выносливость',
      category: 'Навыки',
      tags: ['здоровье', 'жизнь', 'hp', 'stamina', 'endurance'],
    ),
    NamedIcon(
      icon: Icons.self_improvement,
      name: 'Гибкость',
      category: 'Навыки',
      tags: ['растяжка', 'йога', 'подвижность', 'flexibility', 'yoga'],
    ),
    NamedIcon(
      icon: Icons.sports_gymnastics,
      name: 'Акробатика',
      category: 'Навыки',
      tags: ['трюки', 'гимнастика', 'прыжки', 'acrobatics', 'gymnastic'],
    ),
    NamedIcon(
      icon: Icons.pool,
      name: 'Плавание',
      category: 'Навыки',
      tags: ['вода', 'бассейн', 'море', 'swimming', 'swim'],
    ),
    NamedIcon(
      icon: Icons.terrain,
      name: 'Скалолазание',
      category: 'Навыки',
      tags: ['горы', 'скалы', 'высота', 'climbing', 'mountains'],
    ),
    NamedIcon(
      icon: Icons.bike_scooter,
      name: 'Велоспорт',
      category: 'Навыки',
      tags: ['велосипед', 'езда', 'bike', 'cycling', 'bicycle'],
    ),
    NamedIcon(
      icon: Icons.sports_martial_arts,
      name: 'Боевые Искусства',
      category: 'Навыки',
      tags: ['каратэ', 'дзюдо', 'самбо', 'martial', 'karate'],
    ),
    NamedIcon(
      icon: Icons.psychology,
      name: 'Психология',
      category: 'Навыки',
      tags: ['ум', 'мышление', 'эмоции', 'psychology', 'mind'],
    ),
    NamedIcon(
      icon: Icons.menu_book,
      name: 'Чтение',
      category: 'Навыки',
      tags: ['книги', 'литература', 'читать', 'reading', 'book'],
    ),
    NamedIcon(
      icon: Icons.calculate,
      name: 'Математика',
      category: 'Навыки',
      tags: ['счёт', 'числа', 'логика', 'math', 'calculate'],
    ),
    NamedIcon(
      icon: Icons.language,
      name: 'Языки',
      category: 'Навыки',
      tags: ['иностранный', 'перевод', 'лингвистика', 'language', 'translate'],
    ),
    NamedIcon(
      icon: Icons.history_edu,
      name: 'История',
      category: 'Навыки',
      tags: ['прошлое', 'археология', 'past', 'history', 'ancient'],
    ),
    NamedIcon(
      icon: Icons.code,
      name: 'Программирование',
      category: 'Навыки',
      tags: ['код', 'разработка', 'алгоритм', 'programming', 'code'],
    ),
    NamedIcon(
      icon: Icons.piano,
      name: 'Музыка',
      category: 'Навыки',
      tags: ['игра', 'инструмент', 'ноты', 'music', 'piano'],
    ),
    NamedIcon(
      icon: Icons.palette,
      name: 'Искусство',
      category: 'Навыки',
      tags: ['рисование', 'творчество', 'живопись', 'art', 'drawing'],
    ),
    NamedIcon(
      icon: Icons.architecture,
      name: 'Архитектура',
      category: 'Навыки',
      tags: ['здания', 'дизайн', 'проект', 'architecture', 'design'],
    ),
    NamedIcon(
      icon: Icons.record_voice_over,
      name: 'Ораторское Мастерство',
      category: 'Навыки',
      tags: ['речь', 'выступление', 'убеждение', 'speech', 'orator'],
    ),
    NamedIcon(
      icon: Icons.people,
      name: 'Коммуникация',
      category: 'Навыки',
      tags: ['общение', 'друзья', 'социум', 'communication', 'social'],
    ),
    NamedIcon(
      icon: Icons.handshake,
      name: 'Переговоры',
      category: 'Навыки',
      tags: ['сделка', 'убеждение', 'бизнес', 'negotiation', 'deal'],
    ),
    NamedIcon(
      icon: Icons.emoji_people,
      name: 'Эмпатия',
      category: 'Навыки',
      tags: ['чувства', 'понимание', 'сочувствие', 'empathy', 'feelings'],
    ),
    NamedIcon(
      icon: Icons.group,
      name: 'Командная Работа',
      category: 'Навыки',
      tags: ['коллектив', 'сотрудничество', 'team', 'collaboration'],
    ),
    NamedIcon(
      icon: Icons.volunteer_activism,
      name: 'Волонтёрство',
      category: 'Навыки',
      tags: ['помощь', 'благотворительность', 'общество', 'volunteer', 'help'],
    ),
    NamedIcon(
      icon: Icons.computer,
      name: 'IT-Навыки',
      category: 'Навыки',
      tags: ['компьютер', 'технологии', 'tech', 'computer', 'it'],
    ),
    NamedIcon(
      icon: Icons.engineering,
      name: 'Инженерия',
      category: 'Навыки',
      tags: ['механика', 'конструкция', 'engineer', 'mechanics'],
    ),
    NamedIcon(
      icon: Icons.build,
      name: 'Ремонт',
      category: 'Навыки',
      tags: ['починка', 'мастер', 'инструмент', 'repair', 'fix'],
    ),

    // === ДОСТИЖЕНИЯ (Purports) ===
    NamedIcon(
      icon: Icons.emoji_events,
      name: 'Трофей',
      category: 'Достижения',
      tags: ['победа', 'чемпион', 'турнир', 'trophy', 'winner'],
    ),
    NamedIcon(
      icon: Icons.star,
      name: 'Звезда',
      category: 'Достижения',
      tags: ['успех', 'популярность', 'star', 'success'],
    ),
    NamedIcon(
      icon: Icons.workspace_premium,
      name: 'Премиум',
      category: 'Достижения',
      tags: ['элита', 'лучший', 'класс', 'premium', 'elite'],
    ),
    NamedIcon(
      icon: Icons.military_tech,
      name: 'Военная Медаль',
      category: 'Достижения',
      tags: ['награда', 'отвага', 'герой', 'medal', 'hero'],
    ),
    NamedIcon(
      icon: Icons.card_travel,
      name: 'Путешественник',
      category: 'Достижения',
      tags: ['поездки', 'карта', 'странник', 'travel', 'map'],
    ),
    NamedIcon(
      icon: Icons.badge,
      name: 'Значок',
      category: 'Достижения',
      tags: ['эмблема', 'символ', 'badge', 'emblem'],
    ),
    NamedIcon(
      icon: Icons.verified,
      name: 'Подтверждено',
      category: 'Достижения',
      tags: ['проверка', 'галочка', 'verified', 'check'],
    ),
    NamedIcon(
      icon: Icons.check_circle,
      name: 'Завершено',
      category: 'Достижения',
      tags: ['выполнено', 'готово', 'complete', 'done'],
    ),
    NamedIcon(
      icon: Icons.task_alt,
      name: 'Задача Выполнена',
      category: 'Достижения',
      tags: ['исполнено', 'сделано', 'task', 'complete'],
    ),
    NamedIcon(
      icon: Icons.done_all,
      name: 'Всё Сделано',
      category: 'Достижения',
      tags: ['все задачи', 'финал', 'all done', 'final'],
    ),
    NamedIcon(
      icon: Icons.flash_on,
      name: 'Вспышка',
      category: 'Достижения',
      tags: ['скорость', 'мгновение', 'flash', 'speed'],
    ),
    NamedIcon(
      icon: Icons.rocket_launch,
      name: 'Ракета',
      category: 'Достижения',
      tags: ['запуск', 'полёт', 'успех', 'rocket', 'launch'],
    ),
    NamedIcon(
      icon: Icons.diamond,
      name: 'Алмаз',
      category: 'Достижения',
      tags: ['драгоценность', 'редкость', 'diamond', 'rare'],
    ),
    NamedIcon(
      icon: Icons.forest,
      name: 'Исследователь',
      category: 'Достижения',
      tags: ['лес', 'природа', 'выживание', 'forest', 'explorer'],
    ),
    NamedIcon(
      icon: Icons.waves,
      name: 'Мореплаватель',
      category: 'Достижения',
      tags: ['море', 'океан', 'волны', 'waves', 'sailor'],
    ),
    NamedIcon(
      icon: Icons.volcano,
      name: 'Покоритель',
      category: 'Достижения',
      tags: ['вулкан', 'гора', 'сложный', 'volcano', 'conqueror'],
    ),
    NamedIcon(
      icon: Icons.snowboarding,
      name: 'Зимний',
      category: 'Достижения',
      tags: ['снег', 'зима', 'спорт', 'snow', 'winter'],
    ),
    NamedIcon(
      icon: Icons.looks_one,
      name: '1 Уровень',
      category: 'Достижения',
      tags: ['первый', 'начинающий', 'level 1', 'beginner'],
    ),
    NamedIcon(
      icon: Icons.looks_two,
      name: '2 Уровень',
      category: 'Достижения',
      tags: ['второй', 'ученик', 'level 2', 'novice'],
    ),
    NamedIcon(
      icon: Icons.looks_3,
      name: '3 Уровень',
      category: 'Достижения',
      tags: ['третий', 'опытный', 'level 3', 'experienced'],
    ),
    NamedIcon(
      icon: Icons.looks_4,
      name: '4 Уровень',
      category: 'Достижения',
      tags: ['четвёртый', 'эксперт', 'level 4', 'expert'],
    ),
    NamedIcon(
      icon: Icons.looks_5,
      name: '5 Уровень',
      category: 'Достижения',
      tags: ['пятый', 'мастер', 'level 5', 'master'],
    ),
    NamedIcon(
      icon: Icons.looks_6,
      name: '6 Уровень',
      category: 'Достижения',
      tags: ['шестой', 'легенда', 'level 6', 'legendary'],
    ),

    // === ПЕРСОНАЖ (Character) ===
    NamedIcon(
      icon: Icons.person,
      name: 'Персонаж',
      category: 'Персонаж',
      tags: ['человек', 'герой', 'character', 'person'],
    ),
    NamedIcon(
      icon: Icons.person_outline,
      name: 'Персонаж Контур',
      category: 'Персонаж',
      tags: ['силуэт', 'тень', 'outline', 'silhouette'],
    ),
    NamedIcon(
      icon: Icons.supervisor_account,
      name: 'Супергерой',
      category: 'Персонаж',
      tags: ['герой', 'спаситель', 'superhero', 'hero'],
    ),
    NamedIcon(
      icon: Icons.assistant,
      name: 'Помощник',
      category: 'Персонаж',
      tags: ['спутник', 'компаньон', 'assistant', 'companion'],
    ),
    NamedIcon(
      icon: Icons.account_circle,
      name: 'Аватар',
      category: 'Персонаж',
      tags: ['профиль', 'изображение', 'avatar', 'profile'],
    ),
    NamedIcon(
      icon: Icons.face,
      name: 'Лицо',
      category: 'Персонаж',
      tags: ['голова', 'портрет', 'face', 'portrait'],
    ),
    NamedIcon(
      icon: Icons.face_retouching_natural,
      name: 'Естественное Лицо',
      category: 'Персонаж',
      tags: ['красота', 'натуральный', 'natural', 'beauty'],
    ),
    NamedIcon(
      icon: Icons.emoji_people,
      name: 'Люди',
      category: 'Персонаж',
      tags: ['общество', 'население', 'people', 'society'],
    ),
    NamedIcon(
      icon: Icons.android,
      name: 'Робот',
      category: 'Персонаж',
      tags: ['механизм', 'киборг', 'robot', 'cyborg'],
    ),
    NamedIcon(
      icon: Icons.psychology_alt,
      name: 'Мозг',
      category: 'Персонаж',
      tags: ['интеллект', 'разум', 'brain', 'intellect'],
    ),
    NamedIcon(
      icon: Icons.auto_awesome,
      name: 'Волшебник',
      category: 'Персонаж',
      tags: ['магия', 'заклинания', 'wizard', 'magic'],
    ),
    NamedIcon(
      icon: Icons.sports_baseball,
      name: 'Бейсболист',
      category: 'Персонаж',
      tags: ['спорт', 'игра', 'baseball', 'sport'],
    ),
    NamedIcon(
      icon: Icons.sports_basketball,
      name: 'Баскетболист',
      category: 'Персонаж',
      tags: ['мяч', 'команда', 'basketball', 'team'],
    ),
    NamedIcon(
      icon: Icons.sports_football,
      name: 'Футболист',
      category: 'Персонаж',
      tags: ['американский футбол', 'football', 'sport'],
    ),
    NamedIcon(
      icon: Icons.sports_soccer,
      name: 'Футболист',
      category: 'Персонаж',
      tags: ['футбол', 'гол', 'soccer', 'goal'],
    ),
    NamedIcon(
      icon: Icons.sports_tennis,
      name: 'Теннисист',
      category: 'Персонаж',
      tags: ['ракетка', 'корд', 'tennis', 'racket'],
    ),
    NamedIcon(
      icon: Icons.sports_golf,
      name: 'Гольфист',
      category: 'Персонаж',
      tags: ['клюшка', 'поле', 'golf', 'club'],
    ),
    NamedIcon(
      icon: Icons.engineering,
      name: 'Инженер',
      category: 'Персонаж',
      tags: ['техника', 'механик', 'engineer', 'technical'],
    ),
    NamedIcon(
      icon: Icons.science,
      name: 'Учёный',
      category: 'Персонаж',
      tags: ['исследователь', 'наука', 'scientist', 'research'],
    ),
    NamedIcon(
      icon: Icons.health_and_safety,
      name: 'Врач',
      category: 'Персонаж',
      tags: ['медицина', 'доктор', 'doctor', 'medical'],
    ),
    NamedIcon(
      icon: Icons.school,
      name: 'Ученик',
      category: 'Персонаж',
      tags: ['студент', 'класс', 'student', 'class'],
    ),
    NamedIcon(
      icon: Icons.business_center,
      name: 'Бизнесмен',
      category: 'Персонаж',
      tags: ['работа', 'офис', 'businessman', 'office'],
    ),
    NamedIcon(
      icon: Icons.construction,
      name: 'Строитель',
      category: 'Персонаж',
      tags: ['строительство', 'рабочий', 'builder', 'worker'],
    ),
    NamedIcon(
      icon: Icons.pets,
      name: 'Питомец',
      category: 'Персонаж',
      tags: ['животное', 'друг', 'pet', 'animal'],
    ),
    NamedIcon(
      icon: Icons.catching_pokemon,
      name: 'Покемон',
      category: 'Персонаж',
      tags: ['монстр', 'поймать', 'pokemon', 'monster'],
    ),
    NamedIcon(
      icon: Icons.cruelty_free,
      name: 'Животное',
      category: 'Персонаж',
      tags: ['зверь', 'фауна', 'animal', 'fauna'],
    ),
  ];

  // Группировка по категориям
  static Map<String, List<NamedIcon>> get groupedByCategory {
    final map = <String, List<NamedIcon>>{};
    for (final icon in allIcons) {
      map.putIfAbsent(icon.category, () => []).add(icon);
    }
    return map;
  }

  // Получить список категорий
  static List<String> get categories => groupedByCategory.keys.toList();
}