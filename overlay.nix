self: super:
let
  curlPatcher = curl: curl.overrideAttrs (oldAttrs: {
    configureFlags = (oldAttrs.configureFlags or [ ]) ++ [ "--without-ca-bundle" "--without-ca-path" ];
    postPatch = (oldAttrs.postPatch or "") + ''
      # --- PATCH 1: Disable SSL peer verification by default ---
      # This changes the default value of CURLOPT_SSL_VERIFYPEER to FALSE.
      echo "===> Patching lib/vtls/openssl.c to disable SSL peer verification..."
      substituteInPlace lib/vtls/openssl.c \
        --replace "data->set.ssl.primary.verifypeer = TRUE;" \
                  "data->set.ssl.primary.verifypeer = FALSE;"

      substituteInPlace lib/vtls/openssl.c \
        --replace "data->set.ssl.primary.verifyhost = TRUE;" \
                  "data->set.ssl.primary.verifyhost = FALSE;"

      # --- PATCH 2: Modify the --version output ---
      # This adds a warning to the `curl --version` command output.
      # The target file might be src/main.c or src/tool_main.c depending on curl version.
      echo "===> Patching src/tool_main.c to add custom version string..."
      substituteInPlace src/tool_help.c \
        --replace 'printf(CURL_ID "%s\n", curl_version());' \
                  'printf(CURL_ID "%s\nWARNING: SSL certificate check disabled!\n", curl_version());'
    '';
  });
in
{
  curl = curlPatcher super.curl;
}
