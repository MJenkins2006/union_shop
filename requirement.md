 # Responsive Header & Footer — Requirements

This file captures concise, testable requirements derived from `prompt.md` for implementing a responsive header and footer in the app.

- **Goal**: Modernize the app header and footer so the site is responsive and displays correctly on mobile while preserving desktop behavior.

- **Primary file to edit**: `lib/views/common_widgets.dart`. Do not modify other files unless absolutely necessary and document the reason.

- **Breakpoints**:
	- **Desktop / Wide**: width >= 600 logical pixels — preserve current desktop layout and behavior.
	- **Mobile / Narrow**: width < 600 logical pixels — apply mobile layout rules below.

- **Header (mobile rules)**:
	- Replace the horizontal nav buttons with a `Drawer` opened by a hamburger icon.
	- Drawer contents must include: Home, Shop, The Print Shack, SALE!, About, plus actions Search, Account, Bag (as items or icons).
	- The logo becomes a smaller tappable image that still navigates Home via existing `navigateToHome` semantics.
	- Banner text and fonts must scale down to avoid overflow (use `MediaQuery`, `LayoutBuilder`, `Flexible`, `Wrap`, etc.).
	- Ensure tappable areas are >= 44x44 logical pixels for accessibility.

- **Header (desktop rules)**:
	- Preserve the existing layout and navigation behavior for widths >= 600.
	- All existing functions and routes (`navigateToHome`, `navigateToProduct`, `navigateToAbout`) must remain available and keep the same semantics.

- **Icons / Actions**:
	- On mobile, icon actions (Search, Account, Bag) may be placed inside the Drawer or as a compact icon row — choose whichever avoids clutter and overflow while keeping actions accessible.

- **Footer (mobile rules)**:
	- Footer columns must stack vertically on narrow screens and become scrollable if content exceeds viewport height.
	- The email input / subscription field must expand to full width on mobile and remain usable (no horizontal scrolling required).
	- Avoid fixed container heights that force overflow; use flexible sizing or min/max constraints.

- **Implementation constraints**:
	- Use responsive techniques (`MediaQuery`, `LayoutBuilder`, `OrientationBuilder`, `Flexible`, `Expanded`, `Wrap`) instead of hard-coded sizes.
	- Keep changes minimal and localized to `lib/views/common_widgets.dart` unless a true blocker is encountered.
	- Maintain color, fonts, and general visual style unless layout requires minor adjustments to prevent overflow.

- **Accessibility**:
	- Maintain sufficient tap target sizes (>= 44x44 logical pixels) and ensure Drawer items are keyboard and screen-reader reachable.

- **Testing & Verification**:
	- Run from project root:

```powershell
flutter analyze
flutter test
flutter run -d chrome
```

	- Verification checklist:
		- On wide desktop (>= 600) the header/footer look and behave as before.
		- On narrow mobile (< 600) the header shows a compact logo and a hamburger icon that opens the Drawer containing navigation and actions.
		- Footer columns stack vertically and the subscription input fills the width.
		- No analyzer errors and unit tests pass.

- **Edge cases & constraints**:
	- Do not rename or remove `navigateToHome`, `navigateToProduct`, or `navigateToAbout` functions.
	- Prevent overflow on very small widths and landscape mobile orientations.
	- Keep changes focused; do not attempt to refactor unrelated widgets.

---

If modifying other files becomes necessary (for example integrating a `Drawer` requires a `Scaffold` change), document the exact file(s) changed and the rationale in the final patch notes.

---

# 3-Slide Carousel — Requirements

- **Goal**: Add a responsive, accessible carousel at the top of `HomeScreen` (`lib/views/home_screen.dart`) with exactly three slides:
	- Slide 1: Essential Range — reuse the existing slide/widget already present in the project.
	- Slide 2: About Us — a card-like slide with title/subtitle; tapping the slide navigates to `lib/views/about_screen.dart`.
	- Slide 3: Collections — a full-bleed image loaded from `assets/images/collections.jpg`; tapping the slide navigates to `lib/views/collections_screen.dart` (create a minimal placeholder if missing).

- **Primary file to edit**: `lib/views/home_screen.dart`. Minimal additions allowed to `pubspec.yaml` (asset reference) and `lib/views/collections_screen.dart` (placeholder) only if necessary.

