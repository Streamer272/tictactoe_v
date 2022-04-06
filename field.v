module field

import term
import term.ui
import content
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

	mut current_row := ""
	mut board := []string{}
	for index, box in field.boxes {
		value := box.content.str()

		match index % 3 {
			0 {
				if box.selected {
					current_row += "[ $value ]"
				}
				else if field.boxes[index + 1].selected {
					current_row += "| $value ["
				}
				else {
					current_row += "| $value |"
				}
			}
			1 {
				current_row += " $value "
			}
			2 {
				if box.selected {
					current_row += "[ $value ]"
				}
				else if field.boxes[index - 1].selected {
					current_row += "] $value |"
				}
				else {
					current_row += "| $value |"
				}

				board << current_row
				current_row = ""
			}
			else {}
		}
	}

	for index, row in board {
		field.tui.draw_text((field.tui.window_width - 13) / 2, (field.tui.window_height - 3) / 2 + index, row)
	}
}

pub fn (mut field Field) select_box(direction Direction) {
	selected := field.boxes.filter(it.selected)[0]
	index := field.boxes.index(selected)

	match direction {
		.up {
			if index < 3 {
				return
			}
			field.boxes[index - 3].selected = true
		}
		.down {
			if index > 5 {
				return
			}
			field.boxes[index + 3].selected = true
		}
		.left {
			if index % 3 == 0 {
				return
			}
			field.boxes[index - 1].selected = true
		}
		.right {
			if index % 3 == 2 {
				return
			}
			field.boxes[index + 1].selected = true
		}
	}

	field.boxes[index].selected = false
}
