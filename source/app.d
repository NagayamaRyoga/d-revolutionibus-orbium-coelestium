import std.stdio : stderr;
import orbium.screen : Screen;

void main()
{
    auto screen = new Screen(256, 256);

    foreach (y; 0 .. screen.height)
    {
        foreach (x; 0 .. screen.width)
        {
            screen.setPixel(x, y, x * y % 256 < 128);
        }
    }

    screen.render(stderr);
}
