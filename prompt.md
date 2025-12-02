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

---

# Collection Detail Route — Short Prompt (for another LLM)

Make individual collection pages routable and minimal: clicking a collection (e.g., "Cards") should open `/collections/Cards` and show a centered text `Cards page`.

Instructions

- Add or ensure a route that handles `/collections/:id` and instantiates `lib/views/collection_screen.dart` with the `id` parameter. Keep `CollectionScreen({required String id})` as the constructor.
- Update the Collections list item tap handler so tapping a `CollectionCard` navigates to the collection detail route. Prefer `go_router` if present (example):

	- `context.go('/collections/${Uri.encodeComponent(title)}');`

	Otherwise use named navigation or `onGenerateRoute`:

	- `Navigator.pushNamed(context, '/collections/$title');`

- Decode the route parameter safely when displaying (use `Uri.decodeComponent`) and add a simple `Semantics` label like `"<id> collection page"`.
- Keep changes minimal and self-contained: add the route (or update router file) and the navigation call in the Collections list.

Deliverables

- Router change adding `/collections/:id` (e.g., in `main.dart` or router file).
- Ensure `lib/views/collection_screen.dart` reads the `id` and displays `"<id> page"` centered.
- A short note showing the navigation call added to the `CollectionCard` (example: `onTap: () => context.go('/collections/${title}')`).

Testing

- `flutter pub get` (if router packages changed)
- `flutter analyze`
- `flutter test`
- `flutter run -d chrome` and verify `http://localhost:xxxx/#/collections/Cards` displays `Cards page`.

---

# Cart Page — LLM Prompt

Goal: Add a responsive, accessible Cart page and connect Add-to-Cart actions so that when a user taps "Add to cart" they are taken to the new Cart screen which lists items and supports a non-payment "Checkout" that clears the cart.

Files to edit / create:
- `lib/views/cart_screen.dart` — create the `CartScreen` widget and UI.
- `lib/views/product_screen.dart` (or where Add-to-Cart lives) — ensure add-to-cart handler navigates to the `CartScreen` after adding the item. If the project already has a central cart model, update the existing add-to-cart callback to use `context.go('/cart')` (when using `go_router`) or the app's equivalent routing call.

