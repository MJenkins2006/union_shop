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

# 3-Slide Carousel Prompt (for another LLM)

Please add the following task at the top of `HomeScreen` in `lib/views/home_screen.dart`.

- Goal: Create a responsive, accessible carousel with exactly three slides positioned at the top of the `HomeScreen`.
	- Slide A (keep): Essential Range — reuse the existing slide/widget already present in the project.
	- Slide B: About Us — visually similar card with title/subtitle; tapping the slide navigates to `lib/views/about_screen.dart`.
	- Slide C: Collections — full-bleed image loaded from `assets/images/collections.jpg`; tapping the slide navigates to `lib/views/collections_screen.dart` (create a minimal placeholder screen if missing).

- Implementation guidance:
	- Use a `PageView` with a `PageController` (no extra package required). Add visible page indicator dots below the carousel (e.g., `AnimatedContainer` or small indicators row).
	- Keep the carousel full-width with a fixed aspect ratio (recommend `AspectRatio(aspectRatio: 16/7)`).
	- Support swipe gestures and (optionally) autoplay that advances every ~4 seconds using a `Timer` and `PageController`.
	- Provide accessibility `Semantics` labels for each slide (e.g., "Essential Range slide", "About Us slide", "Collections slide").
	- Use `Navigator.of(context).push(...)` to navigate to the About and Collections screens. Reuse existing navigation functions where appropriate.
	- Keep styling consistent with the app theme (use `Theme.of(context)` text styles and colors).

- Files to touch:
	- `lib/views/home_screen.dart` — add a `TopCarousel` widget or inline `PageView` that contains the three slides. Reuse existing Essential Range UI as the first child.
	- `lib/views/collections_screen.dart` — add a minimal placeholder screen if the app doesn't already have one.
	- `pubspec.yaml` — add `assets/images/collections.jpg` under `flutter/assets:` (instruct the developer to add the actual image file into the repo).

- Quick acceptance criteria:
	- Carousel is at the top of `HomeScreen`, full-width and responsive.
	- There are exactly three slides as described.
	- Tapping About navigates to `about_screen.dart`; tapping Collections navigates to `collections_screen.dart`.
	- Page indicator updates correctly and autoplay advances pages roughly every 4s if enabled.

- Quick test/run commands (PowerShell):
```powershell
flutter pub get
flutter analyze
flutter test test/home_test.dart
flutter run -d chrome
```

---

# Collections Screen — Filter & Sort Prompt (for another LLM)

I currently have a `Collections` screen that builds its content by looping over a list and creating `CollectionCard` widgets for each item. I want to add UI for filtering and sorting the displayed collections.

Requirements:

- Add a responsive control area at the top of the `Collections` screen that includes:
	- A drop-down or segmented control to choose sorting order: `A → Z` and `Z → A`.
	- A set of filter chips to filter collections (e.g., by category or tag). Do not include a free-text search field — filtering must be driven by selectable chips only.
	- A clear / reset option to remove filters and return to the default sort.
- The collection list should update live as the user changes filters or sort order without rebuilding the entire screen.
- Keep the existing `CollectionCard` widgets and overall page structure; the LLM should suggest only UI additions and small data transformations (e.g., creating a filtered/sorted view of the existing list).
- Use responsive layout so the controls are horizontal on wide screens and stack vertically or wrap on narrow screens (use `LayoutBuilder`, `Wrap`, `MediaQuery` as appropriate).
- Preserve accessibility and minimum tappable sizes (>= 44x44 logical pixels).
- Prefer Flutter built-in widgets (`DropdownButton`, `ChoiceChip`, `TextField`, `ListView.builder`, etc.) and avoid introducing new packages.

Integration notes for the developer:

-- The LLM's suggested code should assume the `Collections` screen already has a `List<CollectionModel> collections` or similar as its source. Provide a snippet that derives `List<CollectionModel> visible = applyFiltersAndSort(collections, sortOrder, activeFilters);` prior to building the list. (No search query parameter should be used.)
- Keep state management minimal: `StatefulWidget` with local `setState` updates is acceptable. If proposing a provider/riverpod approach, include a short migration note.
- Ensure the filtering/sorting functions are pure and testable (return new lists, do not mutate the source list).

Acceptance criteria:

- The `Collections` screen shows sorting and filtering controls at the top.
- Tapping or selecting controls instantly updates the visible `CollectionCard` widgets.
- On narrow screens controls wrap/stack without overflow and remain usable.
- No breaking changes to existing navigation or `CollectionCard` API.
 - A `Return to Home` button is present below the `CollectionCard` list and above the footer; tapping it navigates to the Home screen (use the existing `navigateToHome` helper or `Navigator.pushNamed` as appropriate).

Testing guidance:

- Manual: open the Collections screen in Chrome with narrow and wide widths, test sorting and filtering UI, ensure no overflow.
- Automated: recommend unit tests for the pure `applyFiltersAndSort` function (input list, order, filters → expected output).