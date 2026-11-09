# Deep Timeline JSON Transfer, format version 1
The Import/Export icon opens a menu for importing JSON, exporting selected events, or exporting a reusable template. The app previews every event with an individual check box and ALL/NONE/INVERSE actions. The X cancels. The import preview includes invalid records with reasons, disabled from selection, and flags existing UUIDs as updates. Duplicates and unchanged items default to unchecked. Selecting an existing UUID explicitly replaces that event after confirmation by pressing IMPORT SELECTED. The import writes selected events in one database transaction. Export selection is confirmed before Android asks for a save location; cancelling the document picker writes nothing.
## Minimal hand-authored file
```json
{"format":"deep-timeline","version":1,"events":[{"name":"Roman event","date":"-44-03-15"},{"name":"Paleolithic event","date":"-200000-01-01","time":"00:00:00","mode":"UTC"}]}
```
## Fields
- `format`: `deep-timeline` (optional on import, included on export)
- `version`: `1` (optional on import, included on export)
- `events`: JSON array (required)
- `name`: non-empty event name (required; max 100,000 characters)
- `date`: `YYYY-MM-DD` or `-YYYY-MM-DD` for BCE with no year zero (required)
- `time`: `HH:MM[:SS[.nnnnnnnnn]]`; defaults to `00:00:00`
- `mode`: `UTC` (default), `LOCAL`, `LONGITUDINAL`
- `coordinates`: string `latitude, longitude` required for longitudinal mode, optional for Local
- `zone`: IANA timezone identifier for Local; if omitted, coordinates are resolved offline or Android device timezone is used when coordinates are blank
- `uuid`: UUID used for identity and selective updates; omitted UUID generates a new identifier
- `epochSeconds`: signed integer, together with `nanosecond` (0 through 999,999,999), for exact roundtrips; both must agree with the civil date interpretation
- `offsetNanoseconds`: exact signed integer offset, present in full export
- `created`, `updated`: Unix milliseconds, present in full export
For standard JSON exports, every event includes its canonical instant and UUID, preserving ancient years and subsecond precision. A timezone-overlap (DST fall-back) requires `epochSeconds` and `nanosecond` to choose which offset applies. Gaps are invalid. The calendar is proleptic Gregorian, not historical Julian. Events with matching names, instants, and time modes are recognized as potential duplicates. This app stores no event durations or alarms.
## Validation and limits
The importer accepts files up to 64 MiB with at most 100,000 event array entries. Parsing runs off the UI thread. Invalid events remain visible with their validation messages and cannot be selected. Importing zero items changes nothing, while exporting zero items creates an empty JSON archive. Android’s document picker supports files in local storage and compatible document providers.
