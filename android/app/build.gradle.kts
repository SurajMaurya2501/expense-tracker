import java.util.Properties

// Release signing key. Create android/key.properties (never commit it) with:
//   storePassword=...
//   keyPassword=...
//   keyAlias=upload
//   storeFile=C:/path/to/upload-keystore.jks
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val hasReleaseKey = keystoreProperties.containsKey("storeFile")

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.nextgen.spend_wise"
    // flutter_local_notifications requires compileSdk 37 or higher.
    compileSdk = maxOf(flutter.compileSdkVersion, 37)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required by flutter_local_notifications for scheduled notifications.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // kotlinOptions {
    //     jvmTarget = JavaVersion.VERSION_17.toString()
    // }

    defaultConfig {
        applicationId = "com.nextgen.spend_wise"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseKey) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Play Store uploads need the upload key. Without key.properties,
            // release builds fall back to the debug key for local testing only.
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:35.1.0"))

  // Core library desugaring for flutter_local_notifications.
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

}