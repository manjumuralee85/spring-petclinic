# Quick Reference: Java Migration Commands

## 🚀 GitHub Actions (Recommended)

### Run from GitHub UI
1. Go to: https://github.com/manjumuralee85/spring-petclinic/actions
2. Select: **Java Migration Automation**
3. Click: **Run workflow**
4. Choose your target version and run

---

## 💻 Local Migration (Using OpenRewrite)

### Prerequisites
```bash
# Ensure you have Maven
mvn --version

# Ensure Java 17+ is available (for running OpenRewrite)
java -version
```

### Java 8 → 11
```bash
# Run migration
mvn -U org.openrewrite.maven:rewrite-maven-plugin:5.40.0:run \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:2.25.0 \
  -Drewrite.activeRecipes=org.openrewrite.java.migrate.Java8toJava11

# Update Spring Boot
mvn -U org.openrewrite.maven:rewrite-maven-plugin:5.40.0:run \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-spring:5.20.0 \
  -Drewrite.activeRecipes=org.openrewrite.java.spring.boot2.UpgradeSpringBoot_2_7

# Test
mvn clean install
```

### Java 11 → 17
```bash
# Run migration
mvn -U org.openrewrite.maven:rewrite-maven-plugin:5.40.0:run \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:2.25.0 \
  -Drewrite.activeRecipes=org.openrewrite.java.migrate.UpgradeToJava17

# Update Spring Boot to 3.x
mvn -U org.openrewrite.maven:rewrite-maven-plugin:5.40.0:run \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-spring:5.20.0 \
  -Drewrite.activeRecipes=org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_2

# Test
mvn clean install
```

### Java 17 → 21
```bash
# Run migration
mvn -U org.openrewrite.maven:rewrite-maven-plugin:5.40.0:run \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:2.25.0 \
  -Drewrite.activeRecipes=org.openrewrite.java.migrate.UpgradeToJava21

# Update Spring Boot to latest
mvn -U org.openrewrite.maven:rewrite-maven-plugin:5.40.0:run \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-spring:5.20.0 \
  -Drewrite.activeRecipes=org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_3

# Test
mvn clean install
```

### Using Custom Recipes (if rewrite.yml is configured)
```bash
# Java 11 migration
mvn rewrite:run -Drewrite.activeRecipes=com.petclinic.JavaMigrationToJava11

# Java 17 migration
mvn rewrite:run -Drewrite.activeRecipes=com.petclinic.JavaMigrationToJava17

# Java 21 migration
mvn rewrite:run -Drewrite.activeRecipes=com.petclinic.JavaMigrationToJava21

# Complete migration (all at once)
mvn rewrite:run -Drewrite.activeRecipes=com.petclinic.JavaMigration
```

---

## 🔍 Preview Changes (Dry Run)

```bash
# See what would change without applying
mvn rewrite:dryRun -Drewrite.activeRecipes=org.openrewrite.java.migrate.Java8toJava11

# Review the diff
cat target/rewrite/rewrite.patch
```

---

## 🧪 Testing After Migration

```bash
# Clean build
mvn clean install

# Run tests
mvn test

# Run with specific Java version
JAVA_HOME=/path/to/java-11 mvn clean install

# Start application
mvn spring-boot:run

# Access application
open http://localhost:8080
```

---

## 🔧 Troubleshooting

### Check Current Java Version
```bash
java -version
mvn -version
```

### Switch Java Version (using SDKMAN)
```bash
# Install SDKMAN
curl -s "https://get.sdkman.io" | bash

# Install Java versions
sdk install java 11.0.22-tem
sdk install java 17.0.10-tem
sdk install java 21.0.2-tem

# Switch version
sdk use java 11.0.22-tem
```

### Clean Maven Cache
```bash
mvn dependency:purge-local-repository
mvn clean install -U
```

### Fix Common Issues
```bash
# Remove target and rebuild
rm -rf target
mvn clean install

# Skip tests temporarily
mvn clean install -DskipTests

# Update all dependencies
mvn versions:use-latest-releases
mvn versions:update-properties
```

---

## 📊 Check Migration Status

```bash
# List all OpenRewrite recipes
mvn rewrite:discover

# Show active recipes
mvn help:describe -Dplugin=org.openrewrite.maven:rewrite-maven-plugin

# Validate pom.xml
mvn validate
```

---

## 🎯 Common Recipes

### Security Updates
```bash
mvn rewrite:run -Drewrite.activeRecipes=com.petclinic.SecurityUpdates
```

### Code Modernization
```bash
mvn rewrite:run -Drewrite.activeRecipes=com.petclinic.CodeModernization
```

### Dependency Updates
```bash
mvn rewrite:run -Drewrite.activeRecipes=com.petclinic.DependencyUpgrade
```

---

## 📝 Git Workflow

```bash
# Create branch for migration
git checkout -b migration/java-17

# Stage changes
git add .

# Commit
git commit -m "Migrate to Java 17 with Spring Boot 3.2"

# Push
git push origin migration/java-17

# Create PR via GitHub CLI
gh pr create --title "Migrate to Java 17" --body "Automated migration"
```

---

## 🆘 Get Help

```bash
# OpenRewrite help
mvn rewrite:help

# Maven help
mvn help:help

# Check plugin configuration
mvn help:effective-pom
```

---

## 🔗 Useful Links

- OpenRewrite Docs: https://docs.openrewrite.org/
- Spring Boot 3 Migration: https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide
- GitHub Actions: https://github.com/manjumuralee85/spring-petclinic/actions

---

**Note**: Always test migrations thoroughly before deploying to production!
