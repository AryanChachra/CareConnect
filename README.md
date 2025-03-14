# CareConnect

## 📌 About the Project
**CareConnect** is a mobile application developed using **Flutter** that helps users book hospital beds and check availability in real time. The app is part of a larger ecosystem, including a **React-based web frontend** and a **Django backend**.

## 🚀 Features
- 🏥 **Real-time Hospital Bed Availability**
- 📅 **Appointment Booking System**
- 🔎 **Doctor Listings & Specializations**
- 🔐 **Secure User Authentication** (Firebase Auth)
- 📍 **Hospital & Doctor Location Mapping**
- 📊 **Dashboard for Healthcare Insights**

## 🛠️ Tech Stack
### **Frontend:**
- **Flutter** (Mobile App)
- **React.js** (Web Dashboard)

### **Backend:**
- **Django** (REST API)
- **Firebase** (Authentication)
- **MySQL** (Database)

## 📲 Installation & Setup
### **Prerequisites**
- Install **Flutter**: [Official Installation Guide](https://flutter.dev/docs/get-started/install)
- Install **Dart SDK**
- Clone the repository:
  ```sh
  git clone https://github.com/AryanChachra/CareConnect.git
  ```
- Navigate to the project directory:
  ```sh
  cd CareConnect
  ```
- Install dependencies:
  ```sh
  flutter pub get
  ```
- Run the app:
  ```sh
  flutter run
  ```

## 📸 Screenshots

![Home Screen](screenshots/home.png)
![Doctor List](screenshots/doctors.png)


## 🎯 Contributors
- **Aryan Chachra** - Flutter Developer
- **Gaurav Kadaskar** - Backend Developer
- **Kunal Bamoriya** - Frontend Developer

## 📜 License
This project is **open-source** under the **MIT License**.





# CareConnect

## 📌 About the Project
**CareConnect** is a mobile application developed using **Flutter** that helps users book hospital beds and check availability in real time. The app is part of a larger ecosystem, including a **React-based web frontend** and a **Django backend**.

## 🚀 Features
- 🏥 **Real-time Hospital Bed Availability**
- 📅 **Appointment Booking System**
- 🔎 **Doctor Listings & Specializations**
- 🔐 **Secure User Authentication** (Firebase Auth)
- 📍 **Hospital & Doctor Location Mapping**
- 📊 **Dashboard for Healthcare Insights**

## 🛠️ Tech Stack
### **Frontend:**
- **Flutter** (Mobile App)
- **React.js** (Web Dashboard)

### **Backend:**
- **Django** (REST API)
- **Firebase** (Authentication)
- **MySQL** (Database)

## 📲 Installation & Setup
### **Prerequisites**
- Install **Flutter**: [Official Installation Guide](https://flutter.dev/docs/get-started/install)
- Install **Dart SDK**
- Clone the repository:
  ```sh
  git clone https://github.com/AryanChachra/CareConnect.git
  ```
- Navigate to the project directory:
  ```sh
  cd CareConnect
  ```
- Install dependencies:
  ```sh
  flutter pub get
  ```
- Run the app:
  ```sh
  flutter run
  ```

## 📸 Screenshots
_Add screenshots of the app below:_

![Home Screen](screenshots/home.png)
![Doctor List](screenshots/doctors.png)

## 📥 Download APK
[![Download APK](https://img.shields.io/badge/Download-APK-green.svg)](your-apk-link-here)

## 🔗 API Configuration
- Update `lib/services/api_config.dart` with your **backend URL**:
  ```dart
  const String baseUrl = "https://careconnect-web-alnz.onrender.com";
  ```

## ⚠️ Common Issues & Fixes
### **1. Failed host lookup (Error: No address associated with hostname)**
- Ensure that **Android Emulator** has internet access.
- Add **ClearText Traffic** permission in `AndroidManifest.xml`:
  ```xml
  <application android:usesCleartextTraffic="true">
  ```

### **2. Git Push Issues (Service Folder Still Being Tracked)**
- Run:
  ```sh
  git rm -r --cached lib/services/
  git commit -m "Removed services folder from tracking"
  git push origin main
  ```

## 🎯 Contributors
- **Aryan Chachra** - Flutter Developer
- **Gaurav Kadaskar** - Backend Developer
- **Kunal Bamoriya** - Frontend Developer

## 📜 License
This project is **open-source** under the **MIT License**.



