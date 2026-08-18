# YandexDostavka

@Metadata { @TechnologyRoot }

The sample app for
[`YandexDeliveryExpressAPI`](https://github.com/laconicman/YandexDeliveryExpress) — a SwiftUI
demo whose job is to show what consuming that package honestly looks like, including the parts
that are awkward.

## Overview

Six screens, one per operation: calculate offers, create a claim, read it back, accept it, ask
what cancelling costs, cancel. The value of this app is that it *runs* against the real API,
so it is the place where the package's ergonomics get judged rather than described.

The package's DocC catalog is authoritative for anything about the API itself. In particular,
read [Working with the Yandex API](https://github.com/laconicman/YandexDeliveryExpress/blob/main/Sources/YandexDeliveryExpressAPI/YandexDeliveryExpressAPI.docc/WorkingWithYandex.md)
before assuming a response shape: that document records what the API does as opposed to what
any specification claims, and it is the reason several things here look defensive.

## Topics

### Project Direction

- <doc:Design>
- <doc:Roadmap>
- <doc:TechDebt>
