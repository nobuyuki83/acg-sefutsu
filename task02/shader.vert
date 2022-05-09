#version 120

// see the GLSL 1.2 specification:
// https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf

#define PI 3.1415926538

varying vec3 normal;  // normal vector pass to the rasterizer
uniform float cam_z_pos;  // camera z position specified by main.cpp

void main()
{
    normal = vec3(gl_Normal); // set normal

    // "gl_Vertex" is the *input* vertex coordinate of triangle.
    // "gl_Position" is the *output* vertex coordinate in the
    // "canonical view volume (i.e.. [-1,+1]^3)" pass to the rasterizer.
    // type of "gl_Vertex" and "gl_Position" are "vec4", which is homogeneious coordinate

    // modify code below to define transformation from input (x0,y0,z0) to output (x1,y1,z1)
    // such that after transformation, orthogonal z-projection will be fisheye lens effect
    // Specifically, achieve equidistance projection (https://en.wikipedia.org/wiki/Fisheye_lens)
    // the lens is facing +Z direction and lens's position is at (0,0,cam_z_pos)
    // the lens covers all the view direction
    // the "back" direction (i.e., -Z direction) will be projected as the unit circle in XY plane.
    // in GLSL, you can use built-in math function (e.g., sqrt, atan).
    // look at page 56 of https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf
    vec3 lens_pos = vec3(0, 0, cam_z_pos);
    vec3 lens2ver = gl_Vertex.xyz - lens_pos;
    float vx = lens2ver.x;
    float vy = lens2ver.y;
    float vz = lens2ver.z;

    float theta = atan(sqrt(vx * vx + vy * vy), vz);
    float phi = atan(vy, vx);
    float r = theta / PI;

    float x1 = r * cos(phi);
    float y1 = r * sin(phi);
    float z1 = length(lens2ver) / 4;
    gl_Position = vec4(x1,y1,z1,1); // homogenious coordinate
}
