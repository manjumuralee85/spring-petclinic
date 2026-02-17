# Java Migration Guide for Spring PetClinic

This guide explains how to use the automated Java migration workflow for your Spring PetClinic application.

## 🎯 Overview

The automated workflow migrates your application through the following Java versions:
- **Java 8 → 11**: Base migration with Spring Boot 2.7
- **Java 11 → 17**: Migration with Spring Boot 3.2 upgrade
- **Java 17 → 21**: Latest LTS with Spring Boot 3.3
- **Java 21 → 25**: Experimental (applies Java 21 recipes)

## 📋 Prerequisites

1. Your repository: `https://github.com/manjumuralee85/spring-petclinic`
2. GitHub Actions enabled in your repository
3. Sufficient permissions to create branches and pull requests

## 🚀 How to Run the Migration

### Option 1: Single-Step Migration (Recommended for Testing)

Migrate to a specific Java version in one step:

1. Go to your repository on GitHub
2. Navigate to **Actions** tab
3. Click on **Java Migration Automation** workflow
4. Click **Run workflow** button
5. Select options:
   - **Migration Strategy**: Choose `single-step`
   - **Target Java Version**: Choose your target (11, 17, 21, or 25)
6. Click **Run workflow**

### Option 2: Sequential Migration (Complete Path)

For a complete migration through all versions:

1. Go to **Actions** → **Java Migration Automation**
2. Click **Run workflow**
3. Select:
   - **Migration Strategy**: Choose `sequential-all`
4. Click **Run workflow**

This will create separate branches and PRs for each Java version.

## 📁 Files to Upload to Your Repository

Upload these files to your `spring-petclinic` repository:

### 1. GitHub Workflow File
```
.github/workflows/java-migration.yml
```

### 2. OpenRewrite Configuration
```
rewrite.yml
```
(Place this in the root of your repository)

### 3. Optional: Custom Maven Profile

Add this to your `pom.xml` in the `<profiles>` section:

```xml
<profile>
    <id>openrewrite</id>
    <build>
        <plugins>
            <plugin>
                <groupId>org.openrewrite.maven</groupId>
                <artifactId>rewrite-maven-plugin</artifactId>
                <version>5.40.0</version>
                <configuration>
                    <activeRecipes>
                        <recipe>com.petclinic.JavaMigration</recipe>
                    </activeRecipes>
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>org.openrewrite.recipe</groupId>
                        <artifactId>rewrite-migrate-java</artifactId>
                        <version>2.25.0</version>
                    </dependency>
                    <dependency>
                        <groupId>org.openrewrite.recipe</groupId>
                        <artifactId>rewrite-spring</artifactId>
                        <version>5.20.0</version>
                    </dependency>
                </dependencies>
            </plugin>
        </plugins>
    </build>
</profile>
```

## 🔍 What the Workflow Does

For each migration target, the workflow:

1. ✅ Checks out your repository
2. ✅ Sets up the correct JDK versions
3. ✅ Runs OpenRewrite migration recipes:
   - Updates Java version in `pom.xml`
   - Migrates code to use new APIs
   - Removes deprecated API usage
   - Updates Spring Boot version
   - Updates all compatible dependencies
4. ✅ Attempts to build the project
5. ✅ Runs tests
6. ✅ Creates a detailed migration report
7. ✅ Commits changes to a new branch
8. ✅ Opens a Pull Request with all changes

## 📊 Migration Paths

### Java 8 → 11
- **Spring Boot**: 1.5.x/2.x → 2.7.x
- **Key Changes**: 
  - JAXB dependencies added
  - Removed deprecated APIs
  - Updated to use newer collection APIs

### Java 11 → 17
- **Spring Boot**: 2.7.x → 3.2.x
- **Key Changes**:
  - javax.* → jakarta.* migration
  - Spring Boot 3 compatibility
  - Updated security configurations

### Java 17 → 21
- **Spring Boot**: 3.2.x → 3.3.x
- **Key Changes**:
  - Virtual threads support
  - Pattern matching enhancements
  - Record pattern support
  - Latest Spring Boot features

