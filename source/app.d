import core.thread : Thread;
import std.complex : Complex;
import std.datetime : msecs;
import std.stdio : stderr;
import orbium.graphics.renderer : Renderer;
import orbium.matrix : Mat4x4F;
import orbium.screen : Screen;
import orbium.vec : Float2, Float3;
import orbium.vertex : Vertex;

void main()
{
    auto screen = new Screen(256, 256);
    auto renderer = new Renderer(screen);

    const Vertex v1 = Vertex(Float3(-0.2, -0.2, 0), Float2());
    const Vertex v2 = Vertex(Float3(+0.2, +0.2, 0), Float2());
    const Vertex v3 = Vertex(Float3(-0.2, +0.2, 0), Float2());

    foreach (i; 0 .. 30)
    {
        screen.clear();

        Mat4x4F m = Mat4x4F.translate(Float3(0.3, 0, 0)) * Mat4x4F.rotateZ(0.2 * i);
        renderer.transform = m;
        renderer.renderTriangle(v1, v2, v3);

        screen.render(stderr);
        Thread.sleep(50.msecs);
    }
}
