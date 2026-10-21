# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BIN_P="dart-sass-${PV}"

DESCRIPTION="The reference implementation of Sass, written in Dart."
HOMEPAGE="https://sass-lang.com/dart-sass"
SRC_URI="https://github.com/sass/dart-sass/releases/download/${PV}/${BIN_P}-linux-x64.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="mirror strip"

S="${WORKDIR}/dart-sass"

src_install() {
	insinto /opt/dart-sass
	doins -r .
	fperms +x /opt/dart-sass/sass /opt/dart-sass/src/dart
	dosym /opt/dart-sass/sass /usr/bin/sass
}
