module field

import term
import term.ui
import content
import box { Box }
import direction { Direction }

pub struct Field {
mut:
	tui &ui.Context
	width int
	height int
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

fn (field Field) selected() int {
	return field.boxes.index(field.boxes.filter(it.selected)[0])
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

				if index != 8 {
					board << "|---+---+---|"
				}

				current_row = ""
			}
			else {}
		}
	}

	if field.width == 0 {
		field.width = (field.tui.window_width - 13) / 2
	}
	if field.height == 0 {
		field.height = (field.tui.window_height - 5) / 2
	}
	for index, row in board {
		field.tui.draw_text(field.width, field.height + index, row)
	}
}

pub fn (mut field Field) move(direction Direction) {
	index := field.selected()

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

pub fn (mut field Field) select_box(character rune) bool {
	index := field.selected()

	if field.boxes[index].content == content.covered {
		field.boxes[index].content = character
		return true
	}

	return false
}

pub fn (mut field Field) is_full() bool {
	return field.boxes.filter(it.content == content.covered).len == 0
}
