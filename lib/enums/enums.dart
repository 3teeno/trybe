/*
Available commands:

flutter run --flavor dev -t lib/main.dart
flutter run --flavor prod -t lib/main_prod.dart
 */

enum Flavor {dev, prod}

enum Privacy { public, private,unlisted }

enum SaveTo { trybelist, favorites,trybegroup }

enum SelectAudience { forkids,notforkids }

enum Gender { male,female }
enum Status { living,deceased }
enum CreativeJournal{ creativejournal}
enum TrybeGroup {select,unselect}