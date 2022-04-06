module box

import content

pub struct Box {
pub mut:
	selected bool
	content rune
}

pub fn new_box(index int) Box {
	return Box{
		selected: index == 4
		content: content.covered
	}
}
