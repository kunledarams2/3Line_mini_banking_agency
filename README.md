# three_line_agency_banking

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



### 2. Install Dependencies

```bash
flutter pub get
```

### 3. iOS — Install CocoaPods (first time only)

```bash
cd ios
pod install
cd ..
```

### 4. Run the App

```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device_id>

# Run on the first available device
flutter run

# Run in release mode (closer to production performance)
flutter run --release
```

### 5. Build for Distribution (optional)

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ipa --release
```

---

## 🧪 Testing the App

### Demo Credentials

Use these credentials on the login screen:

| Field | Value |
|-------|-------|
| Agent ID | `AGT123` |
| Password | `password` |

### Demo Customer Accounts

These accounts are pre-loaded in the mock API:

| Account Number | Name | Balance |
|----------------|------|---------|
| `0123456789` | Jane Doe | ₦25,000.00 |
| `9876543210` | John Smith | ₦150,000.00 |
| `1111111111` | Amaka Obi | ₦5,000.00 |

---

### Test Flow 1 — Full Happy Path

1. **Launch** the app — you land on the Login screen
2. **Login**: Enter Agent ID `AGT123` and Password `password` → tap **Sign In**
3. **Home screen** loads — the Today's Summary banner shows all zeros
4. Tap **"Pay with bank transfer"**
5. **Search**: Enter account number `0123456789` → tap **Search**
6. The **customer card** appears showing Jane Doe's details and balance
7. Tap **Deposit**
8. The **deposit sheet** slides up — enter an amount (e.g. `5000`) or tap a quick-amount chip
9. Tap **Continue** → a **Confirm Deposit** dialog appears with transaction details
10. Tap **Confirm Deposit**
11. The **The Transaction pin - enter `1234` to process the deposit **
12. The **success dialog** shows with a generated Transaction ID (e.g. `TXN04821`)
13. Tap **Done** — the sheet closes
14. Navigate **back to Home** — the Today's Summary banner now shows:
    - Total Deposits: ₦5,000.00
    - Transactions: 1
    - Commission: ₦25.00 (0.5%)


---

### Test Flow 2 — Error Handling

#### Invalid Login
- Enter Agent ID `AGT999` and any password → login should fail with _"Invalid agent ID or password"_

#### Invalid Account Number
- On the customer search screen, enter a non-existent account like `9999999999` → error banner shows _"Customer account not found"_
- Enter letters or fewer than 10 digits → inline validation message appears

#### Invalid Deposit Amount
- Leave amount blank → _"Amount is required"_
- Enter `50` → _"Minimum deposit is ₦100"_
- Enter `9999999` → _"Maximum single deposit is ₦5,000,000"_

---

### Test Flow 3 — Session Persistence

1. Login and perform a deposit
2. Kill the app completely
3. Relaunch — you should land directly on the **Home screen** (token persists via `flutter_secure_storage`)
4. Tap the settings icon (top right) → **Sign Out** → you are taken back to Login

---

wfd

---

## 🏗️ Architecture

The app follows a clean **MVVM + Repository** pattern with full separation of concerns across four layers.

```
lib/
├── main.dart                           # App entry point, session routing
│
├── theme/
│   ├── app_theme.dart                  # AppColors — all colours, AppTheme — ThemeData
│   └── app_text_styles.dart            # AppTextStyles — all TextStyle tokens
│
├── models/                             # Pure Dart data classes — no Flutter deps
│   ├── auth_model.dart                 # LoginRequest, LoginResponse
│   ├── customer_model.dart             # Customer
│   ├── transaction_model.dart          # DepositRequest, DepositResponse
│   ├── transaction_history_model.dart  # TransactionRecord (local history entry)
│   └── app_error.dart                  # Unified AppError with HTTP status mapping
│
├── services/                           # External integrations
│   ├── storage_service.dart            # flutter_secure_storage wrapper (token vault)
│   ├── api_client.dart                 # Dio HTTP client + Auth interceptor + 401 handler
│   └── mock_api_service.dart           # Drop-in mock with realistic delays (replace for prod)
│
├── repositories/                       # Data access — return (value, error) tuples
│   ├── auth_repository.dart            # Login, logout, session check
│   ├── customer_repository.dart        # Customer search by account number
│   └── transaction_repository.dart     # Cash deposit
│
├── providers/                          # Riverpod state layer (ViewModels)
│   ├── providers.dart                  # All provider declarations in one place
│   ├── auth_notifier.dart              # AuthNotifier + AuthState
│   ├── customer_notifier.dart          # CustomerNotifier + CustomerState
│   ├── deposit_notifier.dart           # DepositNotifier + DepositState
│   └── stats_notifier.dart             # StatsNotifier + AgentStats (session totals)
│
├── utils/
│   ├── validators.dart                 # Centralised form validation rules
│   └── formatters.dart                 # ₦ currency formatting, account masking
│
└── presentation/                       # UI — reads from providers, never from repos directly
    ├── home_screen.dart                # Dashboard: stats banner + payment options + quick actions
    ├── login/
    │   └── login_screen.dart           # Agent login form
    ├── customer_search/
    │   └── customer_search_screen.dart # Account lookup + customer card
    ├── deposit/
    │   └── deposit_screen.dart         # Bottom sheet → confirm dialog → success dialog
    ├── transactions/
    │   └── transactions_screen.dart    # Full transaction history list
    └── widgets/
        ├── app_button.dart             # Reusable primary button with loading state
        ├── app_text_field.dart         # Themed text input with validation
        └── error_banner.dart           # Inline error display with dismiss
