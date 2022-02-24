module orbium.image;

class Image
{
    private uint _width;
    private uint _height;
    private uint[] _pixels;

    ///
    this(uint width, uint height, uint[] pixels)
    {
        _width = width;
        _height = height;
        _pixels = pixels.dup;
        _pixels.length = _width * _height;
    }

    ///
    @property uint width() const
    {
        return _width;
    }

    ///
    @property uint height() const
    {
        return _height;
    }

    ///
    uint pixel(int x, int y) const
    {
        if (0 <= x && x < _width && 0 <= y && y < _height)
        {
            return _pixels[indexOf(x, y)];
        }
        return 0;
    }

    ///
    void setPixel(int x, int y, uint color)
    {
        if (0 <= x && x < _width && 0 <= y && y < _height)
        {
            _pixels[indexOf(x, y)] = color;
        }
    }

    private uint indexOf(int x, int y) const
    {
        return y * _width + x;
    }
}
