{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, tinycmmc }:
    tinycmmc.lib.eachWin32SystemWithPkgs (pkgs:
      {
        packages = rec {
          default = curl;

          curl = pkgs.stdenv.mkDerivation {
            pname = "curl";
            version = "2.0.22";

            src = if pkgs.system == "i686-windows"
                  then pkgs.fetchurl {
                    url = "https://curl.se/windows/dl-7.84.0_9/curl-7.84.0_9-win32-mingw.zip";
                    hash = "sha256-nj2Av5hD/2+dcBN03y12yggiNdUE62Zbuxx+gkVOokY=";
                  }
                  else pkgs.fetchurl {
                    url = "https://curl.se/windows/dl-7.84.0_9/curl-7.84.0_9-win64-mingw.zip";
                    hash = "sha256-ngmXD/BaKo4k79/15SI++mHlilufHStvQNJmtVYfGbk=";
                  };

            unpackPhase = ''
              ${pkgs.buildPackages.unzip}/bin/unzip $src
            ''
            + (if pkgs.system == "i686-windows"
               then "cd curl-7.84.0_9-win32-mingw/\n"
               else "cd curl-7.84.0_9-win64-mingw/\n");

            installPhase = ''
              ls -l
              mkdir $out
              cp -vr bin $out/
              cp -vr include $out/
              cp -vr lib $out/
            '';
          };
        };
      }
    );
}
