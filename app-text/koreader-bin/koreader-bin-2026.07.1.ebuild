# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

BIN_PN="koreader"

DESCRIPTION="KOReader is a document viewer primarily aimed at e-ink readers."
HOMEPAGE="https://koreader.rocks/"
SRC_URI="
	amd64? (
		https://github.com/koreader/koreader/releases/download/v${PV}/${BIN_PN}-linux-x86_64-v${PV}.tar.xz -> ${P}.tar.xz
	)
"
LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="mirror strip"
IUSE="doc"

QA_PREBUILT="
	usr/lib/koreader/*
	usr/bin/koreader
"

BDEPEND="app-arch/gzip"
RDEPEND="
	sys-libs/glibc
	x11-libs/libX11
	dev-libs/wayland
	x11-libs/libxkbcommon
"

S=${WORKDIR}

src_install() {
	dodir /usr
	cp -a "${S}"/bin "${S}"/lib "${S}"/share "${ED}"/usr/ || die
	gzip -d "${ED}"/usr/share/man/man1/koreader.1.gz || die

	if ! use doc ; then
		rm -rf "${ED}"/usr/share/doc/ || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
