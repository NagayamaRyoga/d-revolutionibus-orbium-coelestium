module orbium.vec;

///
struct Vec2(T)
{
    alias Self = typeof(this);

    ///
    T x, y;

    ///
    this(T x, T y)
    {
        this.x = x;
        this.y = y;
    }

    ///
    Self opBinary(string op)(Self rhs) const if (op == "+" || op == "-")
    {
        return Self(mixin("this.x " ~ op ~ " rhs.x"), mixin("this.y " ~ op ~ " rhs.y"));
    }

    ///
    T dot(Self rhs) const
    {
        return x * rhs.y - y * rhs.x;
    }
}

///
struct Vec4(T)
{
    alias Self = typeof(this);

    ///
    T x, y, z, w;

    ///
    this(T x, T y, T z, T w)
    {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    ///
    Self opBinary(string op)(T rhs) const if (op == "*" || op == "/")
    {
        return Self(mixin("this.x " ~ op ~ " rhs"), mixin("this.y " ~ op ~ " rhs"),
                mixin("this.z " ~ op ~ " rhs"), mixin("this.w " ~ op ~ " rhs"));
    }

    ///
    @property Vec2!T xy() const
    {
        return Vec2!T(x, y);
    }
}

alias Int2 = Vec2!int;
alias Float2 = Vec2!float;
alias Float4 = Vec4!float;
