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
        colorSchemeSeed: Colors.indigo,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Текстовое поле с TextEditingController и подсказкой из лекции
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Введите текст заметки',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt_outlined),
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
                      icon: Icon(
                        _editingIndex == null ? Icons.save : Icons.check,
                      ),
                      label: Text(
                        _editingIndex == null ? 'Сохранить' : 'Обновить',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Кнопка отмены редактирования (активна только в режиме редактирования)
                  if (_editingIndex != null) ...[
                    const SizedBox(width: 8.0),
                    OutlinedButton.icon(
                      onPressed: _cancelEditing,
                      icon: const Icon(Icons.close),
                      label: const Text('Отмена'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1.0),

        // Прокручиваемый список заметок (ListView.builder, обернутый в Expanded)
        Expanded(
          child: _notes.isEmpty
              ? const Center(
                  child: Text(
                    'Список пуст. Добавьте первую заметку!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                  ),
                )
              : ListView.builder(
                  // Явно указанные изученные в лекции параметры
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final bool isCurrentEditing = _editingIndex == index;

                    return Card(
                      elevation: isCurrentEditing ? 4.0 : 1.0,
                      color: isCurrentEditing
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: ListTile(
                        // Нумерация заметки
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        // Текст заметки
                        title: Text(
                          _notes[index],
                          style: TextStyle(
                            fontWeight: isCurrentEditing
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        // Кнопки редактирования и удаления в конце элемента
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Кнопка редактирования заметки (Оценка 5)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Редактировать',
                              onPressed: () => _startEditing(index),
                            ),
                            // Кнопка удаления заметки (Оценка 5)
                            IconButton(
                              icon: const Icon(Icons.delete),
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
