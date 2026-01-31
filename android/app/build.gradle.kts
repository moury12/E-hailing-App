import java.util.Properties

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        load(keystorePropertiesFile.inputStream())
    }
}

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.dudu.android.app"
    compileSdk = 36
//    ndkVersion = "26.1.10909125"
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.dudu.android.app"
        minSdk = 24
        targetSdk = 36 // or flutter.targetSdkVersion
        versionCode = 12 // or flutter.versionCode
        versionName = "1.1.3" // or flutter.versionName
        multiDexEnabled = true  // Add this

        manifestPlaceholders["MAPS_API_KEY"] = keystoreProperties.getProperty("MAPS_API_KEY") ?: ""
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"]?.toString()

            //keyAlias = keystoreProperties["keyAlias"] as String
           // keyPassword = keystoreProperties["keyPassword"] as String
            keyPassword = keystoreProperties["keyPassword"]?.toString()

            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            //storePassword = keystoreProperties["storePassword"] as String
            storePassword = keystoreProperties["storePassword"]?.toString()
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
dependencies {
    implementation("androidx.core:core-ktx:1.16.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
