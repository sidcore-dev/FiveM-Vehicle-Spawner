# FiveM Vehicle Spawner v2.1

Standalone vehicle spawner for FiveM. No framework (ESX/QBCore/etc.) required. Notifications are handled via [mythic_notify](https://github.com/mythic-projects/mythic-notify).

**Author:** choda

## Features

- On-screen category menu, opened by default with **F5** (players can rebind it in FiveM Settings > Key Bindings > FiveM > "Open Vehicle Spawner Menu")
- Navigate with Up/Down, select with Enter, go back/close with Backspace
- Categorized vehicle list (Sports, SUVs, Off-Road, Motorcycles, Aircraft, Emergency, Utility) — fully editable, and new categories are picked up automatically
- Optional per-category ace permissions — restrict individual categories (e.g. lock "Emergency" to police) while leaving others open, all gated by a single master switch
- Deletes the player's previously spawned vehicle automatically (optional)
- Spawns the player into the driver seat automatically (optional)
- Optional custom plates
- "Delete My Vehicle" utility entry in the menu

## Requirements

- A running FiveM server
- [mythic_notify](https://github.com/mythic-projects/mythic-notify) installed and started **before** this resource

## Installation

1. Copy the `vehiclespawner` folder into your server's `resources` directory.
2. In `server.cfg`, make sure `mythic_notify` starts first, then this resource:
   ```
   ensure mythic_notify
   ensure vehiclespawner
   ```
3. Restart your server (or run `refresh` + `ensure vehiclespawner` from the server console).

## Usage

Press **F5** in-game to open the menu. Pick a category, then a vehicle, and it spawns in front of you.

## Configuration

All settings live in [`config.lua`](config.lua).

| Setting | Type | Default | Description |
|---|---|---|---|
| `Config.OpenKey` | string | `'F5'` | Default keybind to open the menu. Players can still rebind it themselves in-game. |
| `Config.UsePermissions` | boolean | `false` | Master switch for permissions. If `false`, every category is open to everyone and the per-category `permission` fields are ignored. If `true`, a category is restricted only if it has a `permission` set. |
| `Config.DeletePreviousVehicle` | boolean | `true` | Deletes the player's last spawned vehicle when spawning a new one. |
| `Config.SpawnInVehicle` | boolean | `true` | Warps the player into the driver seat after spawning. |
| `Config.SpawnDistance` | number | `3.0` | Distance (units) in front of the player to spawn the vehicle. |
| `Config.SetPlate` | boolean | `false` | Gives spawned vehicles a randomized custom plate. |
| `Config.PlatePrefix` | string | `'CHODA'` | Prefix used for custom plates (only applies if `SetPlate` is `true`). |
| `Config.MenuTitle` | string | `'Vehicle Spawner v2.1'` | Title shown at the top of the menu. |
| `Config.NotifyDuration` | number | `5000` | How long (ms) mythic_notify alerts stay on screen. |
| `Config.Vehicles` | table | see below | Categories and vehicles shown in the menu, each with its own optional permission. |

### Enabling permissions

Set `Config.UsePermissions = true`. This is the master switch — with it `false`, no permission checks happen at all, regardless of what's set per category.

Once enabled, each category decides its own access via its `permission` field (see below). Categories with `permission = nil` stay open to everyone even with the master switch on; only categories with a permission string get gated. The server checks these with `IsPlayerAceAllowed` and only sends the player the categories they're allowed to see.

Grant a category's permission in `server.cfg`, e.g. to restrict the `Emergency` category to a `police` group:

```
add_ace group.police vehiclespawner.emergency allow
add_principal identifier.license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx group.police
```

### Editing the vehicle list & categories

`Config.Vehicles` is a table of categories. Each category has an optional `permission` and a `vehicles` list of `{ label, model }` entries:

```lua
Config.Vehicles = {
    ['Sports'] = {
        permission = nil, -- open to everyone
        vehicles = {
            { label = 'Adder', model = 'adder' },
            { label = 'Zentorno', model = 'zentorno' },
        },
    },
    ['My Custom Category'] = {
        permission = 'vehiclespawner.mycustomcategory', -- only checked if Config.UsePermissions = true
        vehicles = {
            { label = 'My Custom Car', model = 'mycustomcar' },
        },
    },
}
```

- `permission` is optional. Omit it (or set to `nil`) to leave the category unrestricted; set it to an ace permission string to gate that category specifically.
- `label` is what's displayed in the menu.
- `model` is the vehicle's spawn code (vanilla vehicle name, or an added vehicle's model name).
- Add, remove, or rename categories and vehicles freely — new categories (with or without a permission) are picked up automatically, no other code changes needed.
- The special `model = 'delete'` entry (see the `Utility` category) deletes the player's current or last-spawned vehicle instead of spawning one.

## File structure

```
vehiclespawner/
├── fxmanifest.lua   Resource manifest (declares the mythic_notify dependency)
├── config.lua        All configurable settings
├── client.lua         Menu rendering, input handling, vehicle spawn/delete logic
├── server.lua         Server-side permission check
├── LICENSE            MIT license
├── CHANGELOG.md        Version history
└── .gitignore          OS/editor clutter
```
