# YandexDeliveryExpressDemo

The sample app for [`YandexDeliveryExpressAPI`](https://github.com/laconicman/YandexDeliveryExpress) —
a SwiftUI demo whose job is to show what consuming that package honestly looks like, including
the parts that are awkward.

Six screens, one per operation: calculate offers, create a claim, read it back, accept it, ask
what cancelling costs, cancel.

> **Unofficial**, and unaffiliated with Yandex. The API it talks to has no published OpenAPI
> document; the package's is hand-written.

> **Renamed** from `YandexDostavka` on 2026-08-27, to match the Xcode project it contains.
> That name now belongs to the product app built on the same package, so a stale remote
> pointing at `laconicman/YandexDostavka` reaches a different repository — update it with
> `git remote set-url origin git@github.com:laconicman/YandexDeliveryExpressDemo.git`.

## Documentation

The DocC catalog is authoritative for this app's direction:

| Article | What it answers |
|---|---|
| [Design](YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Documentation.docc/Design.md) | Load-bearing decisions, with the alternative that was rejected |
| [Roadmap](YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Documentation.docc/Roadmap.md) | Planned work in priority order |
| [Tech Debt](YandexDeliveryExpressDemo/YandexDeliveryExpressDemo/Documentation.docc/TechDebt.md) | Every compromise carried, what it costs, what retires it (`AD-n`) |

`HANDOFF.md` is the current restructure plan and gets deleted once consumed. `CLAUDE.md`
carries the rules an agent working here must follow.

**For anything about the API itself, the package's catalog is authoritative** — start with
[Working with the Yandex API](https://github.com/laconicman/YandexDeliveryExpress/blob/main/Sources/YandexDeliveryExpressAPI/YandexDeliveryExpressAPI.docc/WorkingWithYandex.md),
which records what the API does as opposed to what any document claims.

Render this app's catalog with:

```console
% xcodebuild docbuild -scheme YandexDeliveryExpressDemo -derivedDataPath .build/docs \
    -skipPackagePluginValidation
```

That is a one-time setup cost, unlike the package's `swift package generate-documentation`.

## Running it

Open `YandexDeliveryExpressDemo/YandexDeliveryExpressDemo.xcodeproj`, and set `AUTH_TOKEN`
under Edit Scheme → Run → Environment. Without it the client cannot authenticate; with an
invalid one the API answers `401 unauthorized`, which the app shows as a documented response
rather than a crash.

Never commit the token. `.gitignore` carries patterns for the obvious filenames, but the real
protection is keeping the only copy outside every repository.

```console
% xcodebuild build -scheme YandexDeliveryExpressDemo \
    -destination 'generic/platform=iOS Simulator' -skipPackagePluginValidation
```

`-skipPackagePluginValidation` is required: the package uses the OpenAPI generator build
plugin, and non-interactive builds otherwise fail on its trust prompt with no useful message.

## The package dependency

Currently a **local** reference to `../../../Gateways/YandexDeliveryExpress`, which is SwiftPM's
sanctioned local-override workflow and is what makes cross-editing the package and its consumer
in one session possible.

It is also a known gap — a clean clone does not prove the published product builds, which is
the one thing a sample app exists to demonstrate. Switching to the tagged URL is Tech Debt
`AD-4`, now that the package is at `0.1.0`.

Requires iOS 18 / macOS 15, above the package's iOS 17 floor, so `Observation` is unconditional
and no backport layer appears in the demonstration path.

## License

Apache 2.0 — see [LICENSE](LICENSE).
