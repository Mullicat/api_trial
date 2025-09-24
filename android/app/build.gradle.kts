// android/app/build.gradle.kts
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.api_trial"
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
        applicationId = "com.example.api_trial"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with debug for now so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.mlkit:text-recognition-chinese:16.0.0")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")
    implementation("com.google.mlkit:text-recognition-japanese:16.0.0")
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")
}

/**
 * Make Flutter happy by copying the produced APK(s) to where the Flutter tool looks:
 *   <project_root>/build/app/outputs/flutter-apk/app-<variant>.apk
 *
 * We hook into `packageDebug`/`packageRelease` (the tasks that write the APK).
 */
val flutterRootBuild = rootDir.parentFile.resolve("build/app/outputs/flutter-apk")

fun registerFlutterApkSyncTask(variant: String): String {
    val taskName = "syncFlutterApk${variant.replaceFirstChar { it.uppercase() }}"
    tasks.register<Copy>(taskName) {
        group = "flutter"
        description = "Copy $variant APK to Flutter’s expected location"
        // The AGP output folder for APKs
        from(layout.projectDirectory.dir("build/outputs/apk/$variant"))
        include("*.apk")
        into(flutterRootBuild)
        // Rename to exactly what Flutter expects
        rename { "app-$variant.apk" }
        doFirst {
            println(">> [syncFlutterApk] ensuring ${flutterRootBuild.absolutePath}")
            flutterRootBuild.mkdirs()
        }
        doLast {
            println(">> [syncFlutterApk] copied APK(s) for $variant to ${flutterRootBuild.absolutePath}")
        }
    }
    return taskName
}

val syncDebugTask = registerFlutterApkSyncTask("debug")
val syncReleaseTask = registerFlutterApkSyncTask("release")

// Wire the copy to the tasks that actually produce the APK
// (package* is the writer; assemble* may not always run in some flows)
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