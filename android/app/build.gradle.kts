plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Für Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.praisetogod.app.dev" // Basis-Namespace
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Basiswerte
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

//    // 🔀 Flavors definieren
//    flavorDimensions += "env"
//    productFlavors {
//        create("dev") {
//            dimension = "env"
//            applicationId = "com.praisetogod.app.dev"
//            versionNameSuffix = "-dev"
//        }
//    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // TODO: Für Release anpassen
        }
    }
}

flutter {
    source = "../.."
}

tasks.withType<JavaCompile> {
    options.compilerArgs.add("-Xlint:deprecation")
}
