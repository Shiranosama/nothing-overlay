# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Hister is a private search engine for the pages you visit and the files you keep"
HOMEPAGE="https://hister.org/"
SRC_URI="
	https://github.com/asciimoo/hister/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Rannesama/my-portage-deps/releases/download/${P}/${P}-deps.tar.xz
	https://github.com/Rannesama/my-portage-deps/releases/download/${P}/${P}-npm-cache.tar.xz
"

LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="-* amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	net-libs/nodejs
	>=dev-lang/go-1.26.0
"
RESTRICT="mirror"

src_prepare() {
	default
	cd "${S}" || die
	export npm_config_cache="${WORKDIR}"/npm-cache
	export npm_config_offline=true
	export npm_config_audit=false
	export npm_config_fund=false
	ego generate ./...
}

src_compile() {
	local BUILD_FLAGS="-tags=netgo,osusergo"
	mkdir -p dist || die

	CGO_ENABLED=1 \
	ego build \
		$BUILD_FLAGS \
		-o dist/hister \
		.
}

src_install() {
	dobin dist/hister
	einstalldocs
}
