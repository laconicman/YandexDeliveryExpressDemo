# Design

Load-bearing decisions for the demo, each with the alternative that was rejected. Where this
and `CLAUDE.md` disagree, believe this.

## The app is a demonstration, and that changes what "good" means

Its purpose is to show a stranger what using the package feels like. So the awkward parts of
the API surface are shown rather than hidden: if `RoutePointWithAddress` needs `value1`/`value2`
at the call site, this app writes `value1`/`value2`. A demo that papers over a rough edge is
lying about the thing it demonstrates.

**Rejected:** a convenience layer in the app. It would make the demo read better and the
package look better than it is. When an edge is bad enough to hide, the fix belongs in the
package — that is what its Tech Debt register is for.

## Four-layer MVC, per Manferdini

Model (structs) → Controller (`@Observable`, injected) → Root view, one per screen → Content
views. View models are `…View.Model`, namespaced beside their root view rather than gathered in
a `ViewModels/` folder. Group by **feature**, not by role.

The app does not fully obey this yet; `HANDOFF.md` is the migration.

## Sample data ships, deliberately

`Models/SampleData.swift` holds the route points, contacts and cargo items the previews use —
and that `CalculateOffersView.Model` and its `CreateClaim` twin read at *runtime* to prefill
their forms.

Manferdini puts preview data in a `Preview Content` group, "only available for Xcode previews
but won't be included in the final build" (*SwiftUI Structural Foundations* 2.3). This app
deviates because a demo's prefilled state is the product, not scaffolding, and data the
shipping build needs cannot live in development assets.

The rule that follows: **anything a view model reads stays in `Models/`; anything used only by
a `#Preview` belongs in `Preview Content/`.** The pattern itself — static values in type
extensions so `.example…` resolves by inference — is his, unchanged.

**Rejected:** keeping it in the package. It was `public` API there, which put 452 lines of
sample addresses into every consuming app's binary (the package's TD-12).

## Sample data has to be valid, not merely plausible

`exampleExpressDelivery` once set `cargoLoaders: 1` on the `express` tariff. The live API
refuses that with `409 estimating.too_many_loaders`, so every request built from it failed —
and no offline test could tell, because a stub transport accepts whatever you send it.

Sample data that feeds real calls is checked against the API, not eyeballed.

## The deployment floor is iOS 18 / macOS 15

Above the package's iOS 17, on purpose: `Observation` is unconditional and no backport layer
appears in the demonstration path. A demo carrying compatibility scaffolding demonstrates the
scaffolding.

## See Also

- <doc:Roadmap>
- <doc:TechDebt>
