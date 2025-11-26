
# Responsive Header & Footer — Edit Instructions for LLM

## Task

Modernize the app header/footer so the site is responsive and displays correctly on mobile. On narrow screens the header’s icon area should become a Drawer (hamburger menu) containing the same navigation/actions. Preserve desktop behavior.

## Files to edit

- Primary: `lib/views/common_widgets.dart`
- Only touch additional files if absolutely necessary and explain why.

## Context

This is a Flutter web app that currently uses fixed sizes and desktop-only `Row` layouts. The header contains a top banner and a main header with logo, many `TextButton` links, and a row of icon buttons. The footer uses a `Row` with multiple `Column`s that currently do not stack on small screens.

## Requirements / Acceptance Criteria

- Use responsive techniques (`MediaQuery`, `LayoutBuilder`, `OrientationBuilder`, `Flexible`, `Expanded`, `Wrap`) instead of fixed widths/heights.
- Desktop behavior must remain unchanged for wide screens (>= 600 logical pixels).
- For small screens (< 600 logical pixels):
	- Replace the horizontal nav buttons with a `Drawer` (open via a hamburger icon). The drawer must include the same nav targets: Home, Shop, The Print Shack, SALE!, About, plus actions (Search, Account, Bag) as items or icons.
	- The logo becomes a tappable smaller image that still navigates Home.
	- Icon buttons may remain available in the drawer or as a compact icon row — choose the option that yields the best mobile UX.
	- Banner text and font sizes scale down to avoid overflow.
	- Footer columns stack vertically and form a scrollable column if needed. The email input should expand to full width on mobile.
- Avoid hard-coded `Container` heights that force overflow on mobile (e.g., `height: 120`). Prefer flexible sizing or min/max constraints.
- Preserve existing navigation functions (`navigateToHome`, `navigateToProduct`, `navigateToAbout`) and their behavior (`Navigator.pushNamed` etc.).
- Keep changes minimal and localized to `common_widgets.dart` unless absolutely necessary; keep API and function names consistent.
- Maintain accessibility: tappable areas should be at least 44x44 logical pixels where applicable.

## Deliverables

- A patch (or file contents) showing the edits to `lib/views/common_widgets.dart` and any additional files if changed.
- A short explanation of each change (2–4 bullets).
- A short testing checklist and commands to run (`flutter analyze`, `flutter test`) and how to verify in an emulator or Chrome.
- A brief note if additional files were modified and the rationale.

## Edge Cases & Constraints

- Do not remove or rename the existing navigation functions — keep `navigateToHome`, `navigateToProduct`, `navigateToAbout` semantics.
- Ensure widgets do not overflow on very small widths or in landscape mobile.
- Keep color, fonts, and general style unchanged unless necessary for layout.

## How I’ll verify

- On a desktop browser (or wide emulator) the header/footer look as before.
- On a mobile-width browser (or mobile emulator), the header shows a compact logo plus a hamburger icon that opens a `Drawer` with the navigation and actions; footer stacks vertically and subscription input fills width.
- No analyzer errors; unit tests pass.

## Optional example output

- Provide the updated `common_widgets.dart` content or an `*** Begin Patch` / `*** Update File:` style patch that the repository maintainer can apply directly.

## Testing commands

Run these from the project root (PowerShell example):

```powershell
flutter analyze
flutter test
flutter run -d chrome
```

## Notes for the implementer

- Minimize changes; prefer composition over large structural rewrites.
- If adding a `Drawer` requires returning a widget that expects a `Scaffold`, provide a small wrapper function or document how to integrate it into existing `Scaffold` usage.
- Keep accessibility and touch sizes in mind.

---