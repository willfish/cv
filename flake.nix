{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-ruby }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
          overlays = [
            nixpkgs-ruby.overlays.default
          ];
        };

        ruby = pkgs."ruby-3.3.5";
        nokogiriBuildFlags = with pkgs; [
          "--use-system-libraries"
          "--with-zlib-lib=${zlib.out}/lib"
          "--with-zlib-include=${zlib.dev}/include"
          "--with-xml2-lib=${libxml2.out}/lib"
          "--with-xml2-include=${libxml2.dev}/include/libxml2"
          "--with-xslt-lib=${libxslt.out}/lib"
          "--with-xslt-include=${libxslt.dev}/include"
          "--with-exslt-lib=${libxslt.out}/lib"
          "--with-exslt-include=${libxslt.dev}/include"
        ] ++ lib.optionals stdenv.isDarwin [
          "--with-iconv-dir=${libiconv}"
          "--with-opt-include=${libiconv}/include"
        ];
        opensslBuildFlags = with pkgs; [
          "--with-openssl-include=${openssl.dev}/include"
          "--with-openssl-lib=${openssl.out}/lib"
        ];
        psychBuildFlags = with pkgs; [
          "--with-libyaml-include=${libyaml.dev}/include"
          "--with-libyaml-lib=${libyaml.out}/lib"
        ];

        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small xetex;
        };
      in {
        devShells.default = pkgs.mkShell {
          shellHook = ''
            export GEM_HOME=$PWD/.nix/ruby/$(${ruby}/bin/ruby -e "puts RUBY_VERSION")
            mkdir -p $GEM_HOME

            export BUNDLE_BUILD__NOKOGIRI="${
              builtins.concatStringsSep " " nokogiriBuildFlags
            }"
            export BUNDLE_BUILD__OPENSSL="${
              builtins.concatStringsSep " " opensslBuildFlags
            }"
            export BUNDLE_BUILD__PSYCH="${
              builtins.concatStringsSep " " psychBuildFlags
            }"

            export GEM_PATH=$GEM_HOME
            export PATH=$GEM_HOME/bin:$PATH
          '';

          buildInputs = [
            ruby
            pkgs.makeWrapper
            pkgs.pandoc
            texlive
          ];
        };
      });
}
