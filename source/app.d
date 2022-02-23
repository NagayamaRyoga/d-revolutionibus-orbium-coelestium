import core.thread : Thread;
import std.complex : Complex;
import std.datetime : msecs;
import std.math : PI;
import std.stdio : stderr;
import orbium.graphics.renderer : Renderer;
import orbium.matrix : Mat4x4F;
import orbium.screen : Screen;
import orbium.vec : Float2, Float4;
import orbium.vertex : Vertex;

void main()
{
    const width = 320;
    const height = 240;
    const aspect = cast(float) width / height;
    auto screen = new Screen(width, height);
    auto renderer = new Renderer(screen);

    const vertices = [
        Vertex(Float4(-1, -1, 0, 1), Float2()),
        Vertex(Float4(-1, +1, 0, 1), Float2()),
        Vertex(Float4(+1, -1, 0, 1), Float2()),
        Vertex(Float4(+1, +1, 0, 1), Float2()),
    ];

    const projection = Mat4x4F.perspectiveFovLH(PI * 0.8, aspect, 0.1, 1000);
    const view = Mat4x4F.identity;

    foreach (i; 0 .. 100)
    {
        screen.clear();

        const world = Mat4x4F.rotateY(0.2 * i) * Mat4x4F.translate(0, 0, 5.0);
        renderer.transform = world * view * projection;
        renderer.renderPolygon(vertices);

        screen.render(stderr);
        Thread.sleep(50.msecs);
    }
}
