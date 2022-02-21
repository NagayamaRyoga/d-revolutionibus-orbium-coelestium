module orbium.graphics.renderer;

import std.algorithm : max, min;
import orbium.matrix : Mat4x4F;
import orbium.rect : RectF, RectI;
import orbium.screen : Screen;
import orbium.vec : Float2, Float3, Int2;
import orbium.vertex : Vertex;

///
class Renderer
{
    private Screen _target;
    private RectF _viewRect;
    private Mat4x4F _transform;

    ///
    this(Screen target)
    {
        _target = target;
        _viewRect = RectF(-1, -1, 1, 1);
        _transform = Mat4x4F.identity;
    }

    ///
    void renderTriangle(inout ref Vertex v1, inout ref Vertex v2, inout ref Vertex v3)
    {
        const p1 = v1.pos * _transform;
        const p2 = v2.pos * _transform;
        const p3 = v3.pos * _transform;

        const viewBound = polygonBound(p1, p2, p3);
        const screenBound = toScreenBound(viewBound);

        const a = p2.xy - p1.xy;
        const b = p3.xy - p1.xy;
        const axb = a.dot(b);

        foreach (y; screenBound.top .. screenBound.bottom)
        {
            foreach (x; screenBound.left .. screenBound.right)
            {
                const p = toViewPos(Int2(x, y));
                const q = p1.xy - p;
                const s = -q.dot(b) / axb;
                const t = q.dot(a) / axb;

                if (0 <= s && s <= 1 && 0 <= t && t <= 1 && s + t <= 1)
                {
                    _target.setPixel(x, y, 1);
                }
            }
        }
    }

    ///
    @property void transform(Mat4x4F m)
    {
        _transform = m;
    }

    private RectF polygonBound(inout ref Float3 p1, inout ref Float3 p2, inout ref Float3 p3) const
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
}
