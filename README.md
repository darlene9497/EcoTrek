# EcoTrek – Gamified Sustainability App

**EcoTrek** is a gamified Flutter application designed to help users embrace eco-friendly habits through engaging challenges, personalized roadmaps, and real-world impact tracking. Built for individuals passionate about climate action, EcoTrek uses AI, Firebase, and an intuitive UI to make sustainability simple, rewarding, and social.

## Features

-  **Eco Challenges**  
  Complete daily/weekly challenges across categories like food, water, waste, shopping, and digital life.

-  **AI-Generated Challenges**  
  Instantly get new, creative challenge ideas powered by AI based on category and difficulty.

-  **Lessons & Learning Paths**  
  Access educational content on sustainable living and track lesson completion.

-  **Smart Roadmaps**  
  Define your goals and get an AI-generated roadmap with phases and steps tailored to your timeline.

-  **Leaderboard**  
  Compete with others and climb the leaderboard by earning XP and completing tasks.

-  **Progress Tracking**  
  Your completed challenges, points, and XP are synced across the app with persistent state using `Provider` + `SharedPreferences`.

-  **Profile & Achievements**  
  Monitor your XP, level up with experience points (every 500 XP), and stay motivated with daily eco quotes.

## Tech Stack

- **Flutter** (cross-platform development)
- **Firebase** (Auth, Firestore, Storage)
- **OpenRouter/Gemini API** (for AI features)
- **Provider** (state management)
- **SharedPreferences** (local persistence)
- **Netlify** (for web deployment)

## Installation

### Flutter
```bash
git clone https://github.com/darlene9497/EcoTrek.git
cd EcoTrek
flutter pub get
flutter run
```

## Live Preview
Try EcoTrek now:
[Live Preview on Netlify](https://eco-trek.netlify.app)