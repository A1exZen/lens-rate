# ML Kit text recognition: the Flutter plugin references non-Latin script
# recognizer classes (Chinese, Japanese, Korean, Devanagari) that are not
# bundled when using Latin-only recognition. Tell R8 to ignore them.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-keep class com.google.mlkit.vision.text.latin.** { *; }
