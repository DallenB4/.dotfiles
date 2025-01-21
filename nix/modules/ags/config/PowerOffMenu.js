
const WINDOW_NAME = "PowerOffMenu"



export const PowerOffMenu = Widget.Window({
	name: WINDOW_NAME,
	setup: self => self.keybind("Escape", () => {
		App.closeWindow(WINDOW_NAME)
	}),
	visible: false,
	keymode: "exclusive",
})
