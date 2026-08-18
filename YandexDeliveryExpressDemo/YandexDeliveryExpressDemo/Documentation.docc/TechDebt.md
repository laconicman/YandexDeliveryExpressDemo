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

## AD-4 — A clean clone cannot build — **open**, half done

The project referenced **two** packages by relative path. One is fixed; the other is not, so
the property this item is actually about — a clean clone builds — is still false.

`YandexDeliveryExpressAPI` is now an `XCRemoteSwiftPackageReference` to
`https://github.com/laconicman/YandexDeliveryExpress`, `upToNextMajorVersion` from `0.1.0`,
with `Package.resolved` committed. Cross-editing is unaffected: dragging the local package
folder into the project still overrides the remote of the same name, which is why this manifest
never has to be edited back and forth.

**`ReflectionHelper` is the remainder**, and it is worse than a path — see AD-6.

- **Cost:** unchanged and unreduced. The one thing a sample app exists to prove is still
  unproven, because *any* unresolvable dependency fails the whole graph.
- **Discharge:** AD-6, then re-run the check below.
- **The check, which is the actual acceptance criterion.** Resolving in the working copy proves
  nothing, because every local path still exists there. Clone somewhere else and resolve:

  ```console
  % git clone https://github.com/laconicman/YandexDostavka /tmp/clone
  % cd /tmp/clone/YandexDeliveryExpressDemo
  % xcodebuild -resolvePackageDependencies -scheme YandexDeliveryExpressDemo
  ```

  This was skipped the first time, which is how AD-4 came to be marked discharged while still
  broken: the change was verified, the claim was not.

## AD-6 — `ReflectionHelper` exists only on one machine — **open**

`PropertyInspector/` imports `ReflectionHelper`, a package at
`../../../OpenSource/ReflectionHelper` — outside this workspace, a git repository with two
commits, **no remote, and no counterpart on GitHub**. A clean clone fails to resolve:

```
the package at '…/OpenSource/ReflectionHelper' cannot be accessed (doesn't exist in file system)
```

It is not scaffolding: `FilteredPropertyInspectorView` is reachable from two live screens,
`CreateClaimForm` and `CalculateOffersForm`, where it renders the decoded response for
inspection. That is arguably the most instructive thing this demo does.

- **Cost:** nobody but the author can build this app, which makes the repository private in
  effect regardless of its setting.
- **Discharge — the author's call, and the options differ in kind rather than degree:**
  1. **Publish it.** One 236-line source file with tests; a real, if small, reusable package.
     Then reference it by URL like everything else.
  2. **Vendor it.** Copy the source into the app and delete the dependency. The author's
     standing preference is to prefer a vetted SPM *when the dependency is smaller than the
     problem* — and to say so explicitly when it is not. At 236 lines of `Mirror` plumbing
     against a package that has to be published, tagged and maintained, this is a case where
     it plausibly is not.
  3. **Drop the feature.** Cheapest, and the worst trade: the property inspector is the part of
     the demo that shows what a decoded response actually contains.

## AD-5 — Almost no previews, and no tests — **open**

- **Cost:** rule 3 exists because a broken window invites more. And with logic in views, there
  is nothing a test could reach.
- **Discharge:** downstream of AD-1 to AD-3. Fixing the interfaces makes previews literals and
  logic testable; both are symptoms rather than causes.

## See Also

- <doc:Design>
- <doc:Roadmap>
