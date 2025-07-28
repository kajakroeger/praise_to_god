plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.praisetogod.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    flavorDimensions += listOf("env")

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationId = "com.praisetogod.app.dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "PraiseToGod Dev")
            manifestPlaceholders["appLabel"] = "PraiseToGod Dev"
        }
        create("prod") {
            dimension = "env"
            applicationId = "com.praisetogod.app.prod"
            manifestPlaceholders["appLabel"] = "PraiseToGod"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Für Release ggf. ändern
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

tasks.withType<JavaCompile> {
    options.compilerArgs.add("-Xlint:deprecation")
}