module app

import term
import term.ui

import field { Field }

[heap]
pub struct App {
pub mut:
	tui &ui.Context = 0
	field Field
}

pub fn new_app() App {
	return App{}
}

pub fn (mut app App) event(e &ui.Event) {
	match e.typ {
		.key_down {
			match e.code {
				.escape, .q {
					exit(0)
				}
				else {}
			}
		}
		else {}
	}
}

pub fn (mut app App) frame() {
	app.tui.clear()
	app.tui.set_bg_color(r: 63, g: 81, b: 181)
	app.field.display()
	app.tui.set_cursor_position(0, 0)
	app.tui.reset()
	app.tui.flush()
}
