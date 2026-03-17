# Apple HIG Reference Identity Design

**Date:** 2026-03-17

## Goal
Make the library feel clearly like an Apple HIG reference browser instead of a generic design library, while making each home card understandable at a glance through real iOS context.

## Problem
- The current home title, section labels, and card metadata feel broad and slightly abstract.
- Cards look cleaner than before, but users still need to read the title to understand what each topic represents.
- Thumbnail scenes are more visual now, but many still read like stylized placeholders instead of actual iOS usage contexts.

## Design Direction

### 1. Identity
- Tighten the app tone from a broad “design library” to a focused “HIG reference”.
- Keep the product name recognizable, but add a short, precise supporting line that explains the purpose:
  - “Apple HIG를 실제 화면 맥락으로 훑는 레퍼런스”
- Rename section headers to be more concrete and usage-oriented:
  - `패턴 주제` → `실제 화면 패턴`
  - `구성요소` section should feel like browsable UI building blocks, not abstract categories.

### 2. Card Structure
- Keep the single-column list and edge-to-edge hero thumbnail.
- Treat the thumbnail as the primary identifier.
- Reduce text on the card to:
  - Korean title
  - One short usage-context line
- Remove low-signal metadata from the card surface when it competes with fast scanning.

### 3. Context-First Metadata
- Replace taxonomy-like or documentation-like metadata with user-facing context labels.
- Examples:
  - `패턴 • Launching` → `앱 시작 화면`
  - `패턴 • Searching` → `검색 결과 흐름`
  - `구성요소 • Toggles` → `설정 상태 전환`
  - `구성요소 • Page controls` → `페이지 넘김 탐색`
- Keep English HIG naming available in detail, not as the primary home-card signal.

### 4. Thumbnail Scenes
- Thumbnails should look like small captures of real UI states.
- Prefer recognizable interface fragments over decorative geometry.
- Example directions:
  - Launching: launch surface transitioning into first content row
  - Searching: search field, recent/result rows, highlighted result context
  - Modality: parent screen plus lifted sheet edge
  - Menus: anchor content with visible contextual menu
  - Toggles: settings-style row with real on/off affordance
  - Page controls: horizontal page card with dots and visible active page

### 5. Detail Hierarchy
- Keep the large hero preview in detail.
- Preserve richer documentation in detail, but keep home as the fast-scan entry point.
- English path (`Patterns • Launching`) remains useful in detail for reference fidelity.

## Expected Outcome
- The first screen should communicate “this is an Apple HIG reference browser”.
- Each card should be understandable from the thumbnail and short context line without requiring paragraph reading.
- The app should feel less like a generic design showcase and more like a practical iOS reference tool.
