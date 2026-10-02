# macbook-pro. Written by `nix run .#init`, starting from hosts/example.
#
# Every unit in modules/ is off unless it is turned on here, so this file is
# the whole answer to "what does this Mac run". Edit it freely: re-running
# init reads it back as its defaults and shows a diff before rewriting it.
{ ... }:

{
  mine.user = {
    name = "christophe";
    fullName = "christophe";
    email = "cainam87@hotmail.com";
    # File under ~/.ssh that github.com is pinned to; null for https via gh.
    githubKey = "id_ed25519";
    # Needs a GPG secret key for the email above; `keys doctor` checks.
    signCommits = true;
  };

  mine.desktop = {
    aerospace.enable = true;
    betterdisplay.enable = false;
    dock.enable = true;
    raycast.enable = true;
    sketchybar.enable = false;
  };

  mine.services = {
    screen-lock-monitor.enable = false;
  };

  mine.programs = {
    datagrip.enable = false;
    # Symlinks ~/.claude into modules/config/claude; see docs/two-paths.md.
    claude-code.enable = true;
    # From the App Store; sign in to App Store.app once before switching.
    xcode.enable = true;
  };

  # WeMaintain: ~/.aws/config, withPg and friends, the Pritunl VPN, wm-login
  # and the work MCP servers. Fetches the private wemaintain/devenv input.
  mine.work.wemaintain.enable = true;

  mine.homebrew = {
    brews = [ ];
    casks = [
      "claude"
      "claude-code@latest"
      "discord"
      "docker-desktop"
      "google-chrome"
      "openlens"
      "slack"
      "visual-studio-code"
      "warp"
    ];
  };

  # Needs a private nix-secrets repo of your own as the `secrets` input;
  # see docs/new-machine.md, "From scratch".
  mine.secrets.enable = false;
}
