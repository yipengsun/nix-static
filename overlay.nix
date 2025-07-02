self: super:
{
  curl = super.curl.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [ ./pkgs/curl/disable_ssl_verify.patch ];
  });

  nix = super.nix.overrideAttrs (_: {
    outputs = [ "out" ];
    meta.outputsToInstall = [ "out" ];
  });
}
