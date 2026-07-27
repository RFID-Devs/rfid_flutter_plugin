import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.rfid.rfid_flutter_android_example"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.rfid.rfid_flutter_android_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        getByName("debug") {
            val strFile = File("/release.jks")
            storeFile = file(strFile)
            storePassword = "123456"
            keyPassword = "123456"
            keyAlias = "uhf-serial-key"
        }
        create("release") {
            val strFile = File("/release.jks")
            storeFile = file(strFile)
            storePassword = "123456"
            keyPassword = "123456"
            keyAlias = "uhf-serial-key"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }

        debug {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }

    // 自定义 apk 名称：Flutter-RFID-Demo_v{version}_{debug_?}{yyyyMMdd}.apk
    applicationVariants.all {
        val variant = this
        outputs.all {
            val buildDate = SimpleDateFormat("yyyyMMdd", Locale.US).format(Date())
            val signingConfigName = if (variant.buildType.name == "debug") "debug_" else ""
            val output = this as com.android.build.gradle.internal.api.BaseVariantOutputImpl
            output.outputFileName = "Flutter-RFID-Demo_v${defaultConfig.versionName}_${signingConfigName}${buildDate}.apk"
        }
    }
}

flutter {
    source = "../.."
}
