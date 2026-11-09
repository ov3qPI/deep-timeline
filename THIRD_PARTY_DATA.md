# Timezone coordinate database — licensing and provenance
Deep Timeline uses the offline BikepackPro `tzraster.bin` dataset, which is a derivative of timezone-boundary-builder and OpenStreetMap data. The dataset is published under the Open Data Commons Open Database License (ODbL) v1.0.
Copyright and attribution: Contains information from timezone-boundary-builder, made available under the Open Database License (ODbL), derived from OpenStreetMap data © OpenStreetMap contributors.
Source of bundled derivative database: https://github.com/trinmaja/bikepackpro-tzraster
Upstream original polygon dataset: https://github.com/evansiroky/timezone-boundary-builder
License text: https://opendatacommons.org/licenses/odbl/1-0/
Data release: timezone-boundary-builder 2026c. Raster grid: 0.001°, 360000 × 180000, 441 palette zones, 33,687,830 bytes, SHA-256 4f25382fa740a466f75444fc07a76dfce3150fa8a5d3455ba7e8e341d6e2a8b9.
Machine-readable derivative database: https://raw.githubusercontent.com/trinmaja/bikepackpro-tzraster/main/tzraster.bin
Source reconstruction instructions and validation: https://github.com/trinmaja/bikepackpro-tzraster/tree/main/tools
The compiled APK embeds an exact checksum-verified copy of this derivative dataset, so the offline geographic resolver does not depend on a network connection. The archive's build script downloads the binary during the first build and preserves it in Termux's cache for future builds.
The ODbL applies to the timezone coordinate database, not to event records stored privately by the user. The app's Kotlin lookup code is independently written for Deep Timeline and uses the public BPTZ v1 format specification.
