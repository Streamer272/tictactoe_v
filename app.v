module app

import term
import term.ui
import field { Field }
import direction { Direction }

[heap]
pub struct App {
pub mut:
	tui   &ui.Context = 0
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
				.w, .k, .up {
					app.field.select_box(Direction.up)
				}
				.s, .j, .down {
					app.field.select_box(Direction.down)
				}
				.a, .h, .left {
					app.field.select_box(Direction.left)
				}
				.d, .l, .right {
					app.field.select_box(Direction.right)
				}
				else {}
			}
		}
		else {}
	}
}

pub fn (mut app App) frame() {
	app.tui.clear()
	app.field.display()
	app.tui.set_cursor_position(0, 0)
	app.tui.reset()
	app.tui.flush()
}
