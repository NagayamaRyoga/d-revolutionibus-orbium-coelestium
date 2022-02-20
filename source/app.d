import std.complex : Complex;
import std.stdio : stderr;
import orbium.graphics.renderer : Renderer;
import orbium.screen : Screen;
import orbium.vec : Float2, Float3;
import orbium.vertex : Vertex;

void main()
{
    auto screen = new Screen(256, 256);
    auto renderer = new Renderer(screen);

    const Vertex[] vertices = [
        Vertex(Float3(+0.0, -0.7, 0), Float2()),
        Vertex(Float3(-0.9, +0.7, 0), Float2()),
        Vertex(Float3(+0.5, +0.5, 0), Float2()),
    ];

    renderer.renderTriangle(vertices[0], vertices[1], vertices[2]);

    screen.render(stderr);
}
