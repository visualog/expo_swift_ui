# Library Media-First Cards Design

**Context**

The Apple design library home screen is now a one-column list, but the cards still read as text-first. The preview thumbnail helps, yet it does not carry enough visual weight to make each topic legible at a glance. The detail screen has the same issue: the live preview exists, but the metadata card often competes with it.

**Decision**

Shift both home cards and the detail header toward a media-first layout.

- Home cards should feel closer to App Store or Arcade editorial cards: larger preview first, lighter text payload second.
- The home card thumbnail should occupy most of the card's visual weight and work as the primary recognition signal.
- The detail screen should elevate the interactive preview hero and reduce the visual dominance of metadata and helper copy.

**Scope**

- Increase home card thumbnail height and rebalance card spacing around it.
- Keep only the minimum text payload in home cards: title plus one metadata line.
- Increase the detail preview hero height and reduce the prominence of the interaction hint.
- Preserve native navigation, segmented control behavior, and existing semantic color/type tokens.

**Non-goals**

- Reworking the full content model for topics.
- Replacing the native segmented control or tab structure.
- Adding new data fields or new library sections.

**Success criteria**

- Topics are easier to scan visually before reading.
- The home screen feels less like a document list and more like a visual reference library.
- The detail screen presents the interactive sample as the primary content.