```

---

### Data Flow

```
UI (Presentation)
    │  reads/watches
    ▼
Providers (Notifiers)          ← Riverpod StateNotifierProvider
    │  calls
    ▼
Repositories                   ← returns (value, error) record tuples
    │  calls
    ▼
Services
  ├── MockApiService            ← simulates HTTP (swap for ApiClient in prod)
  └── StorageService            ← secure token persistence
```

### State Management Pattern

Each feature has a dedicated `StateNotifier`:

| Provider | Scope | Responsibility |
|----------|-------|---------------|
| `authNotifierProvider` | App-wide | Login / logout / session restore |
| `customerNotifierProvider` | Auto-dispose | Customer search lifecycle |
| `depositNotifierProvider` | Auto-dispose | Deposit flow + triggers stats update |
| `statsNotifierProvider` | App-wide | Accumulates deposit totals + transaction history |

`autoDispose` is used on `customerNotifierProvider` and `depositNotifierProvider` so state is cleaned up when the screen is no longer in the widget tree, preventing stale data showing on re-entry.

### Error Handling

Repositories return **`(T?, AppError?)`** record tuples instead of throwing exceptions. This forces callers to explicitly handle both outcomes:

```dart
final (customer, error) = await _repo.findCustomer(accountNumber);
if (error != null) {
  state = CustomerState(error: error.message);
} else {
  state = CustomerState(customer: customer);
}
```

`AppError.fromStatusCode()` maps HTTP status codes to user-friendly messages centrally.

---

## 📦 Libraries Used

| Package | Version | Purpose |
|---------|---------|---------|
| [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) | ^2.4.9 | State management via `StateNotifierProvider`. Chosen for its compile-time safety, auto-dispose support, and clean provider composition |
| [`dio`](https://pub.dev/packages/dio) | ^5.4.0 | HTTP client. Used for its interceptor system — enables automatic `Authorization` header injection and global 401 handling without touching individual API calls |
| [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) | ^9.0.0 | Stores the JWT token securely using iOS Keychain and Android EncryptedSharedPreferences. Prevents token leakage via app backups or device file system access |
| [`go_router`](https://pub.dev/packages/go_router) | ^13.2.0 | Declarative routing (included for future deep-link and guarded route support) |
| [`intl`](https://pub.dev/packages/intl) | ^0.19.0 | Nigerian Naira (₦) currency formatting, number formatting, and date/time localisation used throughout the transaction history |
| [`flutter_lints`](https://pub.dev/packages/flutter_lints) | ^3.0.0 | Enforces Dart best practices and Flutter-specific lint rules during development |

---

## 🔒 Security Considerations

| Concern | Implementation |
|---------|---------------|
| Token storage | `flutter_secure_storage` — Keychain (iOS) / EncryptedSharedPreferences (Android). Never stored in SharedPreferences or plain files |
| Token transmission | Injected as `Authorization: Bearer <token>` by a Dio interceptor — no manual header setting in any API call |
| Session expiry | 401 responses in the interceptor automatically clear storage and redirect to login |
| Password field | Obscured by default; visibility toggle available |
| Input sanitisation | All form inputs validated before any API call; digits-only enforced on account number via `FilteringTextInputFormatter` |
| Orientation lock | App locked to portrait to prevent layout issues on tablets |

---

## 🔄 Switching to a Real API

The mock layer is isolated behind the repository interface. To connect a real backend:

**Step 1** — Set the base URL in `lib/services/api_client.dart`:
```dart
static const _baseUrl = 'https://your-real-api.com/v1';
```

**Step 2** — Replace `MockApiService` calls in each repository with `ApiClient.dio`:

```dart
// Before (mock)
final customer = await _api.getCustomer(accountNumber);

// After (real)
final response = await _apiClient.dio.get('/customers/$accountNumber');
final customer = Customer.fromJson(response.data);
```

**Step 3** — Remove `mock_api_service.dart` and its provider from `providers.dart`.

**Step 4** — The `ApiClient` interceptor already handles `Authorization` headers and 401s — no additional wiring needed.

---

## 📄 License

MIT © 2026 3Line Agency Banking Platform
# 3Line_mini_banking_agency
