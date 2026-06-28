{
  lib,
  ...
}:
let
  zenDesktopFile = "zen-beta.desktop";
  browserMimeTypes = [
    "text/html"
    "text/xml"
    "application/xhtml+xml"
    "application/vnd.mozilla.xul+xml"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
  ];
in
{
  # Enable Zen Browser
  programs.zen-browser.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs browserMimeTypes (_: zenDesktopFile);
    associations.added = lib.genAttrs browserMimeTypes (_: zenDesktopFile);
  };

  # TODO: Figure out extensions
  # Zen Preferences
  programs.zen-browser.policies = {
    AutofillAddressEnabled = true;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
  };
}
