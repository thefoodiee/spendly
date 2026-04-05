# Spendly

A smart, privacy-first Flutter app that automatically tracks your expenses by reading and analyzing UPI/SMS transaction messages. Designed for quick insights into your monthly spending habits.

---

## 🚀 Features

- 📩 **SMS Parsing**: Automatically reads SMS from supported banks (only SBI for now) to extract transaction data.
- 📊 **Spending Analysis**: Visualizes expenses using charts and categorizes them.
- 🔐 **Firebase Auth**: Secure user login via Firebase.
- 📅 **Monthly Reports**: Summarizes your spending month-wise.

---

## 🛠️ Tech Stack

- **Flutter** & **Dart**
- **Firebase Authentication**
- **SMS Retrieving via Kotlin** (Android)
- **Firebase Firestore** (for storing user info)

---

## 📷 Screenshots

![Screens_1](https://github.com/thefoodiee/spendly/blob/main/screenshots/screens_1.png?raw=true)
![Screens_2](https://github.com/thefoodiee/spendly/blob/main/screenshots/screens_2.png?raw=true)

---

## 📦 Installation

1. **Clone the repo**:
   ```bash
   git clone https://github.com/thefoodiee/spendly.git
   cd spendly

2. **Install Dependencies**:
   ```bash
   flutter pub get

3. **Run App**
   ```bash
   flutter run
