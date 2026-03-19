# Gespy: Communicate Freely Through Signs

##  Overview
**Gespy** is an innovative mobile application designed to bridge communication gaps for the deaf and hard-of-hearing community using sign language technologies. The app integrates real-time gesture recognition, adaptive learning, 3D avatar-based sign generation for interactive learning and intelligent chatbot assistance to enable seamless interaction between sign and spoken languages.

---

##  Features

### 1. Real-Time Sign Detection (Sign-to-Text)
- Detects dynamic hand gestures in real time.
- Converts sign language into readable text.
- Powered by a machine learning model optimized for accuracy and responsiveness.

---

### 2. 3D Avatar Animations (Text-to-Sign)
- Uses a humanoid 3D avatar built with Blender and rendered using Three.js.
- Accepts:
  - Text input
  - Voice input
- Converts sentences into **ISL (Indian Sign Language) gloss** using an NLP engine.
- Dynamically generates sign animations for:
  - Alphabets
  - Numbers
  - Full sentences
- Adjustable animation speed for better learning.

---

### 3. Intelligent Chatbot System
#### 🔹 Online Mode
- Powered by Gemini API for real-time responses.

#### 🔹 Offline Mode
- Uses a lightweight Tinyllama + nllp model.
- Works without internet connectivity.

#### 🔹 Smart Query Handling
- Intent classifier categorizes user input into:
  - Sign-related queries → Semantic search for relevant sign videos
  - General queries → Processed via offline language model

#### 🔹 Multilingual Support
- Supports queries and responses in multiple languages.

---

### 4. Educational Hub
- Structured learning environment with categorized content.
- Features:
  - 6 learning categories
  - Video-based lessons
  - Progress tracking for each category
  - Completed lessons marked automatically
  - "Tip of the Day" for continuous learning

---

### 5. Adaptive Learning System
- Continuously improves model performance.
- Retrains on real-world user data to:
  - Enhance generalization
  - Handle diverse signing styles
- Expands dataset over time for better accuracy.

---

### 6. Offline Accessibility
- Key features available offline:
  - Chatbot (offline model)
  - Educational content (downloaded videos)
- Optional offline support for:
  - 3D avatar animations (increases app size)
  - Sign detection model (convertible to TFLite for mobile optimization)

---

##  App Structure

### Bottom Navigation Tabs

####  Home Screen
- Real-time sign detection -> adpative learning
- Recently used signs
- Daily learning tips

####  Educational Hub
- 3D avatar access
- Category-based learning modules
- Progress tracking dashboard

####  Chatbot Screen
- Instant query resolution
- Sign-related and general assistance
- Online & offline modes

---

##  Technology Stack

- **Frontend**: Mobile Application (Android/iOS)
- **3D Rendering**: Three.js
- **3D Modeling**: Blender, Mixamo, Readyplayerme
- **Machine Learning**:
  - Sign detection model
  - NLP engine for ISL gloss conversion
- **Chatbot**:
  - Gemini API (online)
  - TinyLLama + NLLP (offline)
- **Search**: Semantic search for sign video retrieval

---

##  Multilingual Support
- Fully multilingual interface (Currently supporting three languages : English, Hindi, Marathi, Bengali)
- Supports multiple languages for:
  - Input
  - Output
  - Learning content

---

##  Future Enhancements
- Full offline support for all features
- Expansion of sign language datasets
- Improved avatar realism and animation fluidity
- Enhanced personalization through adaptive learning


**Gespy – Empowering Communication Without Barriers**
