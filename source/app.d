import std.complex : Complex;
import std.stdio : stderr;
import orbium.screen : Screen;

void main()
{
    auto screen = new Screen(256, 256);

    foreach (y; 0 .. screen.height)
    {
        foreach (x; 0 .. screen.width)
        {
            const u = (cast(float) x / screen.width - 0.5) * 4;
            const v = (cast(float) y / screen.height - 0.5) * 4;
            const c = Complex!float(u, v);

            Complex!float z = 0;
            foreach (_; 0 .. 10)
            {
                z = z * z + c;
            }

            if (z.re * z.re + z.im * z.im > 2)
            {
                screen.setPixel(x, y, 1);
            }
        }
    }

    screen.render(stderr);
}
