# Code-session handoff — YandexDeliveryExpressDemo (sample app)

Written 2026-08-07. Companion sample for
[`YandexDeliveryExpressAPI`](../YandexDeliveryExpress), the same relationship `Offhook` has
to `swift-pjsua`: a separate repository whose job is to show what consuming the package
actually looks like.

**Do the package first.** `../YandexDeliveryExpress/HANDOFF.md` — that repository does not
currently compile, so nothing here can be verified until it does.

Audited against `swiftui-app-structure` (four-layer MVC), `swiftui-foundations` (R1–R10),
`swiftui-expert-skill`, and `software-development-principles`.

## Decisions already made

| Decision | Value |
|---|---|
| Deployment floor | Stays iOS 18 / macOS 15 — **no backports needed at this floor** |
| Data flow | Migrate `ObservableObject`/`@Published`/`@StateObject` → `@Observable`/`@State`/`@Environment` |
| Dependency injection | Environment injection from the composition root; **delete both singletons** |
| Repository | Its own git repo; consumes the package **by URL** once the package is tagged |

The package's floor is iOS 17, deliberately, so that `Observation` is unconditional for
consumers. This app sits above it at iOS 18, which is fine — a sample should demonstrate the
modern shape, not the minimum.

---

## Done already (2026-08-17)

- **`ClientKey.swift` is gone.** Unused — nothing read `\.yandexClient`; every view model goes
  through `ClientEnvironment.shared` — and it violated two rules in `CLAUDE.md` at once (`try!`,
  and a `defaultValue` singleton already on the deletion list). It also stopped compiling when
  the package removed `Credentials.fromEnvironment` in favour of `Credentials.environment`.
  `ClientEnvironment.shared` is still there and still rule 1's problem.
- The app **builds** against the local package again.

## Sample data — where it lives and why (2026-08-17)

`Models/SampleData.swift` (app target, ships). It used to be `public` API of
`YandexDeliveryExpressAPI`, which put 452 lines of sample addresses in the binary of every app
linking the package — the package's TD-12.

The pattern is Manferdini's and unchanged: static values in type extensions, so `.example…`
resolves by inference (*SwiftUI Structural Foundations* 2.3). His **location** is
`PreviewData.swift` in a **Preview Content** group, "only available for Xcode previews but
won't be included in the final build".

**We deviate, deliberately.** `CalculateOffersViewModel.setupDefaults()` and its `CreateClaim`
twin read this data at *runtime* — for a demo, the prefilled form state is the product, not
scaffolding — and data the shipping build needs cannot live in development assets. Putting it in
a `Preview Content` folder that this project does not exclude from release would be the form of
the convention without its only purpose.

So: **anything a view model reads stays in `Models/`. Anything used only by a `#Preview` goes to
`Preview Content/PreviewData.swift`** once that group exists and `DEVELOPMENT_ASSET_PATHS` is
set — which is worth doing as part of the restructure below, since previews are where most of
this data is used.

