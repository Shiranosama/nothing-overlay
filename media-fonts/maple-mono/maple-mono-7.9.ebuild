# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Maple Mono is a monospace font focused on smoothing your coding flow."
HOMEPAGE="https://github.com/subframe7536/maple-font"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE="+hinted both cjk nerdfont"
RESTRICT="mirror"
REQUIRED_USE="both? ( cjk )"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

MY_GH="https://github.com/subframe7536/maple-font/releases/download/v${PV}"

SRC_URI="
	hinted? (
		both? (
			nerdfont? (
				${MY_GH}/MapleMono-NF-CN.zip -> ${P}-NF-CN.zip
				${MY_GH}/MapleMono-NF.zip -> ${P}-NF.zip
			)
			!nerdfont? (
				${MY_GH}/MapleMono-CN.zip -> ${P}-CN.zip
				${MY_GH}/MapleMono-TTF-AutoHint.zip -> ${P}-TTF-AutoHint.zip
			)
		)
		!both? (
			cjk? (
				nerdfont? ( ${MY_GH}/MapleMono-NF-CN.zip -> ${P}-NF-CN.zip )
				!nerdfont? ( ${MY_GH}/MapleMono-CN.zip -> ${P}-CN.zip )
			)
			!cjk? (
				nerdfont? ( ${MY_GH}/MapleMono-NF.zip -> ${P}-NF.zip )
				!nerdfont? ( ${MY_GH}/MapleMono-TTF-AutoHint.zip -> ${P}-TTF-AutoHint.zip )
			)
		)
	)
	!hinted? (
		both? (
			nerdfont? (
				${MY_GH}/MapleMono-NF-CN-unhinted.zip -> ${P}-NF-CN-unhinted.zip
				${MY_GH}/MapleMono-NF-unhinted.zip -> ${P}-NF-unhinted.zip
			)
			!nerdfont? (
				${MY_GH}/MapleMono-CN-unhinted.zip -> ${P}-CN-unhinted.zip
				${MY_GH}/MapleMono-TTF.zip -> ${P}-TTF.zip
			)
		)
		!both? (
			cjk? (
				nerdfont? ( ${MY_GH}/MapleMono-NF-CN-unhinted.zip -> ${P}-NF-CN-unhinted.zip )
				!nerdfont? ( ${MY_GH}/MapleMono-CN-unhinted.zip -> ${P}-CN-unhinted.zip )
			)
			!cjk? (
				nerdfont? ( ${MY_GH}/MapleMono-NF-unhinted.zip -> ${P}-NF-unhinted.zip )
				!nerdfont? ( ${MY_GH}/MapleMono-TTF.zip -> ${P}-TTF.zip )
			)
		)
	)
"
S="${WORKDIR}"
FONT_SUFFIX="ttf"
