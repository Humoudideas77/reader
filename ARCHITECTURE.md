# Qari2 Architecture Documentation

## System Overview

Qari2 is built following **Clean Architecture** principles with clear separation between UI, business logic, and data layers. The app uses Flutter for cross-platform mobile development (iOS & Android).

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                   │
│  (UI Components, Screens, Widgets, State Management)     │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                     Domain Layer                         │
│         (Entities, Use Cases, Business Rules)            │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                      Data Layer                          │
│  (Repositories, Services, Data Sources, API Clients)     │
└──────────────────────────────────────────────────────────┘
```

## Layer Breakdown

### 1. Presentation Layer (`lib/features/`, `lib/widgets/`)

**Responsibilities:**
- UI rendering
- User interaction handling
- State management (Riverpod)
- Navigation (GoRouter)

**Key Components:**
- **Screens**: Complete page views (OnboardingScreen, LibraryScreen, etc.)
- **Widgets**: Reusable UI components (DocumentCard, EmptyStateWidget, etc.)
- **State Providers**: Riverpod providers for state management

**Dependencies:**
- Domain layer (entities, use cases)
- Does NOT directly depend on data layer

### 2. Domain Layer (`lib/domain/`)

**Responsibilities:**
- Business logic
- Core data models (entities)
- Use case definitions
- Business rules and validations

**Key Components:**
- **Entities**: Pure Dart classes representing core business objects
  - `User`, `Document`, `SubscriptionPlan`, `UsageStats`
  - `AiSummaryResult`, `AiSearchHit`, `AiChatMessage`
- **Use Cases**: Business operations (to be implemented)
  - ImportDocumentUseCase
  - GenerateSummaryUseCase
  - CheckSubscriptionLimitUseCase

**Dependencies:**
- None (pure Dart, no external dependencies)

### 3. Data Layer (`lib/data/`)

**Responsibilities:**
- Data persistence (Hive)
- External service communication
- API clients
- Data transformation (DTOs ↔ Entities)

**Key Components:**
- **Repositories**: Abstraction over data sources
  - `DocumentRepository`: CRUD operations for documents
- **Services**: External integrations
  - `DocumentAiService`: AI operations (mock)
  - `ConversionService`: File conversion (mock)
  - `SubscriptionService`: Billing and plans (mock)
- **Models**: Data transfer objects (DTOs) if needed

**Dependencies:**
- Domain layer (entities)
- External packages (Hive, HTTP clients, etc.)

## State Management Strategy

**Chosen Solution: Riverpod**

### Provider Types Used

1. **Provider**: Immutable, computed values
   ```dart
   final themeProvider = Provider<AppTheme>((ref) => AppTheme());
   ```

2. **StateNotifierProvider**: Mutable state with lifecycle
   ```dart
   final documentListProvider = StateNotifierProvider<DocumentListNotifier, AsyncValue<List<Document>>>(
     (ref) => DocumentListNotifier(ref.read(documentRepositoryProvider)),
   );
   ```

3. **FutureProvider**: Async data loading
   ```dart
   final subscriptionPlanProvider = FutureProvider<SubscriptionPlan>((ref) async {
     return ref.read(subscriptionServiceProvider).getCurrentPlan('userId');
   });
   ```

### Dependency Injection

All services and repositories are registered as providers in `lib/core/di/`:

```dart
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepository();
});

final documentAiServiceProvider = Provider<DocumentAiService>((ref) {
  return MockDocumentAiService(); // Replace with real implementation
});
```

## Navigation Architecture

**GoRouter Configuration**

Routes are defined in `lib/core/routing/app_router.dart`:

```
/onboarding          → OnboardingScreen
/library             → LibraryScreen (home)
/document/:id        → DocumentViewerScreen
/settings            → SettingsScreen
/paywall             → PaywallScreen
```

**Navigation Pattern:**
- Deep linking ready
- Type-safe navigation with named routes
- Parameter passing via path parameters or `extra`

**Example:**
```dart
context.push('/document/${doc.id}', extra: doc);
```

## Data Flow

### Example: User Imports a Document

```
1. User taps "Import" → LibraryScreen
2. File picker opens → User selects PDF
3. DocumentImportUseCase validates file
4. DocumentRepository.saveDocument(doc)
5. Hive stores document metadata locally
6. DocumentAiService.processDocumentForAi(doc) [background]
7. UI updates via StateNotifier
8. Document appears in library with "AI Processing" badge
```

### Example: User Asks AI Question

```
1. User types question → AiDock (Chat tab)
2. Check subscription limits → SubscriptionService
3. If allowed:
   - Add user message to chat
   - Call DocumentAiService.chatWithDocument()
   - Mock service returns response after delay
   - AI message added to chat
4. If limit reached:
   - Show limit dialog
   - Offer upgrade to paywall
```

## Storage Architecture

### Local Storage (Hive)

**Boxes:**
- `documents_box`: Document metadata
- `user_box`: User profile and auth tokens
- `settings_box`: App preferences
- `usage_box`: Usage statistics for plan limits

**Data Structure:**
```dart
// Hive box structure
Box<Map> documentsBox
  - Key: documentId (String)
  - Value: Document.toJson() (Map)
