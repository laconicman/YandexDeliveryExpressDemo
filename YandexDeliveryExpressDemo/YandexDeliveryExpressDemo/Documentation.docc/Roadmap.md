# Roadmap

Priority order. Rationale is in <doc:Design>; what is wrong today is <doc:TechDebt>.

## Now

### The restructure in `HANDOFF.md`

Delete the singletons, move presentation out of `body`, give every view a `#Preview` that
runs. That file is the step-by-step plan and outranks this summary; it gets deleted once this
section is done.

### Make every preview run

Rule 3 of `CLAUDE.md`: a preview that traps because an `@Environment` value is missing is worse
than no preview. This is mostly a consequence of the restructure — views that take plain values
preview with literals.

## Next

### Tests worth having

`ClaimFormatting` and validation are pure functions once presentation leaves the views — test
those. One XCTest `XCUIApplication` smoke test that launches and finds the submit button is
worth more than a suite of view assertions. No live-network UI tests: inject a stub.

## Later

### A screen for what the API actually does

The package's `WorkingWithYandex` records behaviour no reference page mentions — an invented
`return` route point, server-renumbered point ids, two error-code vocabularies. A demo that
surfaced those would teach more than one that hides them.

## See Also

- <doc:Design>
- <doc:TechDebt>
