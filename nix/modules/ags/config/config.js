import { BarH } from "./BarH.js"
import { BarV } from "./BarV.js"
import { PowerOffMenu } from "./PowerOffMenu.js"

App.config({
	style: './style.css',
	windows: [
		BarH(0),
		PowerOffMenu
	],
})
