# Xcode: the App Store install, plus what has to happen after it.
#
# A nix-darwin module, imported from modules/home-manager.nix like datagrip:
# the app comes in through `homebrew.masApps` (brew bundle -> mas), and the
# rest is a system activation step.
#
# Installing Xcode.app is not enough on its own. Until someone opens it once
# and clicks through, `xcodebuild` refuses to run (license not accepted),
# `xcode-select` still points at the Command Line Tools, and the first-launch
# packages (simulators' support frameworks, CoreSimulator) are missing. All of
# that needs root, which activation already has, so it is done here.
#
# postActivation, because it runs after the `homebrew` step (see nix-darwin's
# activation-scripts.nix): on the switch that installs Xcode, the app is
# already there by the time this runs. Each step checks first, so every later
# switch is a few fast no-ops.
#
# The App Store sign-in cannot be automated (`mas` lost `signin` on current
# macOS). Without it the Homebrew step fails before this ever runs.
{ config, lib, ... }:

let
  cfg = config.mine.programs.xcode;
  app = "/Applications/Xcode.app";
  developerDir = "${app}/Contents/Developer";
in
{
  config = lib.mkIf cfg.enable {
    # The id from https://apps.apple.com/app/xcode/id497799835.
    homebrew.masApps.Xcode = 497799835;

    system.activationScripts.postActivation.text = ''
      if [ -d ${app} ]; then
        if [ "$(/usr/bin/xcode-select --print-path 2>/dev/null)" != "${developerDir}" ]; then
          echo "xcode: pointing xcode-select at ${app}" >&2
          /usr/bin/xcode-select --switch ${developerDir}
        fi
        if ! /usr/bin/xcodebuild -license check >/dev/null 2>&1; then
          echo "xcode: accepting the license" >&2
          /usr/bin/xcodebuild -license accept
        fi
        if ! /usr/bin/xcodebuild -checkFirstLaunchStatus >/dev/null 2>&1; then
          echo "xcode: installing first-launch components" >&2
          /usr/bin/xcodebuild -runFirstLaunch
        fi
      else
        echo "xcode: ${app} is missing; is App Store.app signed in?" >&2
      fi
    '';
  };
}
