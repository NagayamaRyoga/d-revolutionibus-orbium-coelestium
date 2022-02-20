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
struct Vec3(T)
{
    alias Self = typeof(this);

    ///
    T x, y, z;

    ///
    this(T x, T y, T z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    ///
    @property Vec2!T xy() const
    {
        return Vec2!T(x, y);
    }
}

alias Int2 = Vec2!int;
alias Float2 = Vec2!float;
alias Float3 = Vec3!float;
