module app

import term
import term.ui
import content
import field { Field }
import direction { Direction }

[heap]
pub struct App {
mut:
	next rune
pub mut:
	tui   &ui.Context = 0
	field Field
}

pub fn new_app() App {
	return App{next: content.x}
}

pub fn (mut app App) event(e &ui.Event) {
	match e.typ {
		.key_down {
			match e.code {
				.escape, .q {
					exit(0)
				}
				.enter {
					if app.field.select_box(app.next) {
						app.next = match app.next {
							content.x { content.y }
							else { content.x }
						}
					}
				}
				.w, .k, .up {
					app.field.move(Direction.up)
				}
				.s, .j, .down {
					app.field.move(Direction.down)
				}
				.a, .h, .left {
					app.field.move(Direction.left)
				}
				.d, .l, .right {
					app.field.move(Direction.right)
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
