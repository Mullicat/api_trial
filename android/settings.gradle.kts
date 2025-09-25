//android/settings.gradle.kts

// Configure plugin management for the project
pluginManagement {
    // Read Flutter SDK path from local.properties
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        // Ensure flutter.sdk is defined, else throw an error
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    // Include Flutter’s Gradle build script for plugin and build logic
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    // Define repositories for resolving plugins
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Apply necessary Gradle plugins with specified versions
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

// Include the app module in the build
include(":app")
