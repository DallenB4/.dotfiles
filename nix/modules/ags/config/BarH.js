const hyprland = await Service.import("hyprland")
const network = await Service.import("network")
const audio = await Service.import("audio")
const bluetooth = await Service.import("bluetooth")
const systemtray = await Service.import("systemtray")

const SCROLL_INCREMENT = 0.02

const Divider = () => Widget.Label({
	class_name: "divider",
	label: "  ",
})

// ===Left Widgets===

const WindowTitle = () => Widget.Label({
	class_name: "window-title",
	label: hyprland.active.client.bind("class")
		.as(window => window.toLowerCase()),
})

function Left() {
	return Widget.Box({
		children: [
			Widget.Label({
				class_name: "userhost",
				label: `[${Utils.exec("whoami")}@${Utils.exec("cat /etc/hostname")}:~]$ `,
			}),
			WindowTitle(),
		]
	})
}

// ===Center Widgets===

const time = Variable('', { poll: [1000, () => Utils.exec("date '+%I  ❖  %M'")] })

function Center() {
	return Widget.Label({
		class_name: "clock",
		label: time.bind()
	})
}

// ===Right Widgets===

/* @param {import('types/service/systemtray').TrayItem} item */
const SysTrayItem = item => Widget.Button({
	child: Widget.Icon().bind('icon', item, 'icon'),
	tooltipMarkup: item.bind('tooltip_markup'),
	onPrimaryClick: (_, event) => item.activate(event),
	onSecondaryClick: (_, event) => item.openMenu(event),
});

const sysTrayExpanded = Variable(false);

function sysTray() {
	const tray = Widget.EventBox({
		on_primary_click: () => sysTrayExpanded.value = !sysTrayExpanded.value,
		// on_hover_lost: () => sysTrayExpanded.value = false,
		child: Widget.Box({
			children: [
				Widget.EventBox({
					child: Widget.Box({
						children: [
							Widget.Revealer({
								revealChild: sysTrayExpanded.bind(),
								transitionDuration: 500,
								transition: "slide_right",
								child: Widget.Box({
									children: systemtray.bind('items').as(i => i.map(SysTrayItem))
								})
							}),
							Widget.Label({
								class_name: sysTrayExpanded.bind().as(e => e ? "chevron-active" : "chevron"),
								label: sysTrayExpanded.bind().as(e => e ? "  " : "  "),
							}),
						]
					})
				})
			]
		})
	})
	tray.connect("leave-notify-event", (_, event) => {
		sysTrayExpanded.value = false;
	})
	return tray;
}

const BluetoothStatus = () => Widget.EventBox({
	onPrimaryClick: () => Utils.execAsync("blueman-manager"),
	child: Widget.Label().hook(bluetooth, self => {
		const icon = () => !bluetooth.enabled ? ' 󰂲 '
			: bluetooth.connected_devices.length > 0 ? ' 󰂱 ' : ' 󰂯 '
		const tooltip = () => !bluetooth.enabled ? "Bluetooth Off"
			: `Connected (${bluetooth.connected_devices.length})`
			+ bluetooth.connected_devices.map(d => '\n• ' + d.name).join('')
		self.class_name = "bluetooth-status"
		self.label = icon()
		self.tooltip_text = tooltip()
	}),
})

const WifiStatus = () => Widget.EventBox({
	child: Widget.Label({
		label: '  ',
		tooltip_text: network.wifi.bind("strength").as(s =>
			`SSID ${network.wifi.ssid}\nStrength ${s}%`),
	}),
	onPrimaryClick: () => Utils.execAsync("nm-connection-editor"),
})

const WiredStatus = () => Widget.Label({ label: '  ', tooltip_text: "Ethernet" })

const NoneStatus = () => Widget.Label({ label: ' 󰇨 ', tooltip_text: "Disconnected" })

const NetworkStatus = () => Widget.Stack({
	children: {
		none: NoneStatus(),
		wifi: WifiStatus(),
		wired: WiredStatus(),
	},
	shown: network.bind("connectivity").as(c => c == "none" ? "none"
		: network.primary || 'none'),
})

const Connectivity = () => Widget.Box({
	children: [
		NetworkStatus(),
		BluetoothStatus(),
	]
})

const getFontIcon = (value, choices) => !value ? choices[0] :
	choices[Math.floor((value - 1) / (100 / (choices.length - 1))) + 1]

const speakerIcons = ['  ', '  ', '  ', '  ']
const microphoneIcons = [' 󰍭 ', '  ']

const AudioIcon = (type) => Widget.Label().hook(audio[type], self => {
	const vol = audio[type].volume * 100
	const icon = getFontIcon(audio[type].is_muted ? 0 : vol, type === 'microphone' ? microphoneIcons
		: speakerIcons)
	self.label = icon
})

function AudioSlider({ type = 'speaker', ...rest }) {
	return Widget.Slider({
		...rest,
		onChange: ({ value }) => audio[type].volume = value,
		value: audio[type].bind('volume')
	})
}

function AudioStatus(type) {
	return Widget.EventBox({
		on_middle_click: () => audio[type].is_muted = !audio[type].is_muted,
		on_scroll_up: () => audio[type].volume += SCROLL_INCREMENT,
		on_scroll_down: () => audio[type].volume -= SCROLL_INCREMENT,
		// on_hover: () => expanded[type].value = true,
		on_primary_click: () => expanded[type].value = !expanded[type].value,
		on_hover_lost: () => expanded[type].value = false,
		tooltip_text: audio[type].bind('volume').as(v => `Volume ${Math.floor(v * 100)}%`),
		child: Widget.Box({
			class_name: audio[type].bind("is_muted").as(m => m ? 'audio'
				: 'audio-muted'),
			children: [
				Widget.Revealer({
					reveal_child: expanded[type].bind(),
					transition_duration: 400,
					transition: "slide_left",
					child: AudioSlider({
						class_name: `slider ${type}-bar`,
						type,
						draw_value: false,
					}),
				}),
				AudioIcon(type),
			]
		}),
	})
}

const micExpanded = Variable(false)
const spkExpanded = Variable(false)
const expanded = { "speaker": spkExpanded, "microphone": micExpanded }

function AudioSection() {
	const audioSection = Widget.EventBox({
		child: Widget.Box({
			children: [
				AudioStatus("microphone"),
				AudioStatus("speaker"),
			],
		})
	})

	audioSection.connect("leave-notify-event", (_, event) => {
		micExpanded.value = false;
		spkExpanded.value = false;
	})

	return audioSection
}

function Right() {
	return Widget.Box({
		hpack: "end",
		children: [
			sysTray(),
			Divider(),
			AudioSection(),
			Divider(),
			Connectivity(),
		]
	});
}

// ===Bar & Window===

export const BarH = (monitor) => Widget.Window({
	monitor,
	name: `bar${monitor}`,
	anchor: ['top', 'left', 'right'],
	margins: [4, 4, 0, 4],
	exclusivity: 'exclusive',
	child: Widget.CenterBox({
		class_name: "box",
		start_widget: Left(),
		center_widget: Center(),
		end_widget: Right(),
	}),
})


