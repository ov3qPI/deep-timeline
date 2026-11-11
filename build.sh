set -euo pipefail
SCRIPT_ID=deep_timeline_build_v20261111T141738Z
APP_ID=Deep_Timeline_v20261111T141738Z
ROOT=/storage/emulated/0
APK_DIR="$ROOT/Documents/apk"
LOG_DIR="$ROOT/Documents/log"
mkdir -p "$APK_DIR" "$LOG_DIR"
LOG="$LOG_DIR/${SCRIPT_ID}.log"
exec > >(tee "$LOG") 2>&1
cd "$(dirname "$0")"
ANDROID_JAR="${ANDROID_JAR:-}"
if [ -z "$ANDROID_JAR" ];then
 for path in "$HOME/android-sdk/platforms/android-35/android.jar" "$HOME/android-sdk/platforms/android-36/android.jar" "$PREFIX/share/android-sdk/platforms/android-35/android.jar" "$PREFIX/share/android-sdk/platforms/android-34/android.jar" "$PREFIX/share/android-sdk/platforms/android-33/android.jar";do
  if [ -f "$path" ];then ANDROID_JAR="$path";break;fi
 done
fi
if [ ! -f "$ANDROID_JAR" ];then echo "ERROR: Android platform android.jar not found; set ANDROID_JAR=/path/to/android.jar";exit 1;fi
for executable in kotlinc aapt2 zipalign apksigner jar keytool zip curl sha256sum java;do command -v "$executable" >/dev/null || { echo "ERROR: Missing build tool: $executable";exit 1; };done
KOTLIN_LIB="${KOTLIN_LIB:-}"
if [ -z "$KOTLIN_LIB" ];then
 for dir in "${PREFIX:-/none}/share/kotlin/lib" "${PREFIX:-/none}/lib/kotlin/lib" "$(dirname "$(readlink -f "$(command -v kotlinc)")")/../lib" "$HOME/.sdkman/candidates/kotlin/current/lib";do
  if [ -f "$dir/kotlin-stdlib.jar" ];then KOTLIN_LIB="$dir";break;fi
 done
fi
if [ ! -f "$KOTLIN_LIB/kotlin-stdlib.jar" ];then echo "ERROR: Kotlin standard library not found; set KOTLIN_LIB";exit 1;fi
WORK="$(mktemp -d "${TMPDIR:-$HOME}/deep_timeline_compile.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/classes" "$WORK/dex"
run_stage(){
 local stage="$1";shift
 local output="$WORK/${stage}.log";local preserved="$LOG_DIR/${SCRIPT_ID}_${stage}.log"
 echo "RUN: $stage"
 if "$@" >"$output" 2>&1;then
  if grep -Eq '(^Warning:|^warning:|^Error:|^error:|^Exception in thread|malformed kotlin.Metadata|Unexpected error during rewriting of Kotlin metadata)' "$output";then
   cp "$output" "$preserved"
   echo "WARNING: $stage emitted diagnostics; full output saved to $preserved"
   grep -E '(^Warning:|^warning:|^Error:|^error:|malformed kotlin.Metadata|Unexpected error during rewriting of Kotlin metadata)' "$output" | head -n 12 | cut -c 1-240 || true
   if grep -Eq 'malformed kotlin.Metadata|Unexpected error during rewriting of Kotlin metadata' "$output";then echo "ERROR: Incompatible D8/Kotlin metadata; refusing to ship an unverified DEX";return 1;fi
  fi
  echo "OK: $stage"
 else
  local code=$?
  cp "$output" "$preserved"
  echo "FAILED: $stage (exit $code); complete output: $preserved"
  tail -n 25 "$output" | cut -c 1-240
  return "$code"
 fi
}
CACHE="$HOME/.cache/deep_timeline"
mkdir -p "$CACHE" assets
R8_JAR="$CACHE/r8lib_9.1.29.jar"
if [ -f "$R8_JAR" ] && ! java -cp "$R8_JAR" com.android.tools.r8.D8 --version 2>/dev/null | grep -Fq 9.1.29;then rm -f "$R8_JAR";fi
if [ ! -f "$R8_JAR" ];then
 echo "Downloading compatible D8/R8 9.1.29 from the official Google release (one-time cache)"
 curl --silent --show-error --fail --location --retry 3 --connect-timeout 25 --output "$R8_JAR.part" https://storage.googleapis.com/r8-releases/raw/9.1.29/r8lib.jar
 mv "$R8_JAR.part" "$R8_JAR"
