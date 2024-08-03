
# ToDoList iOS App

ToDoList is an iOS application that allows users to manage their tasks. Users can register, login, add tasks, and delete tasks. The app uses Firebase for authentication, database, and storage, and utilizes Shared Preferences for storing user data locally.

## Features

- User Registration
- User Login
- Add Task
- Delete Task
- Side Menu with User Profile and Logout Button

## Firebase Integration

This app uses Firebase for the following functionalities:

### Authentication

Firebase Authentication is used for user registration and login.

### Realtime Database

Firebase Realtime Database is used to store user data, including tasks.

### Storage

Firebase Storage is used to store user profile pictures.

## Shared Preferences

Shared Preferences are used to store user data locally on the device, providing a faster way to access user information without always querying the database.

## Project Structure

```
ToDoList/
├── Controllers/
│   ├── RegisterViewController.swift
│   ├── LoginViewController.swift
│   ├── ToDoViewController.swift
│   ├── MenuViewController.swift
│   ├── TaskCollectionViewCell.swift
├── Models/
│   ├── User.swift
│   ├── ToDo.swift
├── Utils/
│   ├── DBManager.swift
├── Resources/
│   ├── Main.storyboard
│   ├── LaunchScreen.storyboard
│   ├── Assets.xcassets
│   ├── Info.plist
│   ├── GoogleService-Info.plist
├── Podfile
```

## Installation

To run this project, you need to have CocoaPods installed. If you don't have CocoaPods, you can install it by running:

```sh
sudo gem install cocoapods
```

Then, navigate to the project directory and run:

```sh
pod install
```

This will install all the necessary dependencies for the project.

## Configuration

To configure the project, you need to set up Firebase:

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project.
3. Add an iOS app to your Firebase project.
4. Download the `GoogleService-Info.plist` file.
5. Replace the existing `GoogleService-Info.plist` file in the project with the new one.

## Usage

1. Open the project in Xcode.
2. Build and run the project on a simulator or a physical device.

## Code Overview

### RegisterViewController.swift

Handles user registration. Users can upload a profile picture, which is stored in Firebase Storage.

### LoginViewController.swift

Handles user login. Uses Firebase Authentication to validate user credentials.

### ToDoViewController.swift

Displays the list of tasks. Users can add and delete tasks. The tasks are stored in Firebase Realtime Database.

### MenuViewController.swift

Displays the side menu with the user's profile picture and a logout button.

### TaskCollectionViewCell.swift

Custom cell for displaying tasks in a collection view.

### DBManager.swift

Handles all the database operations, including user registration, login, task addition, and deletion.

## Video Demonstration

For a detailed video demonstration, 

https://github.com/user-attachments/assets/38325c02-7218-4519-b047-305f614a5e94



https://github.com/user-attachments/assets/9eed81fd-59ea-402f-a14e-152c37b17f9b




