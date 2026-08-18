# Archive

Superseded material, kept because it is cheaper to keep than to re-derive, and moved here so
nobody mistakes it for something current.

**The authoritative OpenAPI document is
[`../../YandexDeliveryExpress/Sources/YandexDeliveryExpressAPI/openapi.yaml`](../../YandexDeliveryExpress/Sources/YandexDeliveryExpressAPI/openapi.yaml)**,
in the package repository. Nothing in this folder is generated from, or should be used to
regenerate, anything.

This discharges TD-9 in the package's Tech Debt register: four candidate documents sat loose at
this repository's root with no marker saying which one was real, and a future session could have
regenerated the client from the wrong one.

## Abandoned specification drafts

| File | Lines | Why it is not authoritative |
|---|---|---|
| `yandex-delivery-express-openapi_corrected_v2.yaml` | 1,197 | The largest draft, and **missing `/claims/cancel-info` entirely** |
| `yandex-delivery-express-openapi_corrected.yaml` | 457 | Earlier pass over the same ground |
| `express-delivery_corrected.yaml` | 279 | Earliest, narrowest |
| `yandex-delivery-express-openapi.md` | — | Markdown transcription of Yandex's HTML reference |
| `yandex-delivery-other-day-openapi.md` | — | Transcription of the *same-day* API, which the package does not cover |

The live document is 2,006 lines and supersedes all of them. The last one is the exception
worth remembering: it describes a different API surface, and the package's roadmap lists
covering it as a "Later" item, so it is a starting point rather than a discard.

## Web prototype

`demo-express/` and `demo-express.zip` — an HTML/JS prototype from before the SwiftUI app.
Kept as a record of what the flows looked like first.

## What is *not* archived

`../Базовые запросы.postman_collection.json` stays at the repository root. It is a record of
real requests against the live API, which makes it evidence rather than a draft — and this
project has learned the hard way what evidence is worth (see the package's
`WorkingWithYandex` article).
