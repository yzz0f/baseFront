# Plantilla Java / Kotlin

Copiar al `build.gradle.kts` del proyecto (o adaptar a Maven con `spotless-maven-plugin`).

## Gradle (Kotlin DSL)

```kotlin
plugins {
    java // o kotlin("jvm") version "2.0.21"
    id("com.diffplug.spotless") version "6.25.0"
    id("net.ltgt.errorprone") version "4.1.0"     // sólo Java
    id("io.gitlab.arturbosch.detekt") version "1.23.7" // sólo Kotlin
    jacoco
}

java { toolchain { languageVersion = JavaLanguageVersion.of(21) } }

spotless {
    java {
        target("src/**/*.java")
        googleJavaFormat("1.24.0")
        removeUnusedImports()
        formatAnnotations()
    }
    kotlin {
        target("src/**/*.kt")
        ktlint("1.4.1")
    }
    kotlinGradle { ktlint("1.4.1") }
}

dependencies {
    errorprone("com.google.errorprone:error_prone_core:2.36.0")
    errorprone("com.uber.nullaway:nullaway:0.12.1")
    compileOnly("org.jspecify:jspecify:1.0.0")

    testImplementation(platform("org.junit:junit-bom:5.11.3"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testImplementation("org.assertj:assertj-core:3.26.3")
    testImplementation("org.mockito:mockito-junit-jupiter:5.14.2")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<JavaCompile>().configureEach {
    options.errorprone {
        disableWarningsInGeneratedCode = true
        option("NullAway:AnnotatedPackages", "com.acme")
        error("NullAway")
    }
}

tasks.test {
    useJUnitPlatform()
    finalizedBy(tasks.jacocoTestReport)
}

tasks.jacocoTestCoverageVerification {
    violationRules { rule { limit { minimum = "0.80".toBigDecimal() } } }
}
tasks.check { dependsOn(tasks.jacocoTestCoverageVerification) }
```

## Maven (fragmento de `pom.xml`)

```xml
<plugin>
  <groupId>com.diffplug.spotless</groupId>
  <artifactId>spotless-maven-plugin</artifactId>
  <version>2.43.0</version>
  <configuration>
    <java>
      <googleJavaFormat><version>1.24.0</version></googleJavaFormat>
      <removeUnusedImports/>
    </java>
    <kotlin><ktlint><version>1.4.1</version></ktlint></kotlin>
  </configuration>
  <executions>
    <execution><goals><goal>check</goal></goals><phase>verify</phase></execution>
  </executions>
</plugin>
```

## Version catalog (`gradle/libs.versions.toml`)

Declarar todas las versiones acá; los módulos referencian `libs.xxx`. Sin rangos ni `+`.

## `.editorconfig`

El de la raíz del harness ya define 4 espacios para `.java`/`.kt`. ktlint lo respeta.
