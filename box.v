module box

import content { Content }

pub struct Box {
pub mut:
	content Content
}

pub fn new_box(index int) Box {
	return Box { content: if index == 4 { Content.selected } else { Content.covered } }
}
