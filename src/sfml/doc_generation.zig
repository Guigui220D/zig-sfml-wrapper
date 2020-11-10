//! This thing is just a hack to get the documentation generation working

const sf = @import("sfml");

pub fn main() !void {

    inline for ([3]type{sf.Vector2f, sf.Vector2i, sf.Vector2u}) |T|
    {
        var vecf = T{.x = 0, .y = 0};
        var c = vecf.toCSFML();
        vecf = T.fromCSFML(c);
        _ = vecf.add(vecf);
        _ = vecf.substract(vecf);
        _ = vecf.scale(1);
    }
    {
        var vecf = sf.Vector3f{.x = 0, .y = 0, .z = 0};
        var c = vecf.toCSFML();
        vecf = sf.Vector3f.fromCSFML(c);
    }
    {
        var col = sf.Color.fromRGB(0, 0, 0);
        col = sf.Color.fromRGBA(0, 0, 0, 0);
        col = sf.Color.fromInteger(0);
        col = sf.Color.fromHSVA(0, 0, 0, 0);
        var c = col.toCSFML();
        col = sf.Color.fromCSFML(c);
        _ = col.toInteger();

        col = sf.Color.Black;
        col = sf.Color.White;
        col = sf.Color.Red;
        col = sf.Color.Green;
        col = sf.Color.Blue;
        col = sf.Color.Yellow;
        col = sf.Color.Magenta;
        col = sf.Color.Cyan;
        col = sf.Color.Transparent;
    }
}
