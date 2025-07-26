# Super GE - توثيق مشروع فلاتر

## جدول المحتويات
1. [نظرة عامة على المشروع](#نظرة-عامة-على-المشروع)
2. [المميزات](#المميزات)
3. [هيكل المشروع](#هيكل-المشروع)
4. [الاعتماديات](#الاعتماديات)
5. [الإعداد والتشغيل](#الإعداد-والتشغيل)
6. [إعدادات Firebase](#إعدادات-firebase)
7. [هيكلة قاعدة البيانات (Firebase Firestore)](#هيكلة-قاعدة-البيانات-firebase-firestore)
8. [وحدات التحكم (Controllers)](#وحدات-التحكم-controllers)
9. [النماذج (Models)](#النماذج-models)
10. [الواجهات (Views)](#الواجهات-views)
11. [الويدجتس (Widgets)](#الويدجتس-widgets)

## نظرة عامة على المشروع
Super GE هو تطبيق محمول مبني باستخدام Flutter، مصمم لإدارة العملاء والمندوبين والإدخالات المالية. يوفر واجهات مختلفة للمسؤولين والمندو��ين، مما يسمح بتتبع فعال للتحصيلات والفواتير والملاحظات.

## المميزات
- مصادقة المستخدم (تسجيل الدخول للمسؤولين والمندوبين).
- يمكن للمسؤولين إدارة المندوبين (إضافة، عرض).
- يمكن للمسؤولين والمندوبين إدارة العملاء والإدخالات المالية.
- إنشاء تقارير بصيغة Excel و PDF.
- وظيفة تدوين الملاحظات.
- معالجة آمنة للبيانات باستخدام Firebase Cloud Firestore.

## هيكل المشروع
يتبع المشروع هيكلًا قياسيًا لتطبيقات Flutter، مع فصل المنطق الأساسي إلى `controllers`، `models`، `views`، و `widgets`.

```
lib/
├── controllers/
│   ├── add_new_client_entry_controller.dart
│   ├── add_new_collection_controller.dart
│   ├── add_new_entry_controller.dart
│   ├── add_new_mandob_controller.dart
│   ├── add_new_note_controller.dart
│   ├── admin_home_controller.dart
│   ├── all_mandob_controller.dart
│   ├── all_notes_controller.dart
│   ├── bills_controller.dart
│   ├── entries_controller.dart
│   ├── login_controller.dart
│   ├── main_controller.dart
│   └── mandob_home_controller.dart
├── core/
│   └── app_colors.dart
│   └── app_theme.dart
│   └── functions/
│   └── services/
├── models/
│   ├── collections_model.dart
│   ├── entries_model.dart
│   ├── note_model.dart
│   └── user_model.dart
├── views/
│   ├── add_new_client_entry.dart
│   ├── add_new_collection.dart
│   ├── add_new_entry.dart
│   ├── add_new_mandob.dart
│   ├── add_new_note.dart
│   ├── admin_home.dart
│   ├── all_mandob.dart
│   ├── all_notes.dart
│   ├── bills_view.dart
│   ├── entries_view.dart
│   ├── login_view.dart
│   └── mandob_home.dart
├── widgets/
│   └── entry_widget.dart
├── main.dart
└── firebase_options.dart
```

## الاعتماديات
يعتمد المشروع على عدة حزم خارجية لتوفير وظائفه.

### الاعتماديات الرئيسية
- `flutter`: الإطار الأساسي لبناء التطبيق.
- `get`: لإدارة ال��الة، حقن التبعية، وإدارة المسارات.
- `firebase_core`: للاتصال بمشروع Firebase.
- `cloud_firestore`: للتفاعل مع قاعدة بيانات Firestore.
- `url_launcher`: لفتح الروابط.
- `shared_preferences`: للتخزين المحلي.
- `share_plus`: لمشاركة المحتوى.
- `excel`: لإنشاء وإدارة ملفات Excel.
- `path_provider`: للعثور على المسار الصحيح للمجلدات المحلية.
- `pdf`: لإنشاء وإدارة مستندات PDF.
- `intl`: للتدويل والترجمة.
- `permission_handler`: للتعامل مع الأذونات وقت التشغيل.

### اعتماديات التطوير
- `flutter_lints`: للتحقق من جودة الكود.

## الإعداد والتشغيل
1. **نسخ المستودع:**
   ```bash
   git clone <repository-url>
   ```
2. **تثبيت الاعتماديات:**
   ```bash
   flutter pub get
   ```
3. **تشغيل التطبيق:**
   ```bash
   flutter run
   ```

## إعدادات Firebase
ال��شروع متكامل مع Firebase. ملف الإعدادات `firebase_options.dart` موجود في مجلد `lib/`. لكي يعمل التطبيق بشكل صحيح، تحتاج إلى إعداد مشروع Firebase الخاص بك ووضع ملف `google-services.json` (لنظام Android) و `GoogleService-Info.plist` (لنظام iOS) في المجلدات الخاصة بكل منصة.

## هيكلة قاعدة البيانات (Firebase Firestore)
يستخدم التطبيق قاعدة بيانات NoSQL من Firebase Firestore لتخزين جميع البيانات. الهيكل مصمم ليكون قابلاً للتطوير وفعالاً، وهو كالتالي:

### مجموعة `users`
تستخدم لتخزين معلومات المستخدمين (المدراء والمندوبين).
```json
{
  "name": "String",
  "phone": "String",
  "password": "String",
  "userType": "String ('admin' or 'mandob')"
}
```

### مجموعة `collections`
تستخدم لتخزين الأصناف أو التصنيفات المتاحة.
```json
{
  "name": "String",
  "start_sell_price": "Number",
  "end_sell_price": "Number",
  "gomlah_price": "Number",
  "quantity": "Number"
}
```

#### مجموعة فرعية `entries`
داخل كل مستند في `collections`، توجد مجموعة فرعية لتخزين الإدخالات المالية المتعلقة بهذا الصنف.
**المسار:** `/collections/{collectionId}/entries/{entryId}`
```json
{
  "client_name": "String",
  "phone_number": "String",
  "address": "String",
  "current_location": "String",
  "quantity": "Number",
  "price": "Number"
}
```

### مجموعة `notes`
تستخدم لتخزين الملاحظات المالية.
```json
{
  "name": "String",
  "amount": "String",
  "type": "String ('client' or 'mandob')"
}
```

### مجموعة `bills`
تستخدم لتخزين الفواتير التي يتم إنشاؤها.
```json
{
  "client_name": "String",
  "phone": "String",
  "address": "String",
  "current_location": "String",
  "mandob_name": "String",
  "total": "Number",
  "bill_date": "String (ISO 8601)",
  "timestamp": "Number",
  "collections": [
    {
      "id": "String",
      "name": "String",
      "quantity": "Number",
      "price": "Number",
      "subtotal": "Number"
    }
  ]
}
```

## وحدات التحكم (Controllers)
تدير وحدات التحكم حالة التطبيق ومنطق العمل. تم بناؤها باستخدام حزمة GetX.

- **`add_new_client_entry_controller.dart`**: يدير منطق إضافة إدخالات عميل جديدة وإنشاء الفواتير.
- **`add_new_collection_controller.dart`**: يتعامل مع إنشاء تصنيفات جديدة.
- **`add_new_entry_controller.dart`**: يدير إضافة إدخالات مالية جديدة لتصنيف معين.
- **`add_new_mandob_controller.dart`**: منطق إضافة مندوب جديد.
- **`add_new_note_controller.dart`**: يدير إنشاء ملاحظات جديدة.
- **`admin_home_controller.dart`**: وحدة التحكم لشاشة المسؤول الرئيسية، ويعالج عرض الأصناف والأرباح وتصدير البيانات.
- **`all_mandob_controller.dart`**: يدير قائمة جميع المندوبين.
- **`all_notes_controller.dart`**: يتعامل مع منطق عرض جميع الملاحظات.
- **`bills_controller.dart`**: يدير قسم الفواتير.
- **`entries_controller.dart`**: وحدة التحكم لإدارة الإدخالات المالية لتصنيف معين.
- **`login_controller.dart`**: يتعامل مع منطق مصادقة المستخدم.
- **`main_controller.dart`**: وحدة تحكم مركزية لتحديد الشاشة الأولى عند بدء التشغيل.
- **`mandob_home_controller.dart`**: وحدة التحكم لشاشة المندوب الرئيسية.

## النماذج (Models)
تحدد النماذج ب��ية البيانات للتطبيق.

- **`collections_model.dart`**: يمثل تصنيفًا أو صنفًا بأسعاره وكمياته.
- **`entries_model.dart`**: يمثل إدخالًا ماليًا لعميل معين.
- **`note_model.dart`**: يمثل ملاحظة.
- **`user_model.dart`**: يمثل مستخدم التطبيق (مدير أو مندوب).

## الواجهات (Views)
الواجهات هي شاشات التطبيق، وهي مسؤولة عن عرض واجهة المستخدم.

- **`add_new_client_entry.dart`**: شاشة لإضافة فاتورة جديدة كاملة.
- **`add_new_collection.dart`**: شاشة لإنشاء تصنيف جديد.
- **`add_new_entry.dart`**: شاشة لإضافة إدخال مالي واحد.
- **`add_new_mandob.dart`**: شاشة لإضافة مندوب جديد.
- **`add_new_note.dart`**: شاشة لإنشاء ملاحظة جديدة.
- **`admin_home.dart`**: لوحة التحكم الرئيسية للمسؤول.
- **`all_mandob.dart`**: تعرض قائمة بجميع المندوبين.
- **`all_notes.dart`**: تعرض جميع الملاحظات.
- **`bills_view.dart`**: شاشة لعرض جميع الفواتير المحفوظة.
- **`entries_view.dart`**: تعرض الإدخالات المالية لتصنيف معين.
- **`login_view.dart`**: شاشة تسجيل الدخول للمستخدمين.
- **`mandob_home.dart`**: لوحة التحكم الرئيسية للمندوب.

## الويدجتس (Widgets)
الويدجتس هي مكونات واجهة مستخدم قابلة لإعادة الاستخدام عبر شاشات مختلفة.

- **`entry_widget.dart`**: ويدجت لعرض تفاصيل إدخال مالي واحد في بطاقة.

---
*تم إنشاء هذا التوثيق وتحليله بواسطة مساعد ذكاء اصطناعي.*
