# VNM Base Control Web

A browser-based control panel for the **VNM BASE ** direct-drive wheelbase. Connects to the VNM REST API running locally and lets you manage all settings from any device on your network.

## Requirements

- [Node.js](https://nodejs.org) v18 or higher
- VNM Base Control Web running with REST Server enabled *(Settings → Enable REST Server)*

## Quick Start

Double-click **`start.bat`** — the browser opens automatically.

Or from a terminal:

```bash
node server.js
```

Then open `http://<your-local-ip>:3000` from any device on your network.

## Features

- **Basic** tab — Steering range, overall gain/filter, user effects (damper, friction, inertia, spring)
- **Advanced** tab — FFB mode selector, DI ratio, filters, bumpstop range, lock strength
- **Game Settings** tab — Per-effect DirectInput gains (constant, ramp, spring, damper…)
- **Profile selector** — Switch between VNM profiles instantly
- **Apply button** — All changes are staged locally and sent to the device at once
- **Center button** — Sends the center command immediately
- **Fullscreen button** — Hides the browser UI (address bar, tabs) for a cleaner view — press again or `Esc` to exit
- Responsive layout, works on mobile

## Important — Session vs. Saved Configuration

**Apply only affects the current session.** Values sent via the Apply button are applied to the device in real time but are not written to the profile permanently. If VNM restarts or the profile is reloaded, the device will revert to its last saved configuration.

To make changes permanent, use the **Save** button inside the VNM app (or via the interface if available) to overwrite the profile on disk.

This tool is designed for **on-the-fly tuning** — adjust while driving, apply instantly, save when happy.

## Architecture

```
Browser → server.js (Node.js, port 3000) → VNM REST API (localhost:9000)
```

No npm dependencies — uses only Node.js built-in modules.

## REST API

The VNM app must be running with an **API REST** profile configured in VNM Config.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/control/list` | List all controls |
| GET | `/api/control/{id}` | Get current value and options |
| POST | `/api/control/{id}` | Set value or trigger action |
