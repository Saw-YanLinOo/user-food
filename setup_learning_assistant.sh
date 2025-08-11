#!/bin/bash

# Exit on error
set -e

# Project name
echo "Enter your project name (default: learning_assistant):"
read PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-learning_assistant}

# Create Flutter project
flutter create "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Add dependencies
echo "Adding dependencies..."
flutter pub add flutter_riverpod hive hive_flutter flutter_local_notifications equatable intl path_provider

# Add dev dependencies
echo "Adding dev dependencies..."
flutter pub add --dev build_runner hive_generator flutter_test

# Create folder structure
echo "Creating folder structure..."
mkdir -p lib/core/utils lib/core/extensions lib/core/themes lib/core/widgets
mkdir -p lib/data/models lib/data/datasources lib/data/repositories
mkdir -p lib/domain/entities lib/domain/repositories lib/domain/usecases
mkdir -p lib/presentation/riverpod lib/presentation/screens lib/presentation/widgets

echo "\nSetup complete! Open the project in your editor and start building." 