{ stdenv, fetchFromGitHub, flex, bison, perl, zlib, gettext, texinfo }:

stdenv.mkDerivation {
  name = "binutils-vc4";
  src = fetchFromGitHub {
    owner = "itszor";
    repo = "binutils-vc4";
    rev = "708acc851880dbeda1dd18aca4fd0a95b2573b36";
    sha256 = "1kdrz6fki55lm15rwwamn74fnqpy0zlafsida2zymk76n3656c63";
  };
  buildInputs = [ zlib gettext ];
  nativeBuildInputs = [
    bison
    perl
    flex
    texinfo
  ];
  postConfigure = ''
    # As we regenerated configure build system tries hard to use
    # texinfo to regenerate manuals. Let's avoid the dependency
    # on texinfo in bootstrap path and keep manuals unmodified.
    touch gas/doc/.dirstamp
    touch gas/doc/asconfig.texi
    touch gas/doc/as.1
    touch gas/doc/as.info
  '';
  hardeningDisable = [ "all" ];
  configureFlags = [
    "--disable-werror"
    "--program-prefix=vc4-elf-"
    "--with-lib-path=:"
    #"--disable-shared" "--enable-static"
    "--target=vc4-elf"
  ];
  enableParallelBuilding = true;
  passthru = {
    targetPrefix = "vc4-elf-";
  };
  dontUpdateAutotoolsGnuConfigScripts = true;
}
