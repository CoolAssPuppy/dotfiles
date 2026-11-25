# Build tools shared by native mobile and macOS projects.
# Android Studio's JDK (25) first, the one .zshrc uses; Homebrew's 21 only without it.
for _java_home in \
  "/Applications/Android Studio.app/Contents/jbr/Contents/Home" \
  "$HOMEBREW_PREFIX/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"; do
  if [[ -d "$_java_home" ]]; then
    export JAVA_HOME="$_java_home"
    export PATH="$JAVA_HOME/bin:$PATH"
    break
  fi
done
unset _java_home
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$HOMEBREW_PREFIX/share/android-commandlinetools/cmdline-tools/latest/bin:$PATH"
