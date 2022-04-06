module main

import term
import term.ui
import app { App, new_app }
import field { new_field }

fn main() {
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