fi
R8_VERSION="$(java -cp "$R8_JAR" com.android.tools.r8.D8 --version 2>&1)"
if [[ "$R8_VERSION" != *9.1.29* ]];then echo "ERROR: Downloaded D8 reports an unexpected version: $R8_VERSION";exit 1;fi
echo "D8: $R8_VERSION"
RASTER_SHA=4f25382fa740a466f75444fc07a76dfce3150fa8a5d3455ba7e8e341d6e2a8b9
RASTER="$CACHE/tzraster_2026c.bin"
if [ -f assets/tzraster.bin ];then
 printf '%s  %s\n' "$RASTER_SHA" assets/tzraster.bin | sha256sum -c -
else
 if [ -f "$RASTER" ] && ! printf '%s  %s\n' "$RASTER_SHA" "$RASTER" | sha256sum -c -;then rm -f "$RASTER";fi
 if [ ! -f "$RASTER" ];then
  echo "Downloading pinned 33.7 MB offline geographic timezone raster (one-time cache)"
  curl --silent --show-error --fail --location --retry 3 --connect-timeout 25 --output "$RASTER.part" https://raw.githubusercontent.com/trinmaja/bikepackpro-tzraster/main/tzraster.bin
  printf '%s  %s\n' "$RASTER_SHA" "$RASTER.part" | sha256sum -c -
  mv "$RASTER.part" "$RASTER"
 fi
 cp "$RASTER" assets/tzraster.bin
fi
run_stage kotlin kotlinc -nowarn src -jvm-target 1.8 -classpath "$ANDROID_JAR:$KOTLIN_LIB/kotlin-stdlib.jar" -d "$WORK/classes"
run_stage jar jar cf "$WORK/application.jar" -C "$WORK/classes" .
run_stage resources aapt2 compile --dir res -o "$WORK/resources.zip"
run_stage manifest aapt2 link -o "$WORK/base.apk" -I "$ANDROID_JAR" --manifest AndroidManifest.xml -A assets "$WORK/resources.zip"
INPUTS=("$WORK/application.jar" "$KOTLIN_LIB/kotlin-stdlib.jar")
for name in kotlin-stdlib-jdk7.jar kotlin-stdlib-jdk8.jar;do if [ -f "$KOTLIN_LIB/$name" ];then INPUTS+=("$KOTLIN_LIB/$name");fi;done
run_stage dex java -Xmx1536m -cp "$R8_JAR" com.android.tools.r8.D8 --release --min-api 26 --lib "$ANDROID_JAR" --output "$WORK/dex" "${INPUTS[@]}"
cp "$WORK/base.apk" "$WORK/with_dex.apk"
run_stage package bash -c 'cd "$1" && zip -q -0 "$2" classes*.dex' _ "$WORK/dex" "$WORK/with_dex.apk"
run_stage align zipalign -f 4 "$WORK/with_dex.apk" "$WORK/aligned.apk"
KEYSTORE="$HOME/.deep_timeline_signing.keystore"
EXPECTED_SIGNER=14ce44165cae3879ac579d114c5c190d2a8e9e6281b913afc7bce7eebb9987d6
[ -s "$KEYSTORE" ] || { echo 'ERROR: Original signing keystore missing; refusing to generate replacement identity';exit 1; }
[ -n "${DEEP_TIMELINE_STORE_PASS:-}" ] || { echo 'ERROR: DEEP_TIMELINE_STORE_PASS is not provided';exit 1; }
[ -n "${DEEP_TIMELINE_KEY_PASS:-}" ] || { echo 'ERROR: DEEP_TIMELINE_KEY_PASS is not provided';exit 1; }
run_stage sign apksigner sign --ks "$KEYSTORE" --ks-key-alias deep-timeline --ks-pass env:DEEP_TIMELINE_STORE_PASS --key-pass env:DEEP_TIMELINE_KEY_PASS --out "$WORK/signed.apk" "$WORK/aligned.apk"
run_stage verify apksigner verify --verbose "$WORK/signed.apk"
SIGNER_REPORT="$(apksigner verify --print-certs "$WORK/signed.apk")"
ACTUAL_SIGNER="$(printf '%s\n' "$SIGNER_REPORT" | sed -nE 's/^.*certificate SHA-256 digest:[[:space:]]*([[:xdigit:]:]+)[[:space:]]*$/\1/p' | tr '[:upper:]' '[:lower:]' | tr -d ':' | sort -u)"
[ "$ACTUAL_SIGNER" = "$EXPECTED_SIGNER" ] || { echo "ERROR: Signing identity differs from existing installed app: $ACTUAL_SIGNER";exit 1; }
cp "$WORK/signed.apk" "$APK_DIR/${APP_ID}.apk"
echo "SUCCESS: $APK_DIR/${APP_ID}.apk"
echo "BUILD LOG: $LOG"
