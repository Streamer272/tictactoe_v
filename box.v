module box

pub struct Box {
pub mut:
	selected bool
	content char
}

pub fn new_box(index int) Box {
	return Box{
		selected: index == 4
		content: `■`
	}
}
