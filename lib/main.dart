import 'package:flutter/material.dart';

/// Точка входа в приложение
void main() {
  runApp(const NotesApp());
}

/// Корневой виджет приложения «Заметки»
class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Современная гармоничная цветовая гамма на базе индиго с мягким светлым фоном
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Заметки'),
          centerTitle: true,
        ),
        body: const NotesWidget(),
      ),
    );
  }
}

/// Основной виджет с состоянием для управления списком заметок
class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

/// Класс состояния для [NotesWidget]
class _NotesWidgetState extends State<NotesWidget> {
  /// Контроллер для управления текстовым полем TextField
  final TextEditingController _controller = TextEditingController();

  /// Список заметок, хранящийся в оперативной памяти
  final List<String> _notes = [];

  /// Индекс заметки, находящейся в режиме редактирования (null, если режим создания новой заметки)
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    // Добавление слушателя изменений текста по материалам лекции
    _controller.addListener(_onTextChanged);
  }

  /// Метод-слушатель изменений в контроллере текстового поля
  void _onTextChanged() {
    // Демонстрация работы слушателя: логирование каждого введенного символа в отладочную консоль
    debugPrint('Текущий текст в поле ввода: ${_controller.text}');
  }

  @override
  void dispose() {
    // В соответствии с материалами лекции: обязательно снимаем слушатель и освобождаем контроллер
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Метод сохранения новой заметки или обновления существующей
  void _saveOrUpdateNote() {
    final String text = _controller.text.trim();

    // Проверка на пустое значение (не добавляем пустые строки)
    if (text.isEmpty) {
      return;
    }

    setState(() {
      if (_editingIndex == null) {
        // Режим добавления новой заметки (Оценка 4)
        _notes.add(text);
      } else {
        // Режим обновления существующей заметки (Оценка 5)
        _notes[_editingIndex!] = text;
        _editingIndex = null;
      }
      // Очистка поля ввода после успешного сохранения или обновления
      _controller.clear();
    });
  }

  /// Метод перехода в режим редактирования выбранной заметки (Оценка 5)
  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      // Программная установка текста в поле ввода в соответствии с материалом лекции
      _controller.text = _notes[index];
    });
  }

  /// Метод отмены режима редактирования
  void _cancelEditing() {
    setState(() {
      _editingIndex = null;
      _controller.clear();
    });
  }

  /// Метод удаления заметки по индексу (Оценка 5)
  void _deleteNote(int index) {
    setState(() {
      // Если удаляется элемент, который сейчас редактируется, сбрасываем режим и очищаем поле
      if (_editingIndex == index) {
        _editingIndex = null;
        _controller.clear();
      } else if (_editingIndex != null && _editingIndex! > index) {
        // Корректируем индекс редактирования, если удалена заметка выше по списку
        _editingIndex = _editingIndex! - 1;
      }

      // Удаление заметки из списка в ОЗУ
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Блок ввода текста и кнопок управления
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12.0,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Текстовое поле с TextEditingController и подсказкой из лекции
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Введите текст заметки',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                    prefixIcon: const Icon(
                      Icons.note_alt_outlined,
                      color: Color(0xFF6366F1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF4F46E5),
                        width: 1.8,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _saveOrUpdateNote(),
                ),
                const SizedBox(height: 12.0),

                // Строка с кнопками действий
                Row(
                  children: [
                    // Кнопка сохранения/обновления заметки
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveOrUpdateNote,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        icon: Icon(
                          _editingIndex == null
                              ? Icons.add_circle_outline
                              : Icons.check_circle_outline,
                          size: 20.0,
                        ),
                        label: Text(
                          _editingIndex == null ? 'Сохранить' : 'Обновить',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),

                    // Кнопка отмены редактирования (активна только в режиме редактирования)
                    if (_editingIndex != null) ...[
                      const SizedBox(width: 10.0),
                      OutlinedButton.icon(
                        onPressed: _cancelEditing,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 16.0,
                          ),
                          foregroundColor: const Color(0xFF64748B),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded, size: 18.0),
                        label: const Text(
                          'Отмена',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        // Прокручиваемый список заметок (ListView.builder, обернутый в Expanded)
        Expanded(
          child: _notes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEEF2FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.sticky_note_2_outlined,
                            size: 48.0,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Список пуст. Добавьте первую заметку!',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  // Явно указанные изученные в лекции параметры
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  itemCount: _notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final bool isCurrentEditing = _editingIndex == index;

                    return Card(
                      elevation: isCurrentEditing ? 2.0 : 0.0,
                      color: isCurrentEditing
                          ? const Color(0xFFEEF2FF)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                          color: isCurrentEditing
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFE2E8F0),
                          width: isCurrentEditing ? 1.5 : 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 4.0,
                        ),
                        // Нумерация заметки в виде аккуратной аватарки
                        leading: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: isCurrentEditing
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFFEEF2FF),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCurrentEditing
                                  ? Colors.white
                                  : const Color(0xFF4F46E5),
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        // Текст заметки
                        title: Text(
                          _notes[index],
                          style: TextStyle(
                            color: const Color(0xFF1E293B),
                            fontSize: 15.0,
                            fontWeight: isCurrentEditing
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        // Кнопки редактирования и удаления в конце элемента
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Кнопка редактирования заметки (Оценка 5)
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              color: const Color(0xFF4F46E5),
                              tooltip: 'Редактировать',
                              onPressed: () => _startEditing(index),
                            ),
                            // Кнопка удаления заметки (Оценка 5)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded),
                              color: const Color(0xFFEF4444),
                              tooltip: 'Удалить',
                              onPressed: () => _deleteNote(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

