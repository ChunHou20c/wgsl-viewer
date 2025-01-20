{
  description = "An application to view wgsl code like shader toy";

  inputs = {
    unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = { 
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "unstable";
    };	
  };

  outputs =
    {
      self,
      unstable,
      flake-utils,
      rust-overlay,
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let

        overlays = [ (import rust-overlay) ];
        overlay_pkgs = import unstable { inherit system overlays; };
	rustPlatform = overlay_pkgs.makeRustPlatform {
	  cargo = overlay_pkgs.rust-bin.beta.latest.default;
	  rustc = overlay_pkgs.rust-bin.beta.latest.default;
	};

	buildInputs = with overlay_pkgs; [

	  libxkbcommon
	  wayland
	  vulkan-loader
	];

	nativeBuildInputs = [

	];

	libPath = overlay_pkgs.lib.makeLibraryPath buildInputs;


      in
      {
	packages = rec {
	  wgsl_viewer = rustPlatform.buildRustPackage {
	    pname = "wgsl_viewer";
	    version = "0.1.0";

	    src = ./.;
	    cargoLock = {
	      lockFile = ./Cargo.lock;
	    };
	    doCheck = false;

	    buildInputs = buildInputs ++ [overlay_pkgs.stdenv.cc.cc];
	    nativeBuildInputs = nativeBuildInputs ++ [overlay_pkgs.autoPatchelfHook];

	    postInstall = ''
	      patchelf --add-needed libxkbcommon-x11.so.0.0.0 $out/bin/${wgsl_viewer.pname}
	      patchelf --add-needed libwayland-client.so.0 $out/bin/${wgsl_viewer.pname}
	      patchelf --add-needed libvulkan.so.1 $out/bin/${wgsl_viewer.pname}
	      patchelf --set-rpath ${libPath} $out/bin/${wgsl_viewer.pname}
	    '';

	  };
	
	  default = wgsl_viewer;
	};

        devShells = {

          rust-stable = 
	    overlay_pkgs.mkShell {

	      buildInputs = buildInputs ++ [overlay_pkgs.rust-bin.beta.latest.default overlay_pkgs.bashInteractive];
	      nativeBuildInputs = nativeBuildInputs;

	      shellHook = ''

		SHELL=${overlay_pkgs.bashInteractive}/bin/bash
		echo "entering rust default stable build chain shell"
		'';

	      RUST_LOG = "info";
	      LD_LIBRARY_PATH = libPath;
	    };
        };
      }
    );
}
