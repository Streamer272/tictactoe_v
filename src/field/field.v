module field

import term
import term.ui
import box { Box, Content }

pub struct Field {
mut:
	tui &ui.Context
	width int
	height int
pub mut:
	boxes []Box
	frozen bool
}

pub fn new_field(tui &ui.Context) Field {
	unsafe {
		return Field{
			tui: tui
			boxes: []Box{len: 9, cap: 9, init: box.new_box(it)}
			frozen: false
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
		value := match box.content {
			.empty { `■` }
			.x { `X` }
			.y { `Y` }
		}

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

pub fn (mut field Field) select_box(content Content) ? {
	if field.frozen {
		return error("Field is frozen")
	}

	index := field.selected()

	if field.boxes[index].content != Content.empty {
		return error("Box not empty")
	}

	field.boxes[index].content = content
}

pub fn (field Field) is_full() bool {
	return field.boxes.filter(it.content == Content.empty).len == 0
}

pub fn (field Field) get_winner() ?Content {
	for i in 0..3 {
		// row
		row := i * 3
		if field.boxes[row].content == field.boxes[row + 1].content && field.boxes[row].content == field.boxes[row + 2].content && field.boxes[row].content != Content.empty {
			return field.boxes[row].content
		}

		// column
		if field.boxes[i].content == field.boxes[i + 3].content && field.boxes[i].content == field.boxes[i + 6].content && field.boxes[i].content != Content.empty {
			return field.boxes[i].content
		}
	}

	// other
	if field.boxes[0].content == field.boxes[4].content && field.boxes[0].content == field.boxes[8].content && field.boxes[0].content != Content.empty {
		return field.boxes[0].content
	}
	if field.boxes[2].content == field.boxes[4].content && field.boxes[2].content == field.boxes[6].content && field.boxes[2].content != Content.empty {
		return field.boxes[2].content
	}

	return error("No winner")
}
