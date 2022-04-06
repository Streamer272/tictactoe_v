module field

import box { Box }

pub struct Field {
pub mut:
	boxes []Box
}

pub fn new_field() Field {
	return Field { boxes: []Box{len: 9, cap: 9, init: box.new_box(it) } }
}

pub fn (field &Field) display() {
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
}
