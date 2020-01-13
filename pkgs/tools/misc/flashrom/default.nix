{ lib, stdenv, pkgconfig, libftdi, pciutils, fetchpatch, fetchgit }:

stdenv.mkDerivation rec {
  pname = "flashrom";
  version = "1.1";

  src = fetchgit {
    url = "https://review.coreboot.org/flashrom.git";
    rev = "370a9f3eea20a575f32ebf6ecead7ccf7562a2c0";
    sha256 = "16bfc12cfr1p0qfvvis85bmwxjzkrznz2cnmz0hrwsfqz83cd1yz";
  };

  # Newer versions of libusb deprecate some API flashrom uses.
  #postPatch = ''
  #  substituteInPlace Makefile \
  #    --replace "-Werror" "-Werror -Wno-error=deprecated-declarations -Wno-error=unused-const-variable="
  #'';
  patches = [
    (fetchpatch {
      url = "https://paste.flashrom.org/view.php?id=3252";
      sha256 = "1d7c24zw2zbbqlx0m8b33wwmgrk97xbb1zqqpp077r4n3b7p9gc8";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libftdi pciutils ];

  preConfigure = "export PREFIX=$out";

  meta = with lib; {
    homepage = http://www.flashrom.org;
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = licenses.gpl2;
    maintainers = with maintainers; [ funfunctor fpletz ];
    platforms = with platforms; linux;
  };
}
