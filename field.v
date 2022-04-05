module field

import box { Box }

pub struct Field {
pub mut:
	content []Box
}

pub fn new_field() Field {
	return Field { content: []Box{len: 9, cap: 9, init: box.new_box(it) } }
}
