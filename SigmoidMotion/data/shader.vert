uniform mat4 transformMatrix; 
attribute vec4 position; 
attribute vec4 color; 
varying vec4 va_color; 
varying vec2 va_pos;
void main() { 
  gl_Position = transformMatrix * position; 
  va_color = color;
  va_pos = position.xy;
}