```

**Why Hive?**
- Fast, local-first storage
- No SQL required
- Strong type safety with generated adapters
- Supports encryption (for production)

### Future: Cloud Sync

For multi-device support, add:
1. Backend API for document metadata sync
2. Cloud storage for document files (AWS S3, GCS)
3. Conflict resolution strategy
4. Offline-first with eventual consistency

## AI Service Architecture

### Current: Mock Implementation

All AI services return hardcoded mock data with simulated delays:

```dart
Future<AiSummaryResult> summarizeDocument(Document doc, SummaryMode mode) async {
  await Future.delayed(Duration(milliseconds: 1500)); // Simulate API call
  return AiSummaryResult(/* mock data */);
}
```

### Production: Real AI Integration

**Recommended Architecture:**

```
┌──────────────┐
│ Flutter App  │
└──────┬───────┘
       │ HTTP/REST
┌──────▼─────────────────────────────────────┐
│         Backend API (FastAPI/Node.js)       │
│                                             │
│  - Authentication                           │
│  - Rate limiting                            │
│  - Usage tracking                           │
│  - Document processing queue                │
└───────┬──────────────────┬──────────────────┘
        │                  │
   ┌────▼─────┐      ┌─────▼──────┐
   │   LLM    │      │  Vector    │
   │   API    │      │  Database  │
   │ (OpenAI, │      │ (Pinecone, │
   │ Claude)  │      │ Weaviate)  │
   └──────────┘      └────────────┘
```

**Steps:**
1. **Document Upload**: Upload PDF to backend
2. **Text Extraction**: Extract text (OCR if needed)
3. **Embedding Generation**: Create vector embeddings of chunks
4. **Vector Storage**: Store in vector database
5. **Query Time**:
   - Semantic Search: Query vector DB
   - Q&A: Retrieve relevant chunks + LLM prompt
   - Summary: Full text + LLM summarization

**API Endpoints (Example):**
```
POST /api/v1/documents/upload
POST /api/v1/documents/{id}/process
POST /api/v1/documents/{id}/summarize
POST /api/v1/documents/{id}/search
POST /api/v1/documents/{id}/chat
```

## Subscription & Billing Architecture

### Plan Enforcement

**Limits Checked Before Operations:**

```dart
// Before importing a document
final canImport = await subscriptionService.canImportDocument(user, usage);
if (!canImport.allowed) {
  showLimitDialog(canImport.errorMessage);
  return;
}

// Before asking AI question
final canAsk = await subscriptionService.canAskAiQuestion(user, usage);
if (!canAsk.allowed) {
  showUpgradeDialog();
  return;
}
```

**Usage Tracking:**
```dart
// After successful operation
await usageRepository.incrementPagesProcessed(userId, pageCount);
await usageRepository.incrementAiQuestions(userId);
```

### Payment Integration (Future)

**iOS: StoreKit via in_app_purchase**
```dart
// Configure products in App Store Connect
final products = await InAppPurchase.instance.queryProductDetails({'subscriber_monthly', 'pro_monthly'});

// Purchase flow
final purchaseParam = PurchaseParam(productDetails: product);
await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

// Listen to purchase updates
InAppPurchase.instance.purchaseStream.listen((purchases) {
  // Validate and activate subscription
});
```

**Android: Google Play Billing**
- Similar flow via `in_app_purchase` package
- Configure SKUs in Google Play Console
- Handle subscription lifecycle

**Backend Validation:**
- Server-side receipt validation (required for security)
- Webhook handling for subscription events
- Grace period for payment failures

## Localization Architecture

### Language Support

- **English (en)**: Left-to-right (LTR)
- **Arabic (ar)**: Right-to-left (RTL)

### Implementation

**1. ARB Files** (`assets/l10n/`)
```json
{
  "@@locale": "en",
  "myLibrary": "My Library",
  "@myLibrary": {
    "description": "Title for library screen"
  }
}
```

**2. Localization Delegate**
```dart
// lib/core/localization/app_localizations.dart
class AppLocalizations {
  final Locale locale;
  String get myLibrary => Intl.message('My Library', name: 'myLibrary');
}
```

**3. Usage in Widgets**
```dart
Text(AppLocalizations.of(context)!.myLibrary)
```

**4. RTL Handling**
```dart
return Directionality(
  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
  child: child,
);
```

## Theme Architecture

### Dual Theme System

**Light Mode:**
- Background: `#F7F7FA`
- Primary: `#1E3A5F` (Ink Blue)
- Accent: `#00A676` (Emerald Green)

**Dark Mode:**
- Background: `#0B1020`
- Adjusted colors for contrast
- Same brand colors, different opacity

### Font Strategy

**Language-Specific Fonts:**
```dart
TextTheme getTextTheme(Locale locale) {
  return locale.languageCode == 'ar'
      ? GoogleFonts.cairoTextTheme()
      : GoogleFonts.poppinsTextTheme();
}
```

