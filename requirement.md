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
