module orbium.graphics.renderer;

import std.algorithm : max, min;
import orbium.image : Image;
import orbium.matrix : Mat4x4F;
import orbium.rect : RectF, RectI;
import orbium.screen : Screen;
import orbium.vec : Float2, Float4, Int2;
import orbium.vertex : Vertex;

///
class Renderer
{
    private Screen _target;
    private RectF _viewRect;
    private Mat4x4F _transform;
    private Image _texture;

    ///
    this(Screen target)
    {
        _target = target;
        _viewRect = RectF(-1, -1, 1, 1);
        _transform = Mat4x4F.identity;
        _texture = null;
    }

    ///
    void renderPolygon(const Vertex[] vertices)
    {
        for (size_t i = 2; i < vertices.length; i++)
        {
            renderTriangle(vertices[i - 2], vertices[i - 1], vertices[i - 0]);
        }
    }

    ///
    void renderTriangle(inout ref Vertex v1, inout ref Vertex v2, inout ref Vertex v3)
    {
        const p1 = applyTransform(v1);
        const p2 = applyTransform(v2);
        const p3 = applyTransform(v3);

        const viewBound = polygonBound(p1.pos, p2.pos, p3.pos);
        const screenBound = toScreenBound(viewBound);

        const a = p2.pos.xy - p1.pos.xy;
        const b = p3.pos.xy - p1.pos.xy;
        const axb = a.cross(b);

        foreach (y; screenBound.top .. screenBound.bottom)
        {
            foreach (x; screenBound.left .. screenBound.right)
            {
                const p = toViewPos(Int2(x, y));
                const q = p1.pos.xy - p;
                const s = -q.cross(b) / axb;
                const t = q.cross(a) / axb;
                const r = 1 - s - t;

                if (0 <= s && 0 <= t && 0 <= r)
                {
                    const w = p1.pos.w * r + p2.pos.w * s + p3.pos.w * t;
                    const uv = (p1.uv * r + p2.uv * s + p3.uv * t) / w;
                    _target.setPixel(x, y, sampleTexture(uv));
                }
            }
        }
    }

    ///
    @property Mat4x4F transform() const
    {
        return _transform;
    }

    ///
    @property void transform(Mat4x4F m)
    {
        _transform = m;
    }

    ///
    @property const(Image) texture() const
    {
        return _texture;
    }

    ///
    @property void texture(Image texture)
    {
        _texture = texture;
    }

    private Vertex applyTransform(Vertex v) const
    {
        v.pos = v.pos * _transform;
        const invW = 1 / v.pos.w;
        v.uv = v.uv * invW;
        v.pos = v.pos * invW;
        v.pos.w = invW;
        return v;
    }

    private RectF polygonBound(inout ref Float4 p1, inout ref Float4 p2, inout ref Float4 p3) const
    {
        const l = min(p1.x, p2.x, p3.x).max(_viewRect.left);
        const t = min(p1.y, p2.y, p3.y).max(_viewRect.top);
        const r = max(p1.x, p2.x, p3.x).min(_viewRect.right);
        const b = max(p1.y, p2.y, p3.y).min(_viewRect.bottom);
        return RectF(l, t, r, b);
    }

    private Int2 toScreenPos(Float2 viewPos) const
    {
        const u = (viewPos.x - _viewRect.left) / _viewRect.width;
        const v = (viewPos.y - _viewRect.top) / _viewRect.height;

        return Int2(cast(int)(u * _target.width), cast(int)(v * _target.height));
    }

    private RectI toScreenBound(inout ref RectF viewBound) const
    {
        return RectI(toScreenPos(viewBound.topLeft), toScreenPos(viewBound.bottomRight));
    }

    private Float2 toViewPos(Int2 screenPos) const
    {
        const u = (screenPos.x + 0.5f) / _target.width;
        const v = (screenPos.y + 0.5f) / _target.height;

        const x = u * _viewRect.width + _viewRect.left;
        const y = v * _viewRect.height + _viewRect.top;
        return Float2(x, y);
    }

    private ubyte sampleTexture(Float2 uv) const
    {
        if (_texture is null)
        {
            return 0xff;
        }

        const x = cast(int)(uv.x * _texture.width);
        const y = cast(int)(uv.y * _texture.height);

        return cast(ubyte) _texture.pixel(x, y);
    }
}
