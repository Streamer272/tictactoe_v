module src

import term
import term.ui
import src.box { Content }
import src.field { Direction, Field, new_field }

[heap]
pub struct App {
mut:
	next box.Content
pub mut:
	tui   &ui.Context = 0
	field field.Field
}

pub fn new_app() App {
	return App{
		next: Content.x
	}
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
						.x { Content.y }
						else { Content.x }
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
			Content.empty
		}
		message := 'Winner is $winner!'
		app.tui.draw_text((app.tui.window_width - message.len) / 2,
			(app.tui.window_height - 5) / 2 + 6, message)
		app.field.frozen = true
		goto finish
	}
	no_winner:
	if app.field.is_full() {
		message := 'Field is full, no one is winner!'
		app.tui.draw_text((app.tui.window_width - message.len) / 2,
			(app.tui.window_height - 5) / 2 + 6, message)
		app.field.frozen = true
	}

	finish:
	app.tui.flush()
}

pub fn run() {
	mut app := new_app()
	app.tui = ui.init(
		user_data: &app
		cleanup_fn: fn (a voidptr) {
			mut app := &App(a)
			app.free()
		}
		frame_fn: fn (a voidptr) {
			mut app := &App(a)
			app.frame()
		}
		event_fn: fn (e &ui.Event, a voidptr) {
			mut app := &App(a)
			app.event(e)
		}
		fail_fn: fn (error string) {
			panic(error)
		}
		capture_events: true
		hide_cursor: true
		frame_rate: 60
	)
	app.field = new_field(app.tui)
	app.tui.run() or { panic(err) }
}
