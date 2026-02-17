#!/bin/bash

###############################################################################
# Spring PetClinic Java Migration Setup Script
# This script helps set up the automated Java migration workflow
###############################################################################

set -e

echo "=========================================="
echo "Spring PetClinic Migration Setup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    echo "Please run this script from the root of your spring-petclinic repository"
    exit 1
fi

echo -e "${GREEN}✓${NC} Git repository detected"

# Check if this is the spring-petclinic repository
if ! git remote -v | grep -q "spring-petclinic"; then
    echo -e "${YELLOW}Warning: This doesn't appear to be the spring-petclinic repository${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create .github/workflows directory if it doesn't exist
echo ""
echo "Setting up workflow directory..."
mkdir -p .github/workflows
echo -e "${GREEN}✓${NC} .github/workflows directory ready"

# Copy workflow file
echo ""
echo "Would you like to:"
echo "1) Copy the workflow file from a local path"
echo "2) Skip (I'll add it manually)"
read -p "Choose option (1/2): " option

if [ "$option" = "1" ]; then
    read -p "Enter path to java-migration.yml: " workflow_path
    if [ -f "$workflow_path" ]; then
        cp "$workflow_path" .github/workflows/java-migration.yml
        echo -e "${GREEN}✓${NC} Workflow file copied"
    else
        echo -e "${RED}Error: File not found${NC}"
        exit 1
    fi
fi

# Copy rewrite.yml
echo ""
read -p "Enter path to rewrite.yml (or press enter to skip): " rewrite_path
if [ -n "$rewrite_path" ] && [ -f "$rewrite_path" ]; then
    cp "$rewrite_path" rewrite.yml
    echo -e "${GREEN}✓${NC} OpenRewrite configuration copied"
fi

# Add .gitignore entries for OpenRewrite
echo ""
echo "Updating .gitignore..."
if [ ! -f ".gitignore" ]; then
    touch .gitignore
fi

# Check if entries already exist
if ! grep -q ".rewrite" .gitignore; then
    cat >> .gitignore << 'EOF'

# OpenRewrite
.rewrite/
rewrite.patch

EOF
    echo -e "${GREEN}✓${NC} .gitignore updated"
else
    echo -e "${YELLOW}✓${NC} .gitignore already contains OpenRewrite entries"
fi

# Optionally add OpenRewrite plugin to pom.xml
echo ""
read -p "Would you like to add OpenRewrite plugin to pom.xml? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if grep -q "rewrite-maven-plugin" pom.xml; then
        echo -e "${YELLOW}✓${NC} OpenRewrite plugin already exists in pom.xml"
    else
        echo "Adding OpenRewrite plugin to pom.xml..."
        echo "Please add this manually to your pom.xml in the <build><plugins> section:"
        echo ""
        cat << 'EOF'
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
EOF
        echo ""
    fi
fi

# Summary
echo ""
echo "=========================================="
echo "Setup Summary"
echo "=========================================="
echo ""

if [ -f ".github/workflows/java-migration.yml" ]; then
    echo -e "${GREEN}✓${NC} GitHub workflow configured"
else
    echo -e "${YELLOW}○${NC} GitHub workflow - needs manual setup"
fi

if [ -f "rewrite.yml" ]; then
    echo -e "${GREEN}✓${NC} OpenRewrite configuration present"
else
    echo -e "${YELLOW}○${NC} OpenRewrite configuration - needs manual setup"
fi

echo -e "${GREEN}✓${NC} .gitignore updated"

echo ""
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo ""
echo "1. Review and commit the changes:"
echo "   git add .github/workflows/java-migration.yml rewrite.yml .gitignore"
echo "   git commit -m 'Add Java migration automation'"
echo ""
echo "2. Push to your repository:"
echo "   git push origin main"
echo ""
echo "3. Go to GitHub Actions to run the workflow:"
echo "   https://github.com/manjumuralee85/spring-petclinic/actions"
echo ""
echo "4. Click 'Java Migration Automation' and 'Run workflow'"
echo ""
echo "=========================================="
echo "Documentation"
echo "=========================================="
echo ""
echo "See MIGRATION_GUIDE.md for detailed instructions"
echo ""
echo -e "${GREEN}Setup complete!${NC}"
