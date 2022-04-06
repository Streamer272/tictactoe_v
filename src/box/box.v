module box

pub struct Box {
pub mut:
	selected bool
	content Content
}

pub fn new_box(index int) Box {
	return Box{
		selected: index == 4
		content: Content.empty
	}
}
