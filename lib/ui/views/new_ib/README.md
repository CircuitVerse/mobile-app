# New Interactive Book (IB) View

A modern, redesigned version of the Interactive Book feature with a clean UI and better organization.

## Structure

```
new_ib/
├── new_ib_landing_view.dart          # Main view (entry point)
├── components/
│   ├── new_ib_drawer.dart            # Main drawer component
│   ├── new_ib_drawer_header.dart     # Drawer header with gradient
│   ├── new_ib_drawer_footer.dart     # Drawer footer with theme toggle
│   ├── new_ib_drawer_section.dart    # Section headers in drawer
│   ├── new_ib_drawer_tile.dart       # Navigation tiles (Home, Return)
│   ├── new_ib_simple_chapter_tile.dart    # Simple chapter items
│   ├── new_ib_expandable_chapter_tile.dart # Expandable parent chapters
│   ├── new_ib_sub_chapter_tile.dart  # Sub-chapter items
│   ├── new_ib_content.dart           # Main content area router
│   └── new_ib_home_page.dart         # Home page with features
└── README.md                          # This file
```

## Features

- **Modern UI Design**: Clean, gradient-based design with smooth animations
- **Dynamic Chapter Loading**: Fetches chapters from CircuitVerse API
- **Expandable Chapters**: Support for nested chapter structure
- **Theme Support**: Light/dark mode with theme toggle
- **Component-Based**: Modular architecture for easy maintenance

## Usage

The view is accessible from the main CircuitVerse drawer:
- Navigate to: Main Menu → "New Interactive Book"
- Route ID: `NewInteractiveBookView.id`

## API Integration

Uses the existing `IbLandingViewModel` and `IbEngineService` to:
- Fetch chapters from `https://learn.circuitverse.org`
- Load chapter content dynamically
- Maintain state across navigation

## Components

### Main View
- `new_ib_landing_view.dart`: Entry point, manages state and coordinates components

### Drawer Components
- `new_ib_drawer.dart`: Main drawer container
- `new_ib_drawer_header.dart`: Gradient header with app branding
- `new_ib_drawer_footer.dart`: Footer with version and theme toggle
- `new_ib_drawer_section.dart`: Section headers (Navigation, Chapters)
- `new_ib_drawer_tile.dart`: Navigation tiles (Home, Return Home)
- `new_ib_simple_chapter_tile.dart`: Single chapter without children
- `new_ib_expandable_chapter_tile.dart`: Parent chapter with sub-chapters
- `new_ib_sub_chapter_tile.dart`: Child chapter items

### Content Components
- `new_ib_content.dart`: Content area router (decides which page to show)
- `new_ib_home_page.dart`: Beautiful home page with:
  - Hero section with app branding
  - Features grid (Learn, Experiment, Practice, Master)
  - Getting Started guide
  - Dynamic content from API
- `new_ib_chapter_page.dart`: Chapter content page with:
  - Full markdown content rendering
  - Floating navigation buttons (prev/next)
  - "Also on Interactive Book" suggestions
  - Comments section with input and list
  - Auto-hide buttons on scroll
- `new_ib_markdown_parser.dart`: Custom markdown parser using Text widgets

## Future Enhancements

- [ ] Implement actual chapter content rendering
- [ ] Add search functionality
- [ ] Add bookmarks feature
- [ ] Add reading progress tracking
- [ ] Add quiz integration
- [ ] Add offline support
