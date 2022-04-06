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
					app.field.select_box(app.next) or { return }
					app.next = match app.next {
						content.x { content.y }
						else { content.x }
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

	unsafe {
		winner := app.field.get_winner() or {
			goto no_winner
			`E`
		}
		message := "Winner is $winner!"
		app.tui.draw_text((app.tui.window_width - message.len) / 2, (app.tui.window_height - 5) / 2 + 6, message)
		app.field.frozen = true
		goto finish
	}

	no_winner:
	if app.field.is_full() {
		message := "Field is full, no one is winner!"
		app.tui.draw_text((app.tui.window_width - message.len) / 2, (app.tui.window_height - 5) / 2 + 6, message)
		app.field.frozen = true
	}

	finish:
	app.tui.flush()
}
