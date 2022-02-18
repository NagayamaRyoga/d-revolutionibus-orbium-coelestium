module orbium.util.ctor;

///
template defaultCtor()
{
    this(typeof(this.tupleof) args)
    {
        this.tupleof = args;
    }
}