One thing sample data taught the package, worth remembering here: it must be **valid**.
`exampleExpressDelivery` set `cargoLoaders: 1` on the `express` tariff, which the live API
refuses with `409 estimating.too_many_loaders`, and no offline test could tell because a stub
transport accepts whatever you send it (the package's TD-18).

## What is wrong now

### 1. Two dependency-injection mechanisms, neither of them injection

`Common/ClientKey.swift` declares `EnvironmentKey` + `EnvironmentValues.yandexClient`.
Nothing reads it — grep for `yandexClient` returns only its own declaration. It is dead, and
it is a **landmine**: its `defaultValue` is
`try! Client(credentials: Credentials.fromEnvironment)`, and `fromEnvironment` calls
`fatalError` when `AUTH_TOKEN` is unset. The first line of code that touches
`\.yandexClient` crashes the app on a clean install.

`Common/ClientEnvironment.swift` is what is actually used: a `static let shared` singleton
that all five view models reach into. That is a service locator — dependencies stop appearing
in signatures, coupling rises, and nothing is substitutable in a preview or a test
(`swiftui-app-structure`, citing Mark Seemann). It is also `ObservableObject` with **no**
`@Published` property, so `AuthAndSettingsView` reassigning `.client` notifies nobody.

**Fix:** delete `ClientKey.swift`. Convert `ClientEnvironment` into an `@Observable`
`ClientController` created once in `@main` and injected with `.environment(_:)`. Its stored
token becomes an observed property so a sign-in actually propagates.

### 2. Application logic lives in views (R5, R6)

`Forms/GenericForm.swift` — the "Send Request" button's `Task` awaits the view model,
`switch`es over `Result`, and writes into a shared `RequestState`. It also reads
`state.resultText` to decide whether to render a section. A content view is coordinating
three objects.

`Forms/CalculateOffersForm.swift` — `.onAppear { common.calculatedOffers = json.offers }`
mutates shared state from inside a render pass. This is the classic source of
"Modifying state during view update" and it makes the write order depend on layout.

**Fix:** the button forwards intent (`onSubmit`) to the root view; the root view calls the
model and the model owns the result. Publishing offers to shared state happens where the
request completes, not where a view appears.

### 3. Previews exist but do not run (R4)

27 of 59 files carry a `#Preview`, which is genuinely good — but the ones that matter are
broken. `CalculateOffersForm`'s preview injects `RequestState` and not `CommonViewModel`,
while `GenericForm` requires both, so the preview traps at runtime. Same shape in the other
four form previews.

**Fix:** this is R1/R4 telling you the interface is wrong. Once content views take plain
values and closures instead of reaching for `@EnvironmentObject`, their previews become
literals and cannot break.

### 4. Group-by-role folders

`ViewModels/`, `Forms/`, `Models/`, `PropertyInspector/`, `Common/` — every feature is
scattered across four of them. Adding one operation means touching four folders.

### 5. Dead and unreachable code

| Path | Status |
|---|---|
| `ContentView.swift` | SwiftData `@Query private var items: [Claim]`, but the app installs no `ModelContainer` (the block in `…DemoApp.swift` is commented out). Unreachable; crashes if reached |
| `Claim.swift` | The SwiftData model for the above |
| `Common/ClientKey.swift` | Dead + the `fatalError` landmine above |
| `*-Unused.swift` × 4 | `EditorComponents`, `TextFieldFormatted`, `LanguagePickerSection`, `NodeOutlineGroupExpanded` — self-labelled |
| `…DemoApp.swift` | ~25 commented-out lines of the abandoned SwiftData entry point |
| `YandexDeliveryExpressDemoTests.swift`, half of the UI tests | Xcode templates that assert nothing |

Delete all of it. Git remembers.

### 6. Build settings drift

`SWIFT_VERSION = 5.0` across all targets while the package moves to Swift 6 language mode.
Deployment targets disagree between the app (iOS 18.0 / macOS 14.6) and its three test
targets (iOS 18.5 / macOS 15.5). Pick one pair and apply it everywhere.

### 7. The token is in `@AppStorage`

`AuthAndSettingsView` stores an OAuth token in `UserDefaults` — its own `// TODO: use
Keychain` says so. For a demo this is arguably acceptable, but then say so out loud in the
README, because a sample app is code people copy.

---

## Target structure

Feature-first, per `swiftui-app-structure`. The five operations are the features.

```
YandexDeliveryExpressDemo/
├── App/
│   ├── YandexDeliveryExpressDemoApp.swift   # @main — composition root, nothing else
│   ├── RootView.swift                       # was PhaseNavigationView
│   ├── RootView+Operation.swift             # the nested `Phase` enum, renamed
│   ├── ClientController.swift               # @Observable; owns token + Client
│   └── ResultLog.swift                      # @Observable; was RequestState
├── Features/
│   ├── CalculateOffers/
│   │   ├── CalculateOffersView.swift        # root view: binds content to controllers
│   │   ├── CalculateOffersView+Model.swift  # was CalculateOffersViewModel
│   │   └── CalculateOffersView+Content.swift
│   ├── CreateClaim/
│   ├── ClaimInfo/
│   ├── AcceptClaim/
│   └── CancelClaim/
├── Shared/
│   ├── Editors/            # AddressEditor, ContactEditor, CargoItemEditor, … (≥3 consumers)
│   ├── Views/              # Field, SinglePicker, MultiPicker, MeasurementFieldView, SearchBar
│   ├── PropertyInspector/  # the JSON tree viewer — genuinely shared
│   └── Formatting/         # display formatting as extensions on the formatted type
├── Resources/
└── Configuration/
```

Naming follows the layer (`swiftui-app-structure`): root views `…View`, view models
`…View.Model` namespaced beside their root view, content views nested and unsuffixed,
shared controllers `…Controller`. Use Xcode 16 **buildable folders** so the navigator is the
file system.

`Shared/` earns its name only at ≥3 consumers. `Forms/Common/` today holds editors used by
one form each — those move into their feature.

---

## The migration, in order

### Step 1 — Repository skeleton

`git init`, `.gitignore` (copy the package's, but **do commit `Package.resolved`** — this is
an app), README, `CLAUDE.md` (already written, in this directory).

Archive the abandoned spec drafts first (`TechDebt.md` TD-9 in the package):
`yandex-delivery-express-openapi_corrected.yaml`, `_corrected_v2.yaml`,
`express-delivery_corrected.yaml`, and the two Markdown transcriptions. Move them to
`Archive/` with a README naming `../YandexDeliveryExpress/…/openapi.yaml` authoritative, or
delete them. Keep `Базовые запросы.postman_collection.json` — captured traffic is evidence
and feeds the package's test fixtures. Keep `demo-express/` (the HTML reference client) if
it still documents anything; delete it if not.

### Step 2 — Delete

Everything in "Dead and unreachable code" above. Do this before restructuring so you move
less.

### Step 3 — The composition root

```swift
@main
struct YandexDeliveryExpressDemoApp: App {
    @State private var client = ClientController()
    @State private var log = ResultLog()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(client)
                .environment(log)
        }
    }
}
```

`ClientController` is `@Observable`, owns the token and lazily builds the `Client`. It must
**not** be a singleton and must **not** `try!`:

```swift
@MainActor @Observable
final class ClientController {
    private(set) var client: Client?
    private(set) var lastError: Error?

    var token: String = "" { didSet { rebuild() } }

    private func rebuild() {
        do { client = try Client(credentials: .init(authToken: token)) }
        catch { client = nil; lastError = error }
    }
}
```

An unauthenticated app is a *state to render*, not a crash. `AuthAndSettingsView`'s
`// TODO: Error handling, alert` is satisfied by `lastError` plus one alert.

### Step 4 — Observation migration

Mechanical, and cheap at iOS 18. Per the era table in `swiftui-foundations`:

| Now | After |
|---|---|
| `final class X: ObservableObject` | `@Observable final class X` |
| `@Published var` | plain `var` |
| `@StateObject private var m = Model()` | `@State private var m = Model()` |
| `@ObservedObject private var m` | plain `let m` |
| `@EnvironmentObject private var s` | `@Environment(ResultLog.self) private var log` |
| `.environmentObject(x)` | `.environment(x)` |

Two things to watch. `@Observable` and `@Published` cannot coexist on one type — convert each
class whole. And `BaseFormViewModel` is a **class-inheritance** base holding `isLoading` and
`acceptLanguage`, which `@Observable` handles poorly and which is the wrong tool anyway: two
shared properties do not justify a superclass. Prefer `FormViewModelProtocol` alone (drop
`ObservableObject` from its refinement) with the two properties as requirements, or a small
composed `RequestState` value each model owns. Composition over inheritance.

### Step 5 — Push logic out of views (R5, R6)

`GenericForm` becomes a layout container that takes plain values and closures:

```swift
struct OperationForm<Content: View>: View {
    let title: LocalizedStringKey
    let isLoading: Bool
    let isValid: Bool
    let responseText: String
    let onSubmit: () -> Void
    @ViewBuilder var content: () -> Content
}
```

No `@EnvironmentObject`, no `Result` switching, no knowledge of a view model. Its `#Preview`
is then five literals and a no-op closure — R4 for free. The `switch result` moves into each
feature's root view, and `common.calculatedOffers = json.offers` moves into the model's
`execute()`, where the response arrives.

Also replace the hand-rolled `Button { Task { … } }` with a small `AsyncButton` — the file's
own `// TODO: use AsyncButton` — so cancellation and the disabled-while-running rule live in
one place (R10, DRY).

### Step 6 — Content-view interfaces (R1, R2)

Editors currently take generated API types directly (`Binding<Components.Schemas.Address>`,
`[Components.Schemas.RoutePointBase]`). That couples every view to the generated namespace and
means a spec change breaks the UI layer.

Full R1 compliance — plain `String`/`Int`/`Date` in, closures out — is the right target but
it is a large diff. **Do it for the editors that a spec change would break**
(`AddressEditor`, `ContactEditor`, `RoutePointEditor`, `CargoItemEditor`) and accept the
coupling in the leaf pickers, where `swiftui-foundations` explicitly permits it for app-local
views with no reuse prospect. Where a view legitimately holds a model, bridge with the R2
convenience initializer in an extension.

This is also where the package's `value1`/`value2` leak shows up:

```swift
Components.Schemas.RoutePointWithAddress(value1: .init(id: $0.pointId), value2: $0.address)
```

Do not paper over it here — it is `TechDebt.md` TD-5 in the package, fixed in the YAML.
`CalculateOffersView.Model` gets one line shorter when that lands.

### Step 7 — Restructure into feature folders

Move files into the tree above using Xcode 16 buildable folders. Do this **last**: a rename
diff on top of a logic diff is unreviewable. One commit per feature folder
(`atomic-commits`).

### Step 8 — Point at the package by URL

Once `YandexDeliveryExpress` is tagged and pushed, replace the local package reference with
the remote one and commit the resulting `Package.resolved`. Until then use `.package(path:)`
and say so in the README — otherwise the local reference looks like the intended design.

While you are in the dependency list: the app pulls `Flow`, `Helpers`, `MultiPicker`,
`SFSafeSymbols`, `swift-identified-collections`, `better-binding`. Each should survive the
restructure only if it is still used. `SFSafeSymbols` in particular answers the
`// TODO: Use Macro for systemImage` in `RootView` — either adopt it consistently or drop it.

---

## Verification

- [ ] Every `#Preview` in the project renders — this is the single best proxy for R1/R4, and
      it currently fails on the five form previews.
- [ ] `grep -rn "\.shared" --include=*.swift` returns nothing.
- [ ] `grep -rn "try!\|fatalError" --include=*.swift` returns nothing.
- [ ] `grep -rn "ObservableObject\|@Published\|@StateObject\|@EnvironmentObject"` returns nothing.
- [ ] A fresh install with no token shows a sign-in state rather than crashing.
- [ ] All targets share one `SWIFT_VERSION` and one deployment-target pair.
- [ ] The app builds against the package **by URL**, from a clean clone.

Tests: `../YandexDeliveryExpress/Test-Plan.md`, final section.
