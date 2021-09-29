// heat_shader.vs
// for the heat_haze example by by binary1248

#version 130

// Simple passthrough vertex shader... Nothing fancy here.
void main()
{
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    gl_FrontColor = gl_Color;
}