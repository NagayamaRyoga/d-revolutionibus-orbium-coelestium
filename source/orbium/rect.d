module orbium.rect;

import orbium.vec : Vec2;

///
struct Rect(T)
{
    private T _left;
    private T _top;
    private T _right;
    private T _bottom;

    ///
    this(T left, T top, T right, T bottom)
    {
        _left = left;
        _top = top;
        _right = right;
        _bottom = bottom;
    }

    ///
    this(Vec2!T topLeft, Vec2!T bottomRight)
    {
        this(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);
    }

    ///
    Vec2!T lerp(T u, T v) const
    {
        return Vec2!T(left + width * u, top + height * v);
    }

    ///
    @property T left() const
    {
        return _left;
    }

    ///
    @property T top() const
    {
        return _top;
    }

    ///
    @property T bottom() const
    {
        return _bottom;
    }

    ///
    @property T right() const
    {
        return _right;
    }

    ///
    @property Vec2!T topLeft() const
    {
        return Vec2!T(left, top);
    }

    ///
    @property Vec2!T bottomRight() const
    {
        return Vec2!T(_right, _bottom);
    }

    ///
    @property T width() const
    {
        return _right - _left;
    }

    ///
    @property T height() const
    {
        return _bottom - _top;
    }
}

alias RectI = Rect!int;
alias RectF = Rect!float;
