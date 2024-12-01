shader_type canvas_item;

uniform vec4 blink_color:source_color;
uniform float blink_intensity;
uniform vec4 invincibility_color:source_color;
uniform float invincibility_intensity;

void fragment() {
	vec4 color =texture(TEXTURE,UV);
	color=mix(color,blink_color,blink_intensity*color.a);
	color=mix(color,invincibility_color,invincibility_intensity*color.a);
	COLOR=color;
}

