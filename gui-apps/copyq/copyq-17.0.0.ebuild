# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature xdg

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="
	https://hluk.github.io/CopyQ
	https://github.com/hluk/CopyQ
"
SRC_URI="https://github.com/hluk/CopyQ/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3.0+"
SLOT="0"
RESTRICT="mirror"
KEYWORDS="-* amd64"
IUSE="X gnome +qca +keychain notification audio"
REQUIRED_USE="keychain? ( qca )"
# qtwayland will pull these
# - dev-libs/wayland
# - dev-qt/qtbase[gui,opengl,wayland]
# - dev-util/wayland-scanner
# qtsvg will pull these
# - dev-qt/qtbase[gui,widgets]
# almost of X11 library pulled by qtbase[X] default
# CopyQ needs X11lib, whatever!
DEPEND="
	dev-qt/qtbase:6[widgets,network,xml(+)]
	dev-qt/qtwayland:6
	dev-qt/qtsvg:6
	dev-qt/qtdeclarative:6
	kde-frameworks/kguiaddons
	x11-libs/libX11
	X? (
		dev-qt/qtbase:6=[X]
		x11-libs/libXfixes
		x11-libs/libXtst
	)

	keychain? (
		dev-libs/qtkeychain
	)

	qca? (
		app-crypt/qca
	)

	notification? (
		kde-frameworks/knotifications
		kde-frameworks/kstatusnotifieritem
	)
	
	audio? (
		dev-libs/miniaudio
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	dev-build/cmake
	dev-qt/qttools:6[linguist]
"

S="${WORKDIR}/CopyQ-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-x11lib-if-fix.patch"
)

src_configure() {
	local mycmakeargs=(
		-DPLUGIN_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/${PN}/plugins"
		-DWITH_QCA_ENCRYPTION="$(usex qca)"
		-DWITH_KEYCHAIN="$(usex keychain)"
		-DWITH_GNOME_CLIPBOARD_EXTENSION="$(usex gnome)"
		-DWITH_AUDIO="$(usex audio)"
		-DWITH_X11="$(usex X)"
		-DWITH_NATIVE_NOTIFICATIONS="$(usex notification)"
	)
	# The miniaudio ebuild which in Gentoo repo doins to /usr/inculde/miniaudio/"
	if use audio ; then
		mycmakeargs+=(
			-DMINIAUDIO_INCLUDE_DIR="/usr/include/miniaudio"
		)
	fi
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "legacy encryption work with" app-crypt/gnupg
}
