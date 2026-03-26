buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Use the Android Gradle Plugin version compatible with your Flutter version
        // Check `flutter doctor -v` for the recommended version (often 7.3.0)
        classpath("com.android.tools.build:gradle:7.3.0")
        // Add the Google Services plugin for Firebase
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}