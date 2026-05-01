# VNM Control Web

Web interface for VNM SIMCENTER hardware (direct-drive wheelbases, handbrakes, pedals) that proxies the VNM REST API running on localhost:9000.

## Architecture

```
Browser (localhost:3000)
    └── server.js (Node.js HTTP proxy, zero npm dependencies)
            └── VNM SIMCENTER REST API (localhost:9000)
```

## Running

```bash
node server.js
# Open http://localhost:3000
```

No `npm install` needed — uses only Node.js built-in modules (`http`, `fs`, `path`, `url`).

## REST API (VNM SIMCENTER → localhost:9000)

The VNM app must be running with **REST Server enabled** (Settings → Enable REST Server).
To expose a profile via REST, set up an "API REST" profile in VNM Config.

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/control/list` | All control IDs and labels |
| GET | `/api/control/{id}` | Current value, type, supported actions |
| POST | `/api/control/{id}` | Perform action on control |

### POST actions

```json
{ "action": "set", "value": 50 }   // Set absolute value
{ "action": "inc", "value": 10 }   // Increment by value
{ "action": "dec", "value": 10 }   // Decrement by value
{ "action": "click" }              // Button press
{ "action": "select", "value": "TIC" }  // Dropdown select
```

## Control IDs

### Basic (D100xxx)
| ID | Label | Type |
|----|-------|------|
| D100001 | Steering Range | slider (0–1800) |
| D100002 | Overall Gain | slider (0–100) |
| D100003 | Overall Filter | slider (0–255) |
| D100004 | Damper Gain | slider (0–100) |
| D100005 | Friction Gain | slider (0–100) |
| D100006 | Inertia Gain | slider (0–100) |
| D100007 | Spring Gain | slider (0–100) |
| D100008 | Center | button |
| D100009 | Profile Selector | select |
| D100010 | FFB Mode | select (Direct Input / Telemetry / iRacing 360Hz / TIC) |

### Advanced (D200xxx)
| ID | Label | Type |
|----|-------|------|
| D200001 | DI Ratio | slider (0–100) |
| D200002 | Damper Filter | slider (0–100) |
| D200003 | Inertia Filter | slider (0–100) |
| D200004 | Friction Filter | slider (0–100) |
| D200005 | Force Range Lower | slider |
| D200006 | Force Range Upper | slider |
| D200007 | Bumpstop Range | slider (0–1800) |
| D200008 | Lock Strength | slider (0–10000) |

### Game Settings (D400xxx)
| ID | Label |
|----|-------|
| D400001 | Constant Gain |
| D400002 | Ramp Gain |
| D400003 | Spring Gain |
| D400004 | Damper Gain |
| D400005 | Inertia Gain |
| D400006 | Friction Gain |
| D400007 | Square Gain |
| D400008 | Triangle Gain |
| D400009 | Sine Gain |
| D400010 | Sawtooth Up Gain |
| D400011 | Sawtooth Down Gain |

## UI Tabs

- **Basic** — Main wheel setup: steering range, overall gain/filter, user effects, system info
- **Advanced** — Fine tuning: DI ratio, filters, bumpstop, lock strength, FFB mode
- **Game Settings** — DirectInput per-effect gains

## File Structure

```
VNM Control Web/
├── CLAUDE.md
├── server.js          # Node.js proxy server (port 3000)
├── documentation/
│   ├── VNMConfig.chm  # Original compiled help file
│   ├── VNMConfig.chw
│   └── extracted/     # HTML pages extracted from CHM
└── public/
    └── index.html     # Single-page UI
```

## FFB Modes

- **Direct Input** — Classic DirectInput API from game engine
- **Telemetry** — Real-time telemetry via VNM Plugin system
- **iRacing 360Hz** — Native iRacing shared memory API
- **TIC** — Hybrid: DirectInput + Telemetry combined, DI Ratio controls the mix
