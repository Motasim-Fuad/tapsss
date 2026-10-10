# Firebase / Play services registrars must survive R8 or initializeApp throws
# "FirebaseCrashlytics component is not present" and the app stays on the splash.
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class io.flutter.plugins.firebase.** { *; }
-keep class com.revenuecat.purchases.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
