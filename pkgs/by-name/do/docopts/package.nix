{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  gawk,
  gnugrep,
  gnused,
}:
buildGoModule (finalAttrs: {
  pname = "docopts";
  version = "0.6.4-with-no-mangle-double-dash";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = "docopts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GIBrJ5qexeJ6ul5ek9LJZC4J3cNExsTrnxdzRCfoqn8=";
  };

  vendorHash = "sha256-+pMgaHB69itbQ+BDM7/oaJg3HrT1UN+joJL7BO/2vxE=";

  # Only build the main CLI; json_t and test_json_load are test/helper binaries
  subPackages = [ "." ];

  patches = [
    # Hardcode store paths for dependencies
    ./store_paths.patch

    # Migrate project to Go modules.
    (fetchpatch {
      url = "https://github.com/docopt/docopts/pull/74/commits/2c516165e72b35516a64c4529dbc938c0aaa9442.patch";
      hash = "sha256-Tp05B3tmctnSYIQzCxCc/fhcAWWuEz2ifu/CQZt0XPU=";
    })
  ];

  # When updating, check carefully if docopts.sh calls any additional
  # executables and add them here and in store_path.patch accordingly.
  preFixup = ''
    substituteInPlace $out/bin/docopts.sh \
      --replace-fail "declare -A _from_nix_store" \
        "${builtins.concatStringsSep "\n" [
          "declare -A _from_nix_store"
          "_from_nix_store[akw]=${lib.getExe gawk}"
          "_from_nix_store[sed]=${lib.getExe gnused}"
          "_from_nix_store[grep]=${lib.getExe gnugrep}"
        ]}"
  '';

  # Install docopts.sh in PATH to allow sourcing, and replace any
  # binary reference with nixpkgs binary paths.
  postInstall = ''
    install -D -m 444 docopts.sh $out/bin/docopts.sh
  '';

  meta = {
    homepage = "https://github.com/docopt/docopts";
    description = "Shell interpreter for docopt, the command-line interface description language";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.confus ];
    platforms = lib.platforms.unix;
  };
})
