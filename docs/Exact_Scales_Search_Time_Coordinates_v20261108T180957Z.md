# Deep Timeline — Exact Visibility Scaling, Search and Temporal Coordinates

The maximum visible span is the complete duration of the timeline viewport, independent of distance from the present. An event is visible when the viewport's span is less than or equal to its threshold. Visibility filtering precedes hyperflow, so hidden events have no ticks, connectors, labels, or collision influence.

The visibility threshold is a positive exact rational number in units `DAY`, `MONTH`, or `YEAR`. Internally, all expressions reduce to arbitrary-precision integer numerator and denominator pairs. Fractions never become terminating or truncated decimal approximations, including repeating values such as `1/7`, `0.(3)`, and `0.1(6)`.

Supported expressions include `1/3`, `2^10`, `2^-3`, `2^10/3`, `1/(2^4)`, `1.5e-4`, `0.(3)`, `0.1(6)`, `2⁷`, and `1⁄7`. Parentheses may group fractions, but exponents must be integers because fractional powers can be irrational. The maximum absolute exponent is 4096 and the minimum displayable threshold is one nanosecond.

Units use fixed mean durations: day = 86400 seconds, mean synodic month = 2551442.8768992 seconds, and mean December-solstice year = 31556972.736 seconds. Decimal unit constants are represented exactly. The viewport is rendered using floating-point seconds per pixel, so threshold comparisons permit only one floating-point ULP of display-coordinate error; exact fractions are not rounded to fit the floating-point viewport.

`maxVisibleSpan` has been part of format version 1. It is unchanged, and both import and export use the exact expression as a **quoted string**:

```json
{"format":"deep-timeline","version":1,"events":[{"name":"A repeating-fraction cutoff","date":"-44-03-15","mode":"UTC","maxVisibleSpan":{"value":"1/3","unit":"MONTH"}},{"name":"A large-span cutoff","date":"-12000-01-01","mode":"UTC","maxVisibleSpan":{"value":"2^12","unit":"YEAR"}}]}
```

Import rejects a non-string threshold value instead of accepting a JSON number that may already have been rounded by the JSON parser. Existing exported files with string values remain compatible. Missing `maxVisibleSpan` means always visible. Event IDs, time modes, timestamps, and database columns do not change.

Tap the **DEEP TIMELINE** title to search all events, or use **Event Data → Search All Events**. Search includes names and dates of hidden and visible events. Tapping a result centers its actual timestamp and zooms in to the tighter of the current span, six times its nearest distinct-event interval, or half its visibility threshold. A search cannot change, delete, or redate events. The only scale adjustment is zooming in.

## Temporal-coordinate model for a later schema revision

A future coordinate representation can encode the level of declared information by omission rather than by a separate subjective precision rating. For example, `{ "year": -10407 }` declares a year coordinate, while `{ "year": -10407, "month": 5, "day": 12 }` declares a day coordinate. An event still needs a deterministic placement on the visible axis, but its original sparse coordinate must be retained distinctly from that anchor. The anchor policy might choose the beginning or midpoint of an unspecified period; that is a display convention, not a claim that an event happened at that instant. This new time schema is **not yet implemented**, because it needs explicit decisions about calendar systems, BCE year numbering, longitude and time-zone representation, mixed-radix precision, and migration of older timestamp-based event exports.
