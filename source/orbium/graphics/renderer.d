module orbium.graphics.renderer;

import std.algorithm : max, min;
import orbium.rect : RectF, RectI;
import orbium.screen : Screen;
import orbium.vec : Float2, Int2;
import orbium.vertex : Vertex;

///
class Renderer
{
    private Screen _target;
    private RectF _viewRect;

    ///
    this(Screen target)
    {
        _target = target;
        _viewRect = RectF(-1, -1, 1, 1);
    }

    ///
    void renderTriangle(inout ref Vertex v1, inout ref Vertex v2, inout ref Vertex v3)
    {
        const viewBound = polygonBound(v1, v2, v3);
        const screenBound = toScreenBound(viewBound);

        const a = v2.pos.xy - v1.pos.xy;
        const b = v3.pos.xy - v1.pos.xy;
        const axb = a.dot(b);

        foreach (y; screenBound.top .. screenBound.bottom)
        {
            foreach (x; screenBound.left .. screenBound.right)
            {
                const p = toViewPos(Int2(x, y));
                const q = v1.pos.xy - p;
                const s = -q.dot(b) / axb;
                const t = q.dot(a) / axb;

                if (0 <= s && s <= 1 && 0 <= t && t <= 1 && s + t <= 1)
                {
                    _target.setPixel(x, y, 1);
                }
            }
        }
    }

    private RectF polygonBound(inout ref Vertex v1, inout ref Vertex v2, inout ref Vertex v3) const
    {
        const l = min(v1.pos.x, v2.pos.x, v3.pos.x).max(_viewRect.left);
        const t = min(v1.pos.y, v2.pos.y, v3.pos.y).max(_viewRect.top);
        const r = max(v1.pos.x, v2.pos.x, v3.pos.x).min(_viewRect.right);
        const b = max(v1.pos.y, v2.pos.y, v3.pos.y).min(_viewRect.bottom);
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
