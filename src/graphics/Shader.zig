//! Shader class

const sf = @import("../root.zig");
const glsl = sf.graphics.glsl;

const Shader = @This();

// Constructor/destructor

/// Creates a shader object from shader files, you can omit some shader types by passing null
pub fn createFromFile(vertex_shader_path: ?[:0]const u8, geometry_shader_path: ?[:0]const u8, fragment_shader_path: ?[:0]const u8) !Shader {
    const shader = sf.c.sfShader_createFromFile(if (vertex_shader_path) |vsp| @as([*c]const u8, @ptrCast(vsp)) else null, if (geometry_shader_path) |gsp| @as([*c]const u8, @ptrCast(gsp)) else null, if (fragment_shader_path) |fsp| @as([*c]const u8, @ptrCast(fsp)) else null);
    if (shader) |s| {
        return Shader{ ._ptr = s };
    } else return sf.Error.nullptrUnknownReason;
}
/// Create a shader object from glsl code as string, you can omit some shader types by passing null
pub fn createFromMemory(vertex_shader: ?[:0]const u8, geometry_shader: ?[:0]const u8, fragment_shader: ?[:0]const u8) !Shader {
    const shader = sf.c.sfShader_createFromMemory(if (vertex_shader) |vs| @as([*c]const u8, @ptrCast(vs)) else null, if (geometry_shader) |gs| @as([*c]const u8, @ptrCast(gs)) else null, if (fragment_shader) |fs| @as([*c]const u8, @ptrCast(fs)) else null);
    if (shader) |s| {
        return Shader{ ._ptr = s };
    } else return sf.Error.nullptrUnknownReason;
}
/// Destroys this shader object
pub fn destroy(self: *Shader) void {
    sf.c.sfShader_destroy(self._ptr);
    self._ptr = undefined;
}

// Availability

/// Checks whether or not shaders can be used in the system
pub fn isAvailable() bool {
    return sf.c.sfShader_isAvailable() != 0;
}
/// Checks whether or not geometry shaders can be used
pub fn isGeometryAvailable() bool {
    return sf.c.sfShader_isAvailable() != 0;
}

const CurrentTextureT = struct {};
/// Special value to pass to setUniform to have an uniform of the texture used for drawing
/// which cannot be known in advance
pub const CurrentTexture: CurrentTextureT = .{};

// Uniform

/// Sets an uniform for the shader
/// Colors are vectors so if you want to pass a color use .toIVec4() or .toFVec4()
/// Pass CurrentTexture if you want to have the drawing texture as an uniform, which cannot be known in advance
pub fn setUniform(self: *Shader, name: [:0]const u8, value: anytype) void {
    const T = @TypeOf(value);
    switch (T) {
        f32 => sf.c.sfShader_setFloatUniform(self._ptr, name, value),
        c_int => sf.c.sfShader_setIntUniform(self._ptr, name, value),
        bool => sf.c.sfShader_setBoolUniform(self._ptr, name, if (value) 1 else 0),
        glsl.FVec2 => sf.c.sfShader_setVec2Uniform(self._ptr, name, value._toCSFML()),
        glsl.FVec3 => sf.c.sfShader_setVec3Uniform(self._ptr, name, value._toCSFML()),
        glsl.FVec4 => sf.c.sfShader_setVec4Uniform(self._ptr, name, @as(sf.c.sfGlslVec4, @bitCast(value))),
        glsl.IVec2 => sf.c.sfShader_setIvec2Uniform(self._ptr, name, value._toCSFML()),
        glsl.IVec3 => sf.c.sfShader_setIvec3Uniform(self._ptr, name, @as(sf.c.sfGlslIvec3, @bitCast(value))),
        glsl.IVec4 => sf.c.sfShader_setIvec4Uniform(self._ptr, name, @as(sf.c.sfGlslIvec4, @bitCast(value))),
        glsl.BVec2 => sf.c.sfShader_setBvec2Uniform(self._ptr, name, @as(sf.c.sfGlslBvec2, @bitCast(value))),
        glsl.BVec3 => sf.c.sfShader_setBvec3Uniform(self._ptr, name, @as(sf.c.sfGlslBvec3, @bitCast(value))),
        glsl.BVec4 => sf.c.sfShader_setBvec4Uniform(self._ptr, name, @as(sf.c.sfGlslBvec4, @bitCast(value))),
        glsl.Mat3 => sf.c.sfShader_setMat3Uniform(self._ptr, name, @as(*const sf.c.sfGlslMat3, @ptrCast(@alignCast(&value)))),
        glsl.Mat4 => sf.c.sfShader_setMat4Uniform(self._ptr, name, @as(*const sf.c.sfGlslMat4, @ptrCast(@alignCast(&value)))),
        sf.graphics.Texture => sf.c.sfShader_setTextureUniform(self._ptr, name, value._get()),
        CurrentTextureT => sf.c.sfShader_setCurrentTextureUniform(self._ptr, name),
        []const f32 => sf.c.sfShader_setFloatUniformArray(self._ptr, name, value.ptr, value.len),
        []const glsl.FVec2 => sf.c.sfShader_setVec2UniformArray(self._ptr, name, @as(*sf.c.sfGlslVec2, @ptrCast(value.ptr)), value.len),
        []const glsl.FVec3 => sf.c.sfShader_setVec3UniformArray(self._ptr, name, @as(*sf.c.sfGlslVec3, @ptrCast(value.ptr)), value.len),
        []const glsl.FVec4 => sf.c.sfShader_setVec4UniformArray(self._ptr, name, @as(*sf.c.sfGlslVec4, @ptrCast(value.ptr)), value.len),
        []const glsl.Mat3 => sf.c.sfShader_setMat3UniformArray(self._ptr, name, @as(*sf.c.sfGlslMat3, @ptrCast(value.ptr)), value.len),
        []const glsl.Mat4 => sf.c.sfShader_setMat4UniformArray(self._ptr, name, @as(*sf.c.sfGlslVec4, @ptrCast(value.ptr)), value.len),
        else => @compileError("Uniform of type \"" ++ @typeName(T) ++ "\" cannot be set inside shader."),
    }
}

/// Pointer to the CSFML structure
_ptr: *sf.c.sfShader