**Why Google Fonts?**
- Automatic download and caching
- Fallback to system fonts if needed
- Easy to switch fonts

**For Production:**
- Bundle fonts locally for offline support
- Use `assets/fonts/` directory
- Configure in `pubspec.yaml`

## Security Considerations

### Current (MVP)

⚠️ **Not Production Ready:**
- No authentication
- Unencrypted local storage
- Mock services with no API security

### Production Requirements

**1. Authentication**
- JWT tokens or Firebase Auth
- Secure token storage (Flutter Secure Storage)
- Token refresh mechanism

**2. Data Encryption**
- Encrypt Hive boxes:
  ```dart
  final encryptionKey = await getEncryptionKey();
  final box = await Hive.openBox('secure_box',
    encryptionCipher: HiveAesCipher(encryptionKey));
  ```

**3. API Security**
- HTTPS only
- API key/token in headers
- Certificate pinning for critical APIs

**4. File Security**
- Encrypt documents at rest
- Secure file upload (signed URLs)
- Access control checks

## Testing Strategy

### Test Pyramid

```
      ╱╲
     ╱E2E╲      ← Few, expensive, slow
    ╱──────╲
   ╱Widget  ╲   ← More, medium cost
  ╱──────────╲
 ╱   Unit     ╲ ← Many, cheap, fast
╱──────────────╲
```

### Unit Tests

**What to Test:**
- Services (mock HTTP calls)
- Repositories (mock Hive)
- Use cases
- Utilities and helpers

**Example:**
```dart
test('DocumentAiService generates summary', () async {
  final service = MockDocumentAiService();
  final doc = Document(/* test data */);

  final summary = await service.summarizeDocument(doc, SummaryMode.short);

  expect(summary.text, isNotEmpty);
  expect(summary.mode, SummaryMode.short);
});
```

### Widget Tests

**What to Test:**
- Individual widgets
- User interactions
- State changes

**Example:**
```dart
testWidgets('DocumentCard shows title', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: DocumentCard(document: testDoc, onTap: () {}),
  ));

  expect(find.text(testDoc.title), findsOneWidget);
});
```

### Integration Tests

**What to Test:**
- Complete user flows
- Navigation between screens
- End-to-end features

**Example:**
```dart
testWidgets('User can import and view document', (tester) async {
  await tester.pumpWidget(MyApp());

  // Tap import button
  await tester.tap(find.text('Add Document'));
  await tester.pumpAndSettle();

  // Select file (mocked)
  // ...

  // Verify document appears in library
  expect(find.byType(DocumentCard), findsWidgets);
});
```

## Performance Considerations

### Optimization Strategies

**1. Lazy Loading**
```dart
ListView.builder(
  itemCount: documents.length,
  itemBuilder: (context, index) => DocumentCard(documents[index]),
);
```

**2. Image Caching**
```dart
CachedNetworkImage(
  imageUrl: doc.thumbnailUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);
```

**3. Pagination**
```dart
// Load more when reaching end of list
if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
  loadMoreDocuments();
}
```

**4. Debouncing**
```dart
// Debounce search input
Timer? _debounce;

void onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 500), () {
    performSearch(query);
  });
}
```

**5. PDF Rendering**
- Use pagination, don't load entire PDF
- Cache rendered pages
- Lower resolution for thumbnails

## Deployment Architecture

### Build Process

**1. Development**
```bash
flutter run --debug
```

**2. Staging**
```bash
flutter build apk --release --flavor staging
flutter build ios --release --flavor staging
```

**3. Production**
```bash
flutter build apk --release --flavor production
flutter build ios --release --flavor production
```

### CI/CD Pipeline (Recommended)

```
GitHub Push
    │
    ▼
GitHub Actions / GitLab CI
    │
    ├─► Run Tests
    ├─► Lint & Format Check
    ├─► Build APK/IPA
    ├─► Sign Artifacts
    │
    ▼
Deploy to:
    ├─► Firebase App Distribution (staging)
    ├─► Google Play Console (production)
    └─► App Store Connect (production)
```

### Environment Configuration

Use flavors for different environments:

```yaml
# android/app/build.gradle
flavorDimensions "environment"
productFlavors {
  development {
    dimension "environment"
    applicationIdSuffix ".dev"
  }
  staging {
    dimension "environment"
    applicationIdSuffix ".staging"
  }
  production {
    dimension "environment"
  }
}
```

## Scalability Roadmap

### Phase 1: MVP (Current)
- Single user, local storage
- Mock AI services
- Basic features

### Phase 2: Cloud Integration
- User authentication
- Cloud document storage
- Real AI backend
- Payment integration

### Phase 3: Collaboration
- Shared documents
- Comments and annotations
- Team workspaces

### Phase 4: Enterprise
- Admin dashboard
- API for integrations
- White-label solution
- On-premise deployment option

---

**Last Updated:** 2025-01-20
**Author:** Qari2 Architecture Team
