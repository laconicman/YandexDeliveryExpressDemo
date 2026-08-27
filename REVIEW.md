# Review Guidelines

Review-specific guidance. `CLAUDE.md` carries this repository's standing rules and is
ingested alongside this file — nothing here restates it. The doubled
`YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/` prefix below is the project's real layout.

## Critical Areas

- Flag any diff that grows `YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Common/ClientEnvironment.swift` — the `static let shared` service
  locator is scheduled for deletion (TechDebt `AD-1`), so changes may only shrink it.
- Reject a new `EnvironmentKey` whose `defaultValue` constructs a `Client`.
- Flag a status flip of an `AD-n` entry in `YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Documentation.docc/TechDebt.md` that does not name
  what discharged it.

## Conventions

- Require a PR that takes on a compromise to add or update an `AD-n` entry in
  `YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Documentation.docc/TechDebt.md`.
- Flag a new `// TODO` in Swift code that carries no `AD-n` register number.
- Flag a new or changed `#Preview` that needs an `.environment(…)` object the diff does not
  provide — a preview that traps at runtime is worse than none (`AD-5`).
- Reject review suggestions to wrap `Components.Schemas.*` types in convenience layers — this
  demo shows the package's rough edges deliberately (`YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Documentation.docc/Design.md`); such
  feedback belongs in the `YandexDeliveryExpress` package repository.

## Anti-patterns to Flag

- Flag `ObservableObject`, `@Published`, `@StateObject`, or `@EnvironmentObject` in **new**
  code — the floor is iOS 18; the direction is `@Observable`/`@State`/`@Environment`.
  Existing occurrences are known (`HANDOFF.md` step 4); new ones move backwards.
- Flag writes to shared state from `.onAppear` or inside `body` — the
  `common.calculatedOffers = …` shape in `YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Forms/CalculateOffersForm.swift` is the known
  offender class ("Modifying state during view update").
- Flag a `Button` action whose `Task` switches over a `Result` inside a view —
  `YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Forms/GenericForm.swift` is the shape being retired; the decision belongs in the view
  model or root view.

## Security

- `YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/AuthAndSettingsView.swift` keeps the OAuth token in `@AppStorage`, accepted for a demo.
  Flag any diff that logs that token or interpolates it into an error message.
- Reject any committed `.xcscheme` or source literal carrying an `AUTH_TOKEN` value.

## Ignore

- Skip `Archive/` (repo root) — superseded specification drafts kept as evidence.
- Skip `Базовые запросы.postman_collection.json` — captured live traffic; evidence, not code.
- Skip `Package.resolved` churn when a dependency bump is the PR's stated purpose.
