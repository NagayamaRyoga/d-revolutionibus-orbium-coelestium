module orbium.screen;

import std.algorithm : fill;
import std.stdio : File;
import std.typecons : Tuple;
import orbium.util.ctor : defaultCtor;

private alias Int2 = Tuple!(int, "x", int, "y");

///
class Screen
{
    private int _width;
    private int _height;
    private ubyte[] _pixels;

    ///
    this(int width, int height)
    {
        _width = width;
        _height = height;
        _pixels = new ubyte[_width * _height];
    }

    ///
    @property int width() const
    {
        return _width;
    }

    ///
    @property int height() const
    {
        return _height;
    }

    ///
    void setPixel(int x, int y, ubyte pixel)
    {
        if (0 <= x && x < _width && 0 <= y && y < _height)
        {
            _pixels[x + y * _width] = pixel;
        }
    }

    ///
    ubyte getPixel(int x, int y) const
    {
        if (0 <= x && x < _width && 0 <= y && y < _height)
        {
            return _pixels[x + y * _width];
        }
        return 0;
    }

    ///
    void clear()
    {
        _pixels.fill(ubyte());
    }

    ///
    void render(File file)
    {
        const blockWidth = 2;
        const blockHeight = 4;

        string s;

        s ~= "\x1b[2J\x1b[H";

        foreach (by; 0 .. ((_height + blockHeight - 1) / blockHeight))
        {
            foreach (bx; 0 .. ((_width + blockWidth - 1) / blockWidth))
            {
                ubyte block = 0;

                immutable DOTS = [
                    Int2(0, 0), Int2(0, 1), Int2(0, 2), Int2(1, 0), Int2(1,
                            1), Int2(1, 2), Int2(0, 3), Int2(1, 3),
                ];

                foreach (i, dot; DOTS)
                {
                    const x = bx * blockWidth + dot.x;
                    const y = by * blockHeight + dot.y;
                    const pixel = getPixel(x, y);
                    if (pixel)
                    {
                        block |= 1 << i;
                    }
                }

                s ~= dchar(0x2800 | block);
            }
            s ~= '\n';
        }

        file.write(s);
        file.flush();
    }
}
