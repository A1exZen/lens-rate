# ML Kit text recognition. Keep everything: ML Kit relies on reflection and
# runtime component discovery, so partial keeps let R8 strip internals and the
# recognizer NPEs at init. (Minify is disabled in build.gradle.kts; these rules
# only matter if shrinking is ever re-enabled.)
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text.** { *; }
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