- **Layout & Behavior**:
	- Use a `PageView` with a `PageController` (no external packages required). Add visible page indicator dots below the carousel.
	- Keep the carousel full-width at the top of the screen and maintain a fixed aspect ratio (recommend `AspectRatio(aspectRatio: 16/7)`).
	- Support swipe gestures and optionally autoplay (advance every ~4s) implemented with a `Timer` and `PageController`.
	- Provide `Semantics` labels for each slide for accessibility.

- **Navigation & Integration**:
	- Use existing Navigator patterns (e.g., `Navigator.of(context).push(...)`) or existing navigation helper functions where appropriate.
	- Do not rename or remove `navigateToHome`, `navigateToProduct`, or `navigateToAbout`.

- **Accessibility & Touch Targets**:
	- Ensure tappable areas are at least 44x44 logical pixels.
	- Slides should include semantic descriptions for screen readers.

- **Assets**:
	- Add `assets/images/collections.jpg` to `pubspec.yaml` under `flutter/assets:`; the binary image file should be added to the repo by the implementer.

- **Acceptance Criteria**:
	- Carousel is visible at the top of `HomeScreen` and contains exactly three slides as described.
	- Tapping the About slide navigates to `about_screen.dart`.
	- Tapping the Collections slide navigates to `collections_screen.dart`.
	- Page indicator updates when swiping; autoplay advances pages roughly every 4s if enabled.
	- No analyzer errors introduced.

- **Testing & Verification (PowerShell)**:
	```powershell
	flutter pub get
	flutter analyze
	flutter test test/home_test.dart
	flutter run -d chrome
	```
	- Suggested test: pump `HomeScreen` and assert a `PageView` with 3 children exists; simulate taps on slides and assert navigation.

- **Edge Cases & Constraints**:
	- Keep changes localized to `home_screen.dart`; only modify other files when strictly necessary and document why.
	- Ensure no overflow on very small widths or landscape mobile orientations.
	- Maintain app theme styling (colors/fonts) unless a minor change is required to prevent overflow.

---

# Collections Screen — Filter & Sort Requirements

- **Goal**: Add responsive, accessible filtering and sorting controls to the existing `Collections` screen so users can quickly narrow and reorder the visible collections without rebuilding the full screen.

- **Primary file to edit**: `lib/views/collections_screen.dart`. Keep changes minimal and local; make the screen a `StatefulWidget` only if needed for local state (filters/sort). Do not modify `CollectionCard` API or the underlying data model unless strictly necessary.

- **Controls & Behavior**:
	- **Sorting**: Provide a control to choose sort order with two options: `A → Z` and `Z → A` (use `DropdownButton` or `PopupMenuButton` on narrow screens, or `ToggleButtons`/segmented control on wide screens). Default is `A → Z`.
	- **Filtering**: Display a set of selectable filter chips (`ChoiceChip` or `FilterChip`) representing categories/tags derived from available collection data. Support multiple simultaneous filters (multi-select).
	- **Clear / Reset**: Include a clear or reset action that removes all active filters and returns sorting to default.
	- **Live updates**: Changing filters or sort order updates the visible list immediately using local state (`setState`) without rebuilding or re-fetching the entire page.

- **Layout & Responsiveness**:
	- On **wide screens** the controls appear in a single horizontal row with sorting and the chips aligned.
	- On **narrow screens** the controls wrap or stack vertically using `Wrap` or `LayoutBuilder` to avoid overflow; ensure no horizontal scrolling is required to reach controls.
	- Maintain minimum tappable area sizes (>= 44x44 logical pixels) for chips and control buttons.

- **Implementation details**:
	- Derive the visible list with a pure helper function, e.g. `List<CollectionModel> applyFiltersAndSort(List<CollectionModel> all, SortOrder order, Set<String> filters)` which returns a new list and does not mutate the source.
	- Keep the existing `List<CollectionModel> collections` source intact; compute `visible = applyFiltersAndSort(collections, sortOrder, activeFilters)` before building the `ListView.builder`.
	- Use efficient UI updates: only call `setState` to update local `sortOrder` and `activeFilters` and let the helper recompute `visible`.

- **Accessibility**:
	- Make chips and the sorting control reachable by keyboard and provide `Semantics` labels (e.g., "Filter by X", "Sort order dropdown").
	- Ensure controls have readable labels and focus indicators.

