// android/app/build.gradle.kts

// Apply required plugins for Android, Kotlin, and Flutter integration
plugins {
    // Enables Android application build features
    id("com.android.application")
    // Adds Kotlin support for Android
    id("kotlin-android")
    // Flutter Gradle plugin for integrating Flutter with Android; must be applied last
    id("dev.flutter.flutter-gradle-plugin")
}

// Configure Android-specific build settings
android {
    // Define the app's unique namespace for Android resources and manifests
    namespace = "com.example.api_trial"
    // Set compileSdk & NDK version to Flutter's default 
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Configure Java/Kotlin compilation to use Java 11 for compatibility
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    // Set JVM target for Kotlin compilation to Java 11
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Define default app configuration (version, SDK targets, etc.)
    defaultConfig {
        applicationId = "com.example.api_trial"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // App version code for Play Store versioning
        versionCode = flutter.versionCode
        // App version name for display
        versionName = flutter.versionName
    }

    // Configure build types (debug and release)
    buildTypes {
        release {
            // Signing with debug for now so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// Configure Flutter integration
flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.mlkit:text-recognition-chinese:16.0.0")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")
    implementation("com.google.mlkit:text-recognition-japanese:16.0.0")
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")
}

// Define the directory where Flutter expects APK outputs
val flutterRootBuild = rootDir.parentFile.resolve("build/app/outputs/flutter-apk")

// Function to register a task that copies APKs to Flutter’s expected location
fun registerFlutterApkSyncTask(variant: String): String {
    val taskName = "syncFlutterApk${variant.replaceFirstChar { it.uppercase() }}"

    // Register a Copy task to move APKs
    tasks.register<Copy>(taskName) {
        group = "flutter"
        description = "Copy $variant APK to Flutter’s expected location"

        // The AGP output folder for APKs
        from(layout.projectDirectory.dir("build/outputs/apk/$variant"))
        include("*.apk")
        into(flutterRootBuild)

        // Rename to exactly what Flutter expects
        rename { "app-$variant.apk" }
        // Ensure the destination directory exists before copying
        doFirst {
            println(">> [syncFlutterApk] ensuring ${flutterRootBuild.absolutePath}")
            flutterRootBuild.mkdirs()
        }
        // Log completion of the copy operation
        doLast {
            println(">> [syncFlutterApk] copied APK(s) for $variant to ${flutterRootBuild.absolutePath}")
        }
    }
    return taskName
}

// Register copy tasks for debug and release APKs
val syncDebugTask = registerFlutterApkSyncTask("debug")
val syncReleaseTask = registerFlutterApkSyncTask("release")

// Hook the copy tasks to run after APK generation tasks
listOf("packageDebug", "assembleDebug").forEach { t ->
    tasks.matching { it.name == t }.configureEach {
        finalizedBy(syncDebugTask)
    }
}

listOf("packageRelease", "assembleRelease").forEach { t ->
    tasks.matching { it.name == t }.configureEach {
        finalizedBy(syncReleaseTask)
    }
}

// For safety, if Gradle adds tasks later, hook them too.
tasks.whenTaskAdded {
    if (name == "packageDebug") finalizedBy(syncDebugTask)
    if (name == "packageRelease") finalizedBy(syncReleaseTask)
}