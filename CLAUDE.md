# YandexDostavka — sample app

SwiftUI demo for [`YandexDeliveryExpressAPI`](../YandexDeliveryExpress). Same relationship
`Offhook` has to `swift-pjsua`: a separate repository whose job is to show what consuming the
package honestly looks like — including the parts that are awkward.

`HANDOFF.md` is the current restructure plan. The package's DocC catalog is authoritative for
anything about the API itself:
[Design](../YandexDeliveryExpress/Sources/YandexDeliveryExpressAPI/YandexDeliveryExpressAPI.docc/Design.md) ·
[Owning the Specification](../YandexDeliveryExpress/Sources/YandexDeliveryExpressAPI/YandexDeliveryExpressAPI.docc/SpecOwnership.md) ·
[Tech Debt](../YandexDeliveryExpress/Sources/YandexDeliveryExpressAPI/YandexDeliveryExpressAPI.docc/TechDebt.md) ·
[Roadmap](../YandexDeliveryExpress/Sources/YandexDeliveryExpressAPI/YandexDeliveryExpressAPI.docc/Roadmap.md)

## Architecture

Four-layer MVC per `swiftui-app-structure`: Model (structs) → Controller (`@Observable`
classes, injected) → Root view (one per screen, `…View`) → Content views (nested,
unsuffixed). View models are `…View.Model`, namespaced beside their root view — never a
global `ViewModels/` folder. Group by **feature**, not by role.

Deployment floor iOS 18 / macOS 15, above the package's iOS 17, so `Observation` is
unconditional and no backport layer appears in the demonstration path.

## Rules specific to this repository

1. **No singletons.** Shared controllers are created once in `@main` and injected with
   `.environment(_:)`. `X.shared` is a service locator: it hides dependencies and makes
   previews and tests impossible. Both existing ones (`ClientEnvironment.shared`,
   `ClientKey.defaultValue`) are being deleted — do not reintroduce the pattern.
2. **No `try!`, no `fatalError`, in app code.** An unauthenticated or misconfigured app is a
   state to render, not a crash. This repository shipped a `fatalError` on a missing
   environment variable reachable from a clean install.
3. **Every view gets a `#Preview`, and every `#Preview` must run.** A preview that traps
   because an `@Environment` value is missing is worse than no preview — it is a broken
   window. If a preview is hard to write, the view's interface is wrong (R1/R4).
4. **`body` declares structure; it never computes presentation** (R5). No `switch` over
   `Result`, no writes to shared state in `.onAppear`, no formatting. Formatting goes in
   extensions on the formatted type; screen-level derivation goes in the model.
5. **Content views take plain values and closures** (R1/R2), not whole models or view models.
   Bridge from a model with a convenience `init` in an extension. Leaf pickers with no reuse
   prospect may take a generated type — as a decision, not a habit.
6. **Run the R1–R10 checklist** from `swiftui-foundations` before finishing any view.
7. **The demo consumes the package the way a stranger would** — by URL once it is tagged, not
   by local path. If a local path is in use, the README says so and why.
8. **Swift Testing for logic, XCTest only for `XCUIApplication`.** Do not write assertions
   against SwiftUI views; test the pure functions the views call.

## Author's standing preferences

Clarity over brevity. Prefer a vetted SPM (`swift-algorithms`, `SwifterSwift`, …) when the
dependency is smaller than the problem; say so explicitly when it is not. Cite sources in
prose and code comments. DRY, separation of concerns, low coupling / high cohesion first.

## Related skills

`swiftui-app-structure` · `swiftui-foundations` · `swiftui-expert-skill` ·
`swift-file-organization` · `software-development-principles` · `swift-testing-expert` ·
`atomic-commits`
