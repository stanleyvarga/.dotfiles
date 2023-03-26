#!/usr/bin/env zx

import 'zx/globals'

const PATH_APPLICATIONS = '/Applications'
const PATH_ICONS = '/Users/stanislavvarga/Desktop/Singularity/System/Assets/mac-icons'

const appPath = (a) => `${PATH_APPLICATIONS}/${a}.app`
const iconPath = (i) => `${PATH_ICONS}/${i}/active/*.icns`
const pipe = (...fns) => (x) => fns.reduce((v, f) => f(v), x);
const intersect = (a, b) => [...new Set(a)].filter(x => new Set(b).has(x));
const replaceBy = (search, replacement) => (str) => str.replace(search, replacement)
const splitBy = (delimiter) => (str) => str.split(delimiter)
const map = (fn) => (arr) => arr.map(fn)
const filter = (fn) => (arr) => arr.filter(fn)

const parseListDirectories = pipe(
		splitBy('\n'),
		filter((dir) => dir !== ''),
		map((dir) => dir.replace(PATH_ICONS, '').replace(PATH_APPLICATIONS, '').replace(/\//g, '').replace('.app', '')),
)

const setFileIcon = async (app) => {
	try {
		let icon = await glob(iconPath(app))
		await $`fileicon set ${appPath(app)} ${icon}`
	} catch (err) {
		console.error( '🚨 ERROR: ', err)
	}
}

void async function () {
	let iconDirectories = await $`ls -d ${PATH_ICONS}/*/`
	let AppDirectories = await $`ls -d ${PATH_APPLICATIONS}/*/`
	
	const appsHavingIcons = intersect(parseListDirectories(iconDirectories.toString()), parseListDirectories(AppDirectories.toString()))

	appsHavingIcons.forEach(setFileIcon)

	// ♻️ Refresh Icon cache, otherwise icons will not show up
	// Wait to ensure icons have been set
	setTimeout(async () => {
		await $`killall Dock; killall Finder`
	}, 2000)
}()