- **Return to Home**:
	- Add a `Return to Home` button below the collection list and above the footer. Use the existing `navigateToHome` helper or `Navigator.pushNamed` as appropriate.

- **Acceptance criteria**:
	- Sorting control offers `A → Z` and `Z → A` and updates list immediately when changed.
	- Filter chips reflect available categories/tags and selecting chips filters the visible `CollectionCard` widgets live.
	- Controls wrap or stack on narrow screens and remain usable (no overflow). Minimum tappable areas are preserved.
	- `applyFiltersAndSort` is pure and unit-testable; no mutation of original `collections` list.
	- A `Return to Home` button is present and navigates home.

- **Testing & Verification (PowerShell)**:
	- From project root:

```powershell
flutter analyze
flutter test
flutter run -d chrome
```

	- Manual checks:
		- On wide and narrow viewports verify controls layout (horizontal vs wrapped/stacked).
		- Select filters and sort orders and verify the list updates immediately and correctly.
		- Tap `Return to Home` and verify navigation.

- **Automated tests recommended**:
	- Unit tests for `applyFiltersAndSort` covering combinations of filters and both sort orders.
	- Widget tests that pump `Collections` screen, simulate selecting chips and dropdown changes, and assert visible `CollectionCard` count and order.

- **Edge cases & constraints**:
	- Do not change the `CollectionCard` constructor or public API.
	- Handle empty `visible` lists gracefully with a friendly empty-state message and a `Return to Home` button.
	- Ensure the controls remain usable in landscape mobile orientations and on very small widths.
	- Avoid introducing new dependencies; use Flutter built-in widgets.

---

	# Collection Detail Route — Requirements

	- **Goal:** Make individual collection pages routable and minimally functional. When a user clicks a collection (for example, "Cards") they should land at `/collections/Cards` and see a centered message `Cards page`.

	- **Primary file(s) to edit:**
		- Prefer minimal edits: update router definitions (e.g., `main.dart` or your router file) to add a `/collections/:id` handler. Do not restructure unrelated navigation.
		- Ensure `lib/views/collection_screen.dart` reads an incoming `id` parameter (keep the existing `CollectionScreen({required String id})` API) and displays `"<id> page"` in a centered, accessible `Text` widget.

	- **Routing rules:**
		- Support a dynamic route `/collections/:id` (URL-encoded). If the project uses `go_router`, add a `GoRoute(path: '/collections/:id', ...)` and use `context.go('/collections/${Uri.encodeComponent(id)}')` from the Collections list. If not using `go_router`, add an `onGenerateRoute` entry or a named route mapping that extracts the `id` segment and constructs `CollectionScreen(id: id)`.
		- When constructing or displaying the `id`, decode it with `Uri.decodeComponent` for safety.

	- **Collections list navigation:**
		- Update the `CollectionCard` or collection list `onTap` handler to navigate to the detail route. Prefer the `go_router` call when available:

			- `onTap: () => context.go('/collections/${Uri.encodeComponent(title)}');`

			- Fallback: `Navigator.pushNamed(context, '/collections/$encodedTitle');` with appropriate `onGenerateRoute` handling.

	- **Accessibility:**
		- Add a `Semantics` label on the detail screen such as `"<id> collection page"` and make sure the central `Text` is reachable by screen readers.

	- **Deliverables:**
		- Router change (file and minimal diff noted) adding `/collections/:id`.
		- `lib/views/collection_screen.dart` (or a new `collection_detail_screen.dart`) that reads `id` and shows `"<id> page"` centered.
		- One-line note showing the exact navigation call added to the collection list (example above).

	- **Acceptance criteria:**
		- Visiting `/collections/Cards` shows a page with centered text `Cards page`.
		- Tapping a collection in the Collections screen navigates to the matching URL.
		- No other navigation routes are broken.

	- **Testing steps (from project root):**
		- `flutter pub get` (if router package or router files changed)
		- `flutter analyze`
		- `flutter test`
		- `flutter run -d chrome` then visit `http://localhost:xxxx/#/collections/Cards` (replace host/port shown by flutter) and confirm `Cards page` appears.

	- **Notes & constraints:**
		- Keep changes minimal and local to routing and the collection list handler. Do not rename existing navigation helper functions such as `navigateToHome`, `navigateToProduct`, or `navigateToAbout`.