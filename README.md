# Qari2 | قارئ

**Your smart Arabic document companion**
**رفيقك الذكي لقراءة المستندات**

A mobile-first AI-powered document reader and assistant for Arabic and English documents, built with Flutter.

![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20Android-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.2%2B-02569B?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📱 Overview

Qari2 is a mobile application designed to help users read, understand, and interact with documents in Arabic and English. It combines a powerful PDF reader with AI-driven features including:

- **AI Document Summarization** - Generate short or detailed summaries instantly
- **Semantic Search** - Find concepts and ideas, not just keywords
- **Chat with Documents** - Ask questions and get contextual answers
- **Document Conversion** - Convert between PDF, Word, and Text formats
- **OCR Support** - Extract text from scanned documents and images
- **Bilingual Interface** - Full Arabic and English support with RTL layout

### Target Users

- University students studying in Arabic or English
- Government and office employees dealing with documents
- Researchers and professionals in GCC & MENA regions
- Anyone reading Arabic PDFs on mobile devices

---

## 🎨 Design & Branding

### Visual Identity

**Color Palette:**
- Primary (Ink Blue): `#1E3A5F` - Trust, intelligence, professionalism
- Accent (Emerald Green): `#00A676` - Growth, success, AI features
- Secondary (Soft Sand): `#F4E4C1` - Warmth, accessibility
- Background Light: `#F7F7FA`
- Background Dark: `#0B1020`

**Typography:**
- **Latin**: Poppins (clean, modern, readable)
- **Arabic**: Cairo (designed for Arabic script, highly legible)

**Logo Concept:**
- Abstract open book with stylized Arabic letter "ق" (Qaf)
- Gradient from Ink Blue to Emerald Green
- Rounded square app icon

---

## 🏗️ Architecture

### Tech Stack

- **Framework**: Flutter 3.2+
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: Hive
- **Internationalization**: flutter_localizations + intl
- **UI Components**: Material 3

### Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core functionality
│   ├── theme/                   # Colors, typography, themes
│   ├── routing/                 # GoRouter configuration
│   ├── localization/            # i18n setup
│   ├── constants/               # App-wide constants
│   └── di/                      # Dependency injection (Riverpod providers)
├── features/                    # Feature modules
│   ├── onboarding/              # Onboarding flow
│   ├── auth/                    # Authentication (placeholder)
│   ├── library/                 # Document library/home
│   ├── document_viewer/         # PDF viewer + AI dock
│   ├── search/                  # Document search
│   ├── ai_chat/                 # Chat with document
│   ├── conversion/              # Format conversion tools
│   ├── billing/                 # Subscription & paywall
│   └── settings/                # App settings
├── domain/                      # Business logic layer
│   ├── entities/                # Core data models
│   └── usecases/                # Business use cases
├── data/                        # Data layer
│   ├── models/                  # Data transfer objects
│   ├── repositories/            # Data repositories
│   └── services/                # External services (AI, OCR, etc.)
└── widgets/                     # Shared UI components
```

### Clean Architecture Principles

1. **Separation of Concerns**: UI, business logic, and data are separated
2. **Dependency Rule**: Inner layers don't depend on outer layers
3. **Testability**: Each layer can be tested independently
4. **Scalability**: Easy to add new features or modify existing ones

---

## 💰 Monetization Strategy

### Three-Tier Pricing Model

#### 🆓 Free Plan ($0/month)
- 5 documents
- 150 pages/month
- 10 AI questions/day
- 5 conversions/month
- Basic summaries

#### ⭐ Subscriber Plan ($6.99/month ≈ 2.25 KWD)
**Most Popular**
- 100 documents
- 2,000 pages/month
- 50 AI questions/day
- 100 conversions/month
- All summary modes
- Priority AI queue
- No ads
- Multi-document chat

#### 👑 Pro Plan ($12.99/month ≈ 4.0 KWD)
**Best Value**
- 1,000 documents
- 10,000 pages/month
- 200 AI questions/day
- Unlimited conversions
- All Subscriber features
- Advanced AI tools
- Auto-outline generator
- Study flashcards
- Priority support

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.2 or higher
- Dart SDK 3.0 or higher
- iOS: Xcode 14+ (for iOS development)
- Android: Android Studio (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/qari2-reader-app.git
   cd qari2-reader-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (for Hive, Riverpod, JSON serialization)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Add font assets**

   Download and add these fonts to `assets/fonts/`:
   - Cairo (Arabic): Regular, Bold, SemiBold, Light
   - Poppins (Latin): Regular, Bold, SemiBold, Light

5. **Add logo asset**

   Place the app logo at `assets/logo/qari2_logo.png`

6. **Run the app**
   ```bash
   # Run on connected device/emulator
   flutter run

   # Run on specific device
   flutter devices
   flutter run -d <device-id>

   # Run in release mode
   flutter run --release
   ```

### Project Setup Checklist

- [ ] Fonts added to `assets/fonts/`
- [ ] Logo added to `assets/logo/`
- [ ] Build runner executed
- [ ] Device/emulator connected
- [ ] App runs without errors

---

## 🔧 Configuration

### Environment Setup

The app is currently configured with **mock services** for development. To connect to real backends:

1. **Backend API Configuration**
   - Update `lib/data/services/` with real API endpoints
   - Configure authentication tokens
   - Set up environment variables for API keys

2. **AI Service Integration**
   - Replace `MockDocumentAiService` with actual AI backend
   - Options: OpenAI API, Anthropic API, custom LLM backend
   - Configure document embedding generation
   - Set up vector database for semantic search

3. **Payment Integration**
   - iOS: Configure StoreKit and add in-app purchase products
   - Android: Configure Google Play Billing
   - Or use RevenueCat for unified subscription management

---

## 🌍 Localization

### Supported Languages

- English (en)
- Arabic (ar) with full RTL support

### Adding Translations

1. Edit ARB files:
   - `assets/l10n/intl_en.arb`
   - `assets/l10n/intl_ar.arb`

2. Add new keys following the pattern:
   ```json
   {
     "keyName": "Translation text",
     "@keyName": {
       "description": "Description for translators"
     }
   }
   ```

3. Use in code:
   ```dart
   Text(AppLocalizations.of(context)!.keyName)
   ```

### RTL Support

Arabic layout is automatically applied when the language is set to Arabic. The app uses `Directionality` widget to handle RTL.

---

## 🎯 Core Features Implementation

### 1. Document Library
- **File**: `lib/features/library/library_screen.dart`
- Import PDFs, Word docs, and images
- Organize with tags and favorites
- Filter by starred, recent, or tags
- Search documents by title

### 2. Document Viewer
- **File**: `lib/features/document_viewer/document_viewer_screen.dart`
- PDF rendering (currently mocked, integrate with Syncfusion or PDFView)
- Page navigation and zoom controls
- Dark mode for reading
- AI Dock overlay for AI features

### 3. AI Assistant (AI Dock)
- **File**: `lib/features/document_viewer/widgets/ai_dock.dart`
- **Three tabs**: Summary, Ask, Search

#### Summary Tab
- Generate short or detailed summaries
- Section-specific summaries
- Copy to clipboard functionality

#### Ask Tab (Chat)
- Chat interface with document
- Contextual Q&A
- Source page references

#### Search Tab
- Semantic search (concept-based, not keyword)
- Results with page numbers and relevance scores
- Navigate to search results

### 4. Subscription & Paywall
- **File**: `lib/features/billing/paywall_screen.dart`
- Display all three plans
- Feature comparison table
- Upgrade/downgrade functionality
- Usage limit enforcement

### 5. Settings
- **File**: `lib/features/settings/settings_screen.dart`
- Language selection (EN/AR)
- Theme mode (Light/Dark/System)
- Account management
- Subscription management
- About and legal links

---

## 📊 Data Models

### Core Entities

1. **User** (`lib/domain/entities/user.dart`)
   - User profile and authentication data
   - Current subscription plan
   - Account creation date

2. **Document** (`lib/domain/entities/document.dart`)
   - Document metadata
   - File path and type
   - Tags, favorites, AI processing status

3. **SubscriptionPlan** (`lib/domain/entities/subscription_plan.dart`)
   - Plan details (Free/Subscriber/Pro)
   - Pricing and limits
   - Feature lists

4. **UsageStats** (`lib/domain/entities/usage_stats.dart`)
   - User's monthly/daily usage
   - Documents imported, pages processed
   - AI questions asked, conversions used

5. **AI Entities**
   - `AiSummaryResult`: Summary output
   - `AiSearchHit`: Search result
   - `AiChatMessage`: Chat message in conversation

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/services/ai_service_test.dart
```

### Test Strategy

1. **Unit Tests**: Services, repositories, use cases
2. **Widget Tests**: Individual UI components
3. **Integration Tests**: Complete user flows
4. **Golden Tests**: UI consistency across platforms

---

## 🔐 Security Considerations

### Current Implementation (MVP)
- Mock authentication
- Local storage with Hive (unencrypted)
- No API security

### Production Requirements
1. **Authentication**: Firebase Auth, OAuth, or custom JWT
2. **Data Encryption**: Encrypt Hive boxes with `hive_flutter` encryption
3. **API Security**: HTTPS, API keys, token refresh
4. **File Security**: Secure file storage, access control
5. **Payment Security**: Use official IAP libraries, validate receipts server-side

---

## 🚧 Known Limitations & TODOs

### Current MVP Status

This is a **proof-of-concept MVP** with mock services. The following features are **mocked** and need real implementation:

#### ❌ Not Implemented (Mocked)
- [ ] Real PDF viewer (using placeholder)
- [ ] Actual AI backend integration
- [ ] OCR service
- [ ] Document conversion services
- [ ] File upload/download
- [ ] User authentication
- [ ] Payment processing
- [ ] Cloud sync
- [ ] Push notifications

#### ✅ Implemented (UI & Flow)
- [x] Complete UI for all screens
- [x] Navigation and routing
- [x] Theme system (light/dark)
- [x] Localization (EN/AR with RTL)
- [x] Document library UI
- [x] AI Dock interface
- [x] Subscription plan screens
- [x] Settings
- [x] Mock services with realistic behavior

### Next Steps for Production

1. **Integrate Real PDF Viewer**
   ```yaml
   dependencies:
     syncfusion_flutter_pdfviewer: ^24.1.41
     # or
     flutter_pdfview: ^1.3.2
   ```

2. **Connect AI Backend**
   - Set up backend API (FastAPI, Node.js, etc.)
   - Implement document embedding generation
   - Integrate LLM for Q&A and summaries
   - Set up vector database (Pinecone, Weaviate, Qdrant)

3. **Implement File Handling**
   ```yaml
   dependencies:
     file_picker: ^6.1.1
     image_picker: ^1.0.5
     path_provider: ^2.1.1
   ```

4. **Add Real Authentication**
   ```yaml
   dependencies:
     firebase_auth: ^4.15.0
     # or custom auth solution
   ```

5. **Integrate Payments**
   ```yaml
   dependencies:
     in_app_purchase: ^3.1.11
     # or
     revenue_cat: ^6.0.0
   ```

---

## 📖 API Integration Guide

### Document AI Service

**Endpoint Structure (Example)**
```
POST /api/v1/documents/{docId}/process
POST /api/v1/documents/{docId}/summarize
POST /api/v1/documents/{docId}/search
POST /api/v1/documents/{docId}/chat
```

**Replace Mock Implementation**

In `lib/data/services/document_ai_service.dart`, replace the mock methods:

```dart
@override
Future<AiSummaryResult> summarizeDocument(
  Document doc,
  SummaryMode mode,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/documents/${doc.id}/summarize'),
    headers: {'Authorization': 'Bearer $token'},
    body: jsonEncode({'mode': mode.name}),
  );

  // Parse and return
  return AiSummaryResult.fromJson(jsonDecode(response.body));
}
```

### Conversion Service

**Recommended Libraries**
- PDF to Text: `pdf_text`, `syncfusion_flutter_pdf`
- OCR: Google ML Kit, Tesseract
- Image to PDF: `image` + `pdf` packages

---

## 🎓 Learning Resources

### Flutter Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Material 3 Design](https://m3.material.io/)
- [Riverpod Guide](https://riverpod.dev/)

### Arabic/RTL Development
- [Flutter i18n Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [Bidirectional Text](https://api.flutter.dev/flutter/widgets/Directionality-class.html)

### AI Integration
- [OpenAI API](https://platform.openai.com/docs/)
- [LangChain](https://www.langchain.com/)
- [Pinecone Vector DB](https://www.pinecone.io/)

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter format` before committing
- Add comments for complex logic
- Write unit tests for new features

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Support

For questions, issues, or feature requests:

- **Email**: support@qari2.app (placeholder)
- **GitHub Issues**: [Create an issue](https://github.com/your-org/qari2-reader-app/issues)
- **Documentation**: This README and in-code comments

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for Cairo and Poppins typefaces
- All open-source contributors whose packages made this possible

---

## 🗺️ Roadmap

### Phase 1: MVP (Current)
- [x] UI/UX design and implementation
- [x] Mock services
- [x] Local document management
- [x] Subscription model design

### Phase 2: Backend Integration
- [ ] Real authentication system
- [ ] Cloud document storage
- [ ] AI backend integration
- [ ] Payment gateway setup

### Phase 3: Advanced Features
- [ ] Offline AI features (on-device models)
- [ ] Collaborative document reading
- [ ] Advanced study tools (flashcards, quizzes)
- [ ] Desktop companion app

### Phase 4: Scaling
- [ ] Multi-device sync
- [ ] Team/organization accounts
- [ ] API for third-party integrations
- [ ] White-label solution

---

**Built with ❤️ for Arabic readers everywhere**

**بُني بحب للقراء العرب في كل مكان**
