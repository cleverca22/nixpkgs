{ stdenv, fetchFromGitHub, gmp, mpfr, libmpc, binutils-vc4-unwrapped, flex }:

stdenv.mkDerivation {
  name = "gcc-vc4";
  src = fetchFromGitHub {
    owner = "itszor";
    repo = "gcc-vc4";
    rev = "e90ff43f9671c760cf0d1dd62f569a0fb9bf8918";
    sha256 = "0gxf66hwqk26h8f853sybphqa5ca0cva2kmrw5jsiv6139g0qnp8";
  };
  configureFlags = [
    "--build=x86_64-unknown-linux-gnu"
    "--host=x86_64-unknown-linux-gnu"
    "--target=vc4-elf"
    "--enable-lto"
    "--with-as=${binutils-vc4-unwrapped}/bin/vc4-elf-as"
    "--with-ar=${binutils-vc4-unwrapped}/bin/vc4-elf-ar"
    "--with-ld=${binutils-vc4-unwrapped}/bin/vc4-elf-ld"
    "--disable-werror"
    "--disable-multilib"
    "--disable-bootstrap"
    "--disable-shared"
  ];
  buildInputs = [ gmp mpfr libmpc flex ];
  nativeBuildInputs = [ binutils-vc4-unwrapped ];
  dontUpdateAutotoolsGnuConfigScripts = true;
  hardeningDisable = [ "all" ];
  preConfigure = ''
    # Perform the build in a different directory.
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
  '';
  doCheck = false;
}
