module orbium.matrix;

import std.math : cos, sin;
import orbium.vec : Vec3;

///
struct Mat4x4(T)
{
    alias Self = typeof(this);

    ///
    T m11, m12, m13, m14;
    ///
    T m21, m22, m23, m24;
    ///
    T m31, m32, m33, m34;
    ///
    T m41, m42, m43, m44;

    ///
    this(T m11, T m12, T m13, T m14, T m21, T m22, T m23, T m24, T m31, T m32,
            T m33, T m34, T m41, T m42, T m43, T m44)
    {
        this.m11 = m11;
        this.m12 = m12;
        this.m13 = m13;
        this.m14 = m14;
        this.m21 = m21;
        this.m22 = m22;
        this.m23 = m23;
        this.m24 = m24;
        this.m31 = m31;
        this.m32 = m32;
        this.m33 = m33;
        this.m34 = m34;
        this.m41 = m41;
        this.m42 = m42;
        this.m43 = m43;
        this.m44 = m44;
    }

    ///
    Self opBinary(string op : "+")(Self rhs) const
    {
        return Self(m11 + rhs.m11, m12 + rhs.m12, m13 + rhs.m13, m14 + rhs.m14,
                m21 + rhs.m21, m22 + rhs.m22, m23 + rhs.m23, m24 + rhs.m24,
                m31 + rhs.m31, m32 + rhs.m32, m33 + rhs.m33, m34 + rhs.m34,
                m41 + rhs.m41, m42 + rhs.m42, m43 + rhs.m43, m44 + rhs.m44);
    }

    ///
    Self opBinary(string op : "-")(Self rhs) const
    {
        return Self(m11 - rhs.m11, m12 - rhs.m12, m13 - rhs.m13, m14 - rhs.m14,
                m21 - rhs.m21, m22 - rhs.m22, m23 - rhs.m23, m24 - rhs.m24,
                m31 - rhs.m31, m32 - rhs.m32, m33 - rhs.m33, m34 - rhs.m34,
                m41 - rhs.m41, m42 - rhs.m42, m43 - rhs.m43, m44 - rhs.m44);
    }

    ///
    Self opBinary(string op : "*")(Self rhs) const
    {
        return Self(m11 * rhs.m11 + m12 * rhs.m21 + m13 * rhs.m31 + m14 * rhs.m41,
                m11 * rhs.m12 + m12 * rhs.m22 + m13 * rhs.m32 + m14 * rhs.m42,
                m11 * rhs.m13 + m12 * rhs.m23 + m13 * rhs.m33 + m14 * rhs.m43,
                m11 * rhs.m14 + m12 * rhs.m24 + m13 * rhs.m34 + m14 * rhs.m44,
                m21 * rhs.m11 + m22 * rhs.m21 + m23 * rhs.m31 + m24 * rhs.m41,
                m21 * rhs.m12 + m22 * rhs.m22 + m23 * rhs.m32 + m24 * rhs.m42,
                m21 * rhs.m13 + m22 * rhs.m23 + m23 * rhs.m33 + m24 * rhs.m43,
                m21 * rhs.m14 + m22 * rhs.m24 + m23 * rhs.m34 + m24 * rhs.m44,
                m31 * rhs.m11 + m32 * rhs.m21 + m33 * rhs.m31 + m34 * rhs.m41,
                m31 * rhs.m12 + m32 * rhs.m22 + m33 * rhs.m32 + m34 * rhs.m42,
                m31 * rhs.m13 + m32 * rhs.m23 + m33 * rhs.m33 + m34 * rhs.m43,
                m31 * rhs.m14 + m32 * rhs.m24 + m33 * rhs.m34 + m34 * rhs.m44,
                m41 * rhs.m11 + m42 * rhs.m21 + m43 * rhs.m31 + m44 * rhs.m41,
                m41 * rhs.m12 + m42 * rhs.m22 + m43 * rhs.m32 + m44 * rhs.m42,
                m41 * rhs.m13 + m42 * rhs.m23 + m43 * rhs.m33 + m44 * rhs.m43,
                m41 * rhs.m14 + m42 * rhs.m24 + m43 * rhs.m34 + m44 * rhs.m44);
    }

    ///
    Vec3!T opBinaryRight(string op : "*")(Vec3!T v) const
    {
        return Vec3!T(v.x * m11 + v.y * m21 + v.z * m31 + m41,
                v.x * m12 + v.y * m22 + v.z * m32 + m42, v.x * m13 + v.y * m23 + v.z * m33 + m43);
    }

    ///
    static Self identity()
    {
        return Self(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    }

    ///
    static Self translate(Vec3!T v)
    {
        return Self(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, v.x, v.y, v.z, 1);
    }

    ///
    static Self rotateX(T rot)
    {
        const c = cos(rot);
        const s = sin(rot);
        return Self(1, 0, 0, 0, 0, c, -s, 0, 0, s, c, 0, 0, 0, 0, 1);
    }

    ///
    static Self rotateY(T rot)
    {
        const c = cos(rot);
        const s = sin(rot);
        return Self(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1);
    }

    ///
    static Self rotateZ(T rot)
    {
        const c = cos(rot);
        const s = sin(rot);
        return Self(c, -s, 0, 0, s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    }
}

alias Mat4x4F = Mat4x4!float;
