# VNM Base Control Web

A browser-based control panel for the **VNM SIMCENTER** direct-drive wheelbase, handbrake, and pedals. Connects to the VNM REST API running locally and lets you manage all settings from any device on your network.

## Requirements

- [Node.js](https://nodejs.org) v18 or higher
- VNM SIMCENTER running with REST Server enabled *(Settings → Enable REST Server)*

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
- Responsive layout, works on mobile

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
