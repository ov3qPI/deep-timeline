# Security and privacy
This repository is source-only: no APKs, signing keystores, key passwords, personal event JSON, downloaded timezone raster, logs, or build products are to be committed.
The source-only publisher does not access signing keys or require keystore password rotation. The former private repository included a hardcoded signing password, so changing that password and storing encrypted backups remains advisable before any future APK signing/distribution. Removing the old GitHub repository does not itself change the keystore password.
The current build script refuses to generate a new signing keypair and requires a locally supplied password. The package name and signing certificate remain unchanged.
A pre-commit guard and `.gitignore` reduce accidental disclosure, but do not replace manual review. Keep the repository private until all history and source have been checked for personal information.
