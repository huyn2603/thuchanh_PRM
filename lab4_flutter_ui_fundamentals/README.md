# Lab 4 - Flutter UI Fundamentals

Project nay hoan thanh 5 exercise trong Lab 4:

1. Core Widgets: Text, Image, Icon, Card, ListTile.
2. Input Widgets: Slider, Switch, RadioListTile, DatePicker.
3. Layout Basics: Column, Row, Padding, SizedBox, ListView.builder.
4. App Structure: Scaffold, AppBar, Body, FloatingActionButton, ThemeData, Dark Mode.
5. Debug Fixes: Expanded for ListView, SingleChildScrollView for overflow, setState, valid DatePicker context.

## Chay tren Android simulator

Mo Android Studio:

1. Open folder: `D:\PRM_LAB\thuchanh_PRM\lab4_flutter_ui_fundamentals`
2. Mo Device Manager.
3. Start mot Android Virtual Device, vi du Pixel 6 API 35.
4. Chon emulator o thanh device.
5. Bam Run.

Chay bang terminal:

```powershell
cd D:\PRM_LAB\thuchanh_PRM\lab4_flutter_ui_fundamentals
flutter pub get
flutter devices
flutter run
```

Neu co nhieu device, dung:

```powershell
flutter run -d <device-id>
```

## Test

```powershell
cd D:\PRM_LAB\thuchanh_PRM\lab4_flutter_ui_fundamentals
flutter test
```

## File chinh

- `lib/main.dart`: man hinh menu va ThemeMode.
- `lib/core_widgets_demo.dart`: Exercise 1.
- `lib/input_controls_demo.dart`: Exercise 2.
- `lib/layout_basics_demo.dart`: Exercise 3.
- `lib/scaffold_theme_demo.dart`: Exercise 4.
- `lib/debug_fixes_demo.dart`: Exercise 5.
