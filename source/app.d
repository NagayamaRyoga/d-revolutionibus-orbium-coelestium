import core.thread : Thread;
import std.complex : Complex;
import std.datetime : msecs;
import std.math : PI;
import std.stdio : stderr;
import orbium.graphics.renderer : Renderer;
import orbium.image : Image;
import orbium.image.dman : dmanPixels;
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

    auto image = new Image(256, 256, dmanPixels);

    const vertices = [
        Vertex(Float4(-1, -1, 0, 1), Float2(1, 1)),
        Vertex(Float4(-1, +1, 0, 1), Float2(1, 0)),
        Vertex(Float4(+1, -1, 0, 1), Float2(0, 1)),
        Vertex(Float4(+1, +1, 0, 1), Float2(0, 0)),
    ];

    const projection = Mat4x4F.perspectiveFovLH(PI * 0.8, aspect, 0.1, 1000);
    const view = Mat4x4F.identity;

    renderer.texture = image;

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