### Java 21 → 25
- **Spring Boot**: 3.3.x (latest)
- **Note**: Java 25 is experimental. The workflow applies Java 21 recipes and manually updates version numbers.

## 🧪 Testing After Migration

After the PR is created:

1. **Review the changes** in the Pull Request
2. **Checkout the branch locally**:
   ```bash
   git fetch origin
   git checkout migration/java-<version>-<timestamp>
   ```

3. **Build the project**:
   ```bash
   ./mvnw clean install
   ```

4. **Run tests**:
   ```bash
   ./mvnw test
   ```

5. **Start the application**:
   ```bash
   ./mvnw spring-boot:run
   ```

6. **Verify functionality**:
   - Open http://localhost:8080
   - Test all features of PetClinic
   - Check for any console errors

## 🔧 Manual Steps After Migration

Some things may need manual attention:

### For Java 11 Migration:
- Review JAXB dependencies if you use XML processing
- Check for any JEE modules usage

### For Java 17 Migration:
- Update any custom `javax.*` imports to `jakarta.*`
- Review security configurations for Spring Security 6
- Check application.properties for deprecated properties

### For Java 21 Migration:
- Consider using virtual threads for I/O operations
- Review opportunities for pattern matching
- Update to use records where appropriate

## 📝 OpenRewrite Recipes Used

The workflow uses these OpenRewrite recipes:

### Core Java Migration:
- `org.openrewrite.java.migrate.Java8toJava11`
- `org.openrewrite.java.migrate.UpgradeToJava17`
- `org.openrewrite.java.migrate.UpgradeToJava21`

### Spring Boot Migration:
- `org.openrewrite.java.spring.boot2.UpgradeSpringBoot_2_7`
- `org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_2`
- `org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_3`

### Additional Recipes:
- `org.openrewrite.java.migrate.javax.JavaxMigrationToJakarta`
- `org.openrewrite.java.security.SecureTempFileCreation`
- `org.openrewrite.staticanalysis.CommonStaticAnalysis`

## 🐛 Troubleshooting

### Workflow fails during build
- Check the workflow logs in GitHub Actions
- Some compilation errors may need manual fixes
- Review the generated PR for specific error messages

### Tests fail after migration
- Some tests may need updates for new Spring Boot versions
- Check test configurations and dependencies
- Review deprecation warnings

### Application doesn't start
- Check application.properties for deprecated properties
- Verify all dependencies are compatible
- Review Spring Boot migration guide for your specific version

## 📚 Additional Resources

- [OpenRewrite Documentation](https://docs.openrewrite.org/)
- [Spring Boot Migration Guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide)
- [Java 17 Migration Guide](https://docs.oracle.com/en/java/javase/17/migrate/getting-started.html)
- [Java 21 Migration Guide](https://docs.oracle.com/en/java/javase/21/migrate/getting-started.html)

## 🤝 Support

If you encounter issues:

1. Check the workflow run logs in GitHub Actions
2. Review the MIGRATION_REPORT.md in the PR
3. Check OpenRewrite documentation for specific recipes
4. Create an issue in your repository with details

## ⚡ Quick Command Reference

```bash
# Run migration locally (requires OpenRewrite plugin in pom.xml)
./mvnw rewrite:run -Drewrite.activeRecipes=com.petclinic.JavaMigrationToJava11

# Dry run to see what would change
./mvnw rewrite:dryRun -Drewrite.activeRecipes=com.petclinic.JavaMigrationToJava11

# Check current Java version
java -version

# Build with specific Java version
JAVA_HOME=/path/to/java-11 ./mvnw clean install
```

## 📌 Best Practices

1. **Test incrementally**: Migrate one version at a time
2. **Review changes**: Don't blindly merge automated PRs
3. **Keep backups**: Ensure your main branch is protected
4. **Run full tests**: Execute integration tests after migration
5. **Check dependencies**: Verify all third-party libraries are compatible
6. **Update documentation**: Document any manual changes needed

---

**Ready to migrate?** Head to the Actions tab and start your migration journey! 🚀