Context & assumptions:
- The app already has product pages with an "Add to cart" button. Preserve existing product data flow (color, size, name, price).
- No real payments are required — the Checkout button simply clears the cart state and shows a confirmation.
- Keep naming consistent: prefer `CartScreen` and route `/cart` (or adapt to the app's existing router scheme).

Requirements / Acceptance Criteria
- When user taps "Add to cart" on a product, the product (with selected color and size if provided) is added to the cart and the app navigates to the `CartScreen`.
- The `CartScreen` lists each cart item with: color (if applicable), size (if applicable), product name, quantity (default 1), and price for that item. Show line total (price × quantity) and a cart total at the bottom.
- Provide a `Checkout` button that clears the cart contents (no external payment integration) and shows a short success `SnackBar` or dialog.
- Provide a `Remove` or `Delete` affordance for each cart item to remove it from the cart.
- The cart UI must be responsive: on narrow screens (<600 logical px) stack content vertically, ensure touch targets >=44×44 logical px, and avoid horizontal overflow.
- Preserve existing navigation helpers and patterns (e.g., `navigateToHome` or `context.go` when the app uses `go_router`); do not rename them.

Implementation guidance (for the LLM developer):
- Cart state: implement a minimal in-memory cart for this task (e.g., a simple `List<CartItem>` stored in a singleton, `InheritedWidget`, or a small `ChangeNotifier` provider). Keep this local and minimal — prefer a `CartModel` with pure functions like `addItem`, `removeItem`, `clear` so unit testing is easy.
- `CartItem` shape should include at least: `id`, `name`, `price`, `color` (nullable), `size` (nullable), `quantity`.
- Routing: register a `/cart` route (or use existing router conventions). If the app uses `go_router`, add the route and prefer `context.go('/cart')` for navigation; otherwise follow the app's existing routing style (named routes or `onGenerateRoute`).
- Accessibility: wrap meaningful UI with `Semantics` labels (e.g., `"Cart item: <name>"`) and ensure `Checkout` and `Remove` buttons are large enough.
- UI specifics: show a scrollable `ListView` of items, a sticky bottom area with `Cart Total` and `Checkout` button, and a fallback empty-state view when the cart is empty with a button to `Continue shopping` (navigates Home).

Edge cases & constraints:
- Products may not have color or size — show a small `—` or omit that row when absent.
- Support multiple items; summation should use precise `double` arithmetic and format currency with the app's existing formatting conventions.
- Do not integrate payments or external APIs.

Acceptance test checklist (manual):
- Add an item from a product page with color and size. Verify the app navigates to the cart and the item shows name, color, size, price.
- Add a second item; verify the list updates and totals update.
- Tap `Remove` on an item; verify it disappears and totals update.
- Tap `Checkout`; verify the cart is cleared and a confirmation appears (SnackBar or dialog).
- Verify layout on narrow viewport (mobile) does not overflow and buttons are tappable.

Quick test/run commands (PowerShell):
```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

---


# Image Generation & Asset Migration Prompt (for another LLM)

Task

- Replace all externally-hosted images used by the app (e.g., `Image.network(...)`, hardcoded image URLs in code or templates) with locally generated asset images placed under `assets/images`.

Context & constraints

- The repository currently references network images for product, collection, and other UI imagery. The developer prefers generated, local images in `assets/images` instead of remote URLs. The `pubspec.yaml` already includes the `assets/images` path, but your run should verify and update it only if necessary.
- Do not change app visual design except to replace `Image.network` with `Image.asset` equivalents and to keep aspect ratios and semantics intact.
- Preserve existing widget parameters (boxFit, width, height, alignment), navigation helpers, and accessibility semantics.

What you must do

1. Scan the repository (all `lib/` files, templates, and assets references) and collect a complete list of unique external image URLs and their code locations.
2. For each unique external image, generate a new image file and save it to `assets/images/` using a safe, descriptive filename (lowercase, hyphens, e.g. `product-card-rose.png`, `collection-cards.jpg`). Prefer PNG for UI elements and JPEG for full-bleed photographic images. Include a short plain-text mapping table in your patch that lists each original URL → new filename → brief description (colors, subject, recommended focal area/aspect ratio).
3. Replace each `Image.network('<url>'...)` (and other direct URL uses) with `Image.asset('assets/images/<new-filename>'...)`, preserving any sizing, `fit`, and other parameters. If the original code used `Image.network` with `loadingBuilder` or `errorBuilder`, preserve equivalent behavior (e.g., keep `placeholder` widgets or a small fallback `Icon` and retain `errorBuilder` logic). Keep semantics labels and `GestureDetector` handlers intact.
4. Ensure any large full-bleed images (e.g., the Collections slide) use `assets/images/collections.jpg` with an appropriate aspect ratio (`16:7` recommended for the home carousel); create and reference that file specifically.
5. Optimize generated images for web: reasonable resolutions (e.g., width 1200–1600px for full-bleed, 600–800px for card thumbnails), sRGB, and compressed sizes under ~200KB where possible. If you include 2x assets for high-DPI, follow Flutter asset conventions (`assets/images/2.0x/...`) — optional but document what you added.
6. Verify `pubspec.yaml` includes the `assets/images` path; update only if it is missing and include the exact small patchlines you would add.
7. Provide a single patch (diff) that: adds the new image files to `assets/images/` (binary placeholders or clearly-named stubs if you cannot embed binaries), updates code locations to use `Image.asset`, and optionally updates `pubspec.yaml` if required.

Acceptance criteria

- No remaining references to external image URLs in `lib/` source (search `Image.network(` and raw `http://`/`https://` strings to confirm).
- All replaced widgets load assets from `assets/images/<filename>` and preserve previous layout and accessibility.
- Full-bleed collection image referenced as `assets/images/collections.jpg` and used in the home carousel slide.
- If actual image binary content cannot be embedded, your patch must include clear filenames and a mapping table plus instructions for the developer to add the generated files into `assets/images/` (include suggested commands and expected file sizes/resolutions).

Deliverables

- A markdown summary at the top of your answer listing all replaced URLs and their new filenames and descriptions.
- A patch (or series of patches) that: replaces `Image.network` calls with `Image.asset` references across the codebase and updates `pubspec.yaml` if needed.
- The generated image files placed under `assets/images/` (or, if binaries cannot be embedded here, include a separate ZIP or a clear list and instructions for where to drop the files).
- A brief verification checklist and exact commands to run:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Notes for the implementer / LLM

- If you cannot create binary image files inside this code patch, include named, high-quality placeholder images (e.g., SVG or text stub files) and a clear table that instructs the human developer how to replace them with final generated images. Use descriptive filenames so the developer or asset pipeline can regenerate consistent images offline.
- Keep tappable areas and semantics. If replacing images inside buttons or tappable cards, ensure the widget still has the appropriate `Semantics` label.
- Minimize code changes: update only the lines needed to switch from network to asset usage. Keep function names and navigation helpers unchanged.
- If you add or rename assets, update `pubspec.yaml` only to ensure `assets/images/` is listed; do not add a long list of individual files unless necessary.

Edge cases

- For any image URL that is used in multiple places, re-use the single asset filename and preserve aspect-ratio cropping via widget parameters rather than creating duplicates.
- If some images are truly dynamic (user-uploaded, remote CDN renders that vary by product), note those as exceptions and provide a suggested migration strategy (e.g., a small fallback asset, or a server-side sync workflow) rather than forcing them into `assets/images`.

Testing checklist (manual)

- Search the repository for `Image.network(` and `http`/`https` strings — confirm none remain in `lib/`.
- Run `flutter analyze` and `flutter test` and fix any analyzer issues introduced by the replacements.
- Start the app (`flutter run -d chrome`) and verify in both desktop and mobile widths that images load correctly, aspect ratios are preserved, and the home carousel shows the `collections.jpg` image.

If you modify files other than image files and `pubspec.yaml`, explain why in 2–3 bullets at the top of your patch.

---

End of prompt.