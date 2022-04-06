module field

import term
import term.ui

import box { Box }

pub struct Field {
mut:
	tui &ui.Context
pub mut:
	boxes []Box
}

pub fn new_field(tui &ui.Context) Field {
	unsafe {
		return Field { tui: tui, boxes: []Box{len: 9, cap: 9, init: box.new_box(it) } }
	}
}

pub fn (mut field Field) display() {
	d := 5
	x := "lmao $d"
	field.tui.draw_rect(0, 0, field.tui.window_width, field.tui.window_height)
	field.tui.draw_text(10, 10, x)
	/*
	for index, box in field.boxes {
		mut value := ""

		match box.content {
			.covered, .selected {
				value = "■"
			}
			.uncovered_x {
				value = "X"
			}
			.uncovered_o {
				value = "O"
			}
		}

		match index % 3 {
			0 {
				if box.content == .selected {
					print("[ $value ]")
				}
				else if field.boxes[index + 1].content == .selected {
					print("| $value [")
				}
				else {
					print("| $value |")
				}
			}
			1 {
				print(" $value ")
			}
			2 {
				if box.content == .selected {
					println("[ $value ]")
				}
				else if field.boxes[index - 1].content == .selected {
					println("] $value |")
				}
				else {
					println("| $value |")
				}
			}
			else {}
		}
	}
	*/
}
