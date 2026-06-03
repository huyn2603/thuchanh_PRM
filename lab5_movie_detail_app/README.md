# Lab 5 - Building a Movie Detail App With Navigation

Project nay thuc hien yeu cau Lab 5:

1. Home Screen hien thi danh sach phim bang `ListView.builder`.
2. Movie Detail Screen hien thi poster Hero banner, gradient, title, genre chips, overview, action buttons va trailer list.
3. Navigation dung `Navigator.push` + `MaterialPageRoute`.
4. Truyen truc tiep `Movie` object tu Home sang Detail.
5. Co state cho Favorite toggle, rating dialog va search bar.

## Cach chay

```powershell
cd D:\PRM_LAB\thuchanh_PRM\lab5_movie_detail_app
flutter pub get
flutter run
```

Neu co nhieu emulator/device:

```powershell
flutter devices
flutter run -d <device-id>
```

## Test

```powershell
cd D:\PRM_LAB\thuchanh_PRM\lab5_movie_detail_app
flutter analyze
flutter test
```

## File chinh

- `lib/main.dart`: cau hinh app va theme.
- `lib/models/movie.dart`: `Movie` va `Trailer` model.
- `lib/data/sample_data.dart`: du lieu phim mau.
- `lib/screens/home_screen.dart`: danh sach phim, search, navigation.
- `lib/screens/movie_detail_screen.dart`: UI chi tiet phim va state Favorite/Rate/Share.
