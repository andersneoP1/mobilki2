import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/main.dart';

void main() {
  testWidgets('NotesApp smoke test', (WidgetTester tester) async {
    // Построение виджета приложения
    await tester.pumpWidget(const NotesApp());

    // Проверка наличия заголовка 'Заметки'
    expect(find.text('Заметки'), findsOneWidget);

    // Проверка наличия поля ввода с подсказкой
    expect(find.text('Введите текст заметки'), findsOneWidget);

    // Проверка наличия кнопки 'Сохранить'
    expect(find.text('Сохранить'), findsOneWidget);
  });
}
