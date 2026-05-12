# VNM Base Control Web

A browser-based control panel for the **VNM Base ** direct-drive wheelbase. Connects to the VNM REST API running locally and lets you manage all settings from any device on your network.

## Requirements

- [Node.js](https://nodejs.org) v18 or higher
- VNM Base Control Web running with REST Server enabled *(Settings → Enable REST Server)*

## Quick Start

**First run — right-click `webserver/start-vnm-control-web.bat` → Run as Administrator**

The first time only, Administrator is required to:
- Install Node.js automatically via `winget` (if not already installed)
- Add a Windows Firewall inbound rule so phones and tablets on your local network can reach the server

After that first run, you can double-click the launcher normally — no Administrator needed.

Double-click **`webserver/start-vnm-control-web.bat`** — the browser opens automatically and prints your Local, Network, and Host URLs.

Or from a terminal:

```bash
cd webserver/backend
npm install
node server.js
```

When the launcher starts, it prints the addresses you can use:

```
  VNM Control Web
  ================================
  Local:   http://localhost:3001
  Network: http://192.168.1.X:3001   ← open this on your phone
  Host:    http://YOUR-PC-NAME:3001  ← alternative if DNS resolves
  ================================
```

Port is configured in `webserver/backend/server.cfg` (default `PORT=3001`).

## Features

- **VNM FFB** tab — Full-screen touch pad for on-the-fly FFB tuning: +1 / +5 / −1 / −5 Overall Gain and CENTER, all fire instantly without Apply
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
Browser → webserver/backend/server.js (Node.js, port 3001) → VNM REST API (localhost:9000)
```

No npm dependencies — uses only Node.js built-in modules.

## REST API

The VNM app must be running with an **API REST** profile configured in VNM Config.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/control/list` | List all controls |
| GET | `/api/control/{id}` | Get current value and options |
| POST | `/api/control/{id}` | Set value or trigger action |
