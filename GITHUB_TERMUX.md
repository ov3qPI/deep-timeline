# Publish source only with Termux
This repository stores Android Kotlin source, build scripts, tests, and documentation. It does not publish APKs or GitHub Releases.
No signing keystore, signing password, or personal timeline JSON is needed to create the repository.
Install `git`, `gh`, and `unzip` in Termux, extract the source ZIP into a new directory under `$HOME/projects`, and run `bash deep_timeline_source_publish_v20261109T022523Z.sh` from that directory.
The publisher verifies the authenticated GitHub account is `ov3qPI`, refuses to overwrite an existing remote, creates a fresh Git history, runs a staged-secret guard, and creates a private `ov3qPI/deep-timeline` repository with one `main` branch commit. No tags or releases are created.
Keep the old signing key out of GitHub. If you later build APKs for personal use, use `bash deep_timeline_secure_build_v20261109T020314Z.sh` and the existing private key. Rotation of the keystore protection remains advisable because the old password had been committed to a deleted private repository. This source-only workflow does not require rotation and never accesses the key.
The repository should remain private until source and history have been reviewed for personal information. Do not commit event exports or shared-storage backups.
