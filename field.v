module field

import term
import term.ui
import box { Box }
import direction { Direction }

pub struct Field {
mut:
	tui &ui.Context
pub mut:
	boxes []Box
}

pub fn new_field(tui &ui.Context) Field {
	unsafe {
		return Field{
			tui: tui
			boxes: []Box{len: 9, cap: 9, init: box.new_box(it)}
		}
	}
}

pub fn (mut field Field) display() {
	field.tui.draw_rect(0, 0, field.tui.window_width, field.tui.window_height)

	board := ""
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

pub fn (mut field Field) select_box(direction Direction) {
	selected := field.boxes.filter(it.selected)[0]
	index := field.boxes.index(selected)

	match direction {
		.up {
			if index < 3 {
				return
			}
			field.boxes[index - 3].content = Content.selected
		}
		.down {
			if index > 6 {
				return
			}
			field.boxes[index + 3].content = Content.selected
		}
		.left {
			if index % 3 == 0 {
				return
			}
			field.boxes[index - 1].content = Content.selected
		}
		.right {
			if index % 3 == 2 {
				return
			}
			field.boxes[index + 1].content = Content.selected
		}
	}

	field.boxes[index].content = Content.covered
}
