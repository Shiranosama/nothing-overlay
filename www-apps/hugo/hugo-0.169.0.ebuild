# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A fast and flexible static site generator built in Go"
HOMEPAGE="https://gohugo.io/"
SRC_URI="
	https://github.com/gohugoio/hugo/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Rannesama/my-portage-deps/releases/download/${P}/${P}-deps.tar.xz
"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="-* amd64"
# Although there is a full test workflow in Github repo,
# but I don't need it, so I won't write one.
IUSE="+deploy doc +extended"

# Dart Sass is required to transpile Sass to CSS
# when using the latest features of the Sass language.
# You can get it in the same overlay which you are reading.
RDEPEND="
	dev-lang/dart-sass-bin
"
BDEPEND="
	>=dev-lang/go-1.27.0
"
RESTRICT="mirror"

src_compile() {
	mkdir -pv bin || die
	
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"

	# New in v0.159.2: alone deploy version
	if use deploy && ! use extended ; then
		CGO_ENABLED=0 \
		ego build -tags withdeploy \
		-ldflags "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=gentoo:${PVR}" \
		-o "${S}/bin/hugo"
	elif use extended && ! use deploy ; then
		CGO_ENABLED=1 \
		ego build -tags extended \
		-ldflags "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=gentoo:${PVR}" \
		-o "${S}/bin/hugo"
	elif use extended && use deploy ; then
		CGO_ENABLED=1 \
		ego build -tags extended,withdeploy \
		-ldflags "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=gentoo:${PVR}" \
		-o "${S}/bin/hugo"
	elif ! use extended && ! use deploy ; then
		CGO_ENABLED=0 \
		ego build \
		-ldflags "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=gentoo:${PVR}" \
		-o "${S}/bin/hugo"
	fi

	bin/hugo gen man --dir man || die

	if use doc ; then
		bin/hugo gen doc --dir doc || die
	fi
}

src_install() {
	dobin bin/*
	doman man/*

	if use doc ; then
		dodoc -r doc/*
	fi
}
