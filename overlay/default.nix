final: prev:
{
  curl = prev.curl.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [ ./curl/disable_ssl_verify.patch ];
  });

  nix = prev.nix.overrideAttrs (_: {
    outputs = [ "out" ];
    meta.outputsToInstall = [ "out" ];
  });
}
