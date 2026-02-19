# SDUI Production API Contract

This document describes what your backend must expose for **Server-Driven UI (SDUI)** so the app can load screens from the server instead of bundled assets.

## Base URL and build

- Set at build time: `--dart-define=SDUI_BASE_URL=https://your-api.com`
- Optional auth: `--dart-define=SDUI_API_KEY=your_key` (sent as `Authorization: Bearer <key>`)
- If `SDUI_BASE_URL` is empty, the app uses **bundled JSON only** (no server calls).

## Endpoint

```
GET {SDUI_BASE_URL}/screens/{screenId}
```

**Screen IDs** used by the app:

| screenId   | Route   | Description   |
|-----------|---------|--------------|
| `home`    | `/`     | Home screen  |
| `sign-in` | `/sign-in` | Sign-in screen |
| `login`   | `/login`   | Login screen  |

## Response

- **Status:** `200 OK`
- **Body:** JSON object with the following shape (same as the files in `assets/sdui/`).

### Schema

```json
{
  "type": "<ScreenType>",
  "attributes": { ... }
}
```

- **`type`** (required): One of the registered screen types. Current types:
  - `HomeScreen`
  - `SignInScreen`
  - `LoginScreen`
  - `ListingScreen`
  - `CompanyScreen`
- **`attributes`** (optional): Key-value map passed to the screen widget. See examples below.

### Example responses

**Home**
```json
{"type":"HomeScreen","attributes":{"userName":"Rajesh Kumar"}}
```

**Sign-in**
```json
{"type":"SignInScreen","attributes":{}}
```

**Login**
```json
{"type":"LoginScreen","attributes":{}}
```

**Listing** (optional listings payload)
```json
{
  "type": "ListingScreen",
  "attributes": {
    "listings": [...],
    "empty": false,
    "skeleton": false
  }
}
```

## Headers sent by the app

- `Accept: application/json`
- `User-Agent: B2BMarketplace/1.0`
- `Authorization: Bearer <SDUI_API_KEY>` (if `SDUI_API_KEY` is set)

## Fallback

- If the request fails (network error, non-200, or invalid JSON), the app loads the corresponding file from **bundled assets** (e.g. `assets/sdui/home_screen.json`).
- Cached responses are used for the rest of the app session; restart the app to force a refetch.

## Security

- Use **HTTPS** only for the SDUI base URL.
- Validate and sanitize screen JSON on the server (allowlist `type` and attribute keys) so compromised responses cannot inject unknown types.
- Prefer short-lived or scoped API keys; rotate them when needed.

## Versioning

- Add new `type` or attribute keys only when the app version in the store supports them.
- Ignore unknown keys in the client so older app versions keep working when you add new attributes.
