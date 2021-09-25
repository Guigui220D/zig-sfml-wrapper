//! Shader class

const sf =  @import("../sfml.zig");
const glsl = sf.graphics.glsl;

const Shader = @This();

// Constructor/destructor

/// Creates a shader object from shader files, you can omit some shader types by passing null
pub fn createFromFile(
    vertex_shader_path: ?[:0]const u8, 
    geometry_shader_path: ?[:0]const u8, 
    fragment_shader_path: ?[:0]const u8
) !Shader {
    const shader = sf.c.sfShader_createFromFile(vertex_shader_path, geometry_shader_path, fragment_shader_path);
    if (shader) |s| {
        return Shader{ ._ptr = s };
    } else return sf.Error.nullptrUnknownReason;
}
/// Destroys this shader object
pub fn destroy(self: Shader) void {
    sf.c.sfShader_destroy(self._ptr);
}

// Availability

/// Checks whether or not shaders can be used in the system
pub fn isAvailable() bool {
    return sf.c.sfShader_isAvailable();
}
/// Checks whether or not geometry shaders can be used
pub fn isGeometryAvailable() bool {
    return sf.c.sfShader_isAvailable();
}

// Uniform 

/// Sets an uniform for the shader
/// Colors are vectors so if you want to pass a color use .toIVec4() or .toFVec4()
pub fn setUniform(self: Shader, name: [:0]const u8, value: anytype) void {
    const T = @TypeOf(value);
    switch (T) {
        f32 => sf.c.sfShader_setFloatUniform(self._ptr, name, value),
        c_int => sf.c.sfShader_setIntUniform(self._ptr, name, value), 
        bool => sf.c.sfShader_setBoolUniform(self._ptr, name, value),
        glsl.FVec2 => sf.c.sfShader_setVec2Uniform(self._ptr, name, value._toCSFML()), 
        glsl.FVec3 => sf.c.sfShader_setVec3Uniform(self._ptr, name, value._toCSFML()), 
        glsl.FVec4 => sf.c.sfShader_setVec4Uniform(self._ptr, name, @bitCast(sf.c.sfGlslVec4, value)), 
        glsl.IVec2 => sf.c.sfShader_setIvec2Uniform(self._ptr, name, value._toCSFML()), 
        glsl.IVec3 => sf.c.sfShader_setIvec3Uniform(self._ptr, name, @bitCast(sf.c.sfGlslIvec3, value)), 
        glsl.IVec4 => sf.c.sfShader_setIvec4Uniform(self._ptr, name, @bitCast(sf.c.sfGlslIvec4, value)), 
        glsl.BVec2 => sf.c.sfShader_setBvec2Uniform(self._ptr, name, @bitCast(sf.c.sfGlslBvec2, value)), 
        glsl.BVec3 => sf.c.sfShader_setBvec3Uniform(self._ptr, name, @bitCast(sf.c.sfGlslBvec3, value)), 
        glsl.BVec4 => sf.c.sfShader_setBvec4Uniform(self._ptr, name, @bitCast(sf.c.sfGlslBvec4, value)), 
        glsl.Mat3 => sf.c.sfShader_setMat3Uniform(self._ptr, name, @bitCast(sf.c.sfGlslMat3, value)), 
        glsl.Mat4 => sf.c.sfShader_setMat4Uniform(self._ptr, name, @bitCast(sf.c.sfGlslMat4, value)),
        sf.graphics.Texture => sf.c.sfShader_setTextureUniform(self._ptr, name, value._get()),
        else => @compileError("Uniform of type " ++ @typeName(T) ++ " cannot be set inside shader.")
    }
}

/// Pointer to the CSFML structure
_ptr: *sf.c.sfShader