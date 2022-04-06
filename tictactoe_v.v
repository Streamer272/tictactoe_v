module main

import field { new_field }

import term
import term.ui

[heap]
struct App {
pub mut:
	tui &ui.Context = 0
}

fn (mut a App) event(e &ui.Event) {
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

fn main() {
	mut app := &App{}
	app.tui = ui.init(
		user_data: app,
		cleanup_fn: fn (a voidptr) {
			mut app := &App(a)
			app.free()
		}
		event_fn: fn (e &ui.Event, a voidptr) {
			println("Got event $e on $a")
			mut app := &App(a)
			app.event(e)
		}
		capture_events: true
		hide_cursor: true
		frame_rate: 60
	)
	app.tui.run() or { panic(err) }

	/*
	field := new_field()
	field.display()
	*/
}
