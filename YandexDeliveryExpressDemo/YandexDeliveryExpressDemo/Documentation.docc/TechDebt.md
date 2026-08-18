# Tech Debt

Compromises this app carries. Each names what it costs and what would retire it. Reference one
from code as `// TODO(AD-n)` — *AD* for app debt, so these never collide with the package's
`TD-n`.

## AD-1 — `ClientEnvironment.shared` is a singleton — **blocking the restructure**

A service locator: it hides the dependency, and it makes previews and tests of anything that
touches the client impossible. Rule 1 of `CLAUDE.md` names it for deletion. Its sibling
`ClientKey.defaultValue` is already gone.

- **Cost:** every view model reaches into a global instead of receiving one, so none of them
  can be exercised with a stub.
- **Discharge:** create the client once in `@main` and inject it with `.environment(_:)`.

## AD-2 — Presentation logic lives in `body` — **open**

Formatting, filtering and derivation computed inside views, against rule 4 and R5 of
`swiftui-foundations`.

- **Cost:** none of it is testable, and the views cannot be reused or previewed cheaply.
- **Discharge:** display formatting into extensions on the formatted type; screen-level
  derivation into the view model.

## AD-3 — Views take whole models — **open**

Content views that accept a generated schema type or a view model rather than the plain values
they render (R1). The course allows it for a leaf with no reuse prospect *and* an easy preview;
that is a decision each time, not the default.

- **Cost:** couples views to the package's generated types, which the package intends to change
  (its TD-5 flattening).
- **Discharge:** plain values plus a convenience `init` in an extension (R2).

## AD-4 — The app consumed the package by path — **discharged**

The project referenced `../../../Gateways/YandexDeliveryExpress` by relative path, so a clean
clone proved nothing about the published product.

- **Discharged by:** an `XCRemoteSwiftPackageReference` to
  `https://github.com/laconicman/YandexDeliveryExpress`, `upToNextMajorVersion` from `0.1.0`,
  with `Package.resolved` committed. Verified by *building*, not merely resolving: the compile
  reads `SourcePackages/checkouts/`, not the sibling working copy.
- **Cross-editing is unaffected.** Drag the local package folder into the Xcode project and the
  local override wins over the remote of the same name — SwiftPM's supported workflow, and the
  reason this manifest never has to be edited back and forth.

## AD-5 — Almost no previews, and no tests — **open**

- **Cost:** rule 3 exists because a broken window invites more. And with logic in views, there
  is nothing a test could reach.
- **Discharge:** downstream of AD-1 to AD-3. Fixing the interfaces makes previews literals and
  logic testable; both are symptoms rather than causes.

## See Also

- <doc:Design>
- <doc:Roadmap>
