module jstruct.exceptions;

public abstract class JStructException : Exception
{
    this(string msg)
    {
        super("JStructException: "~msg);
    }
}

public final class SerializationError : JStructException
{
	this()
	{
		super("Errro serializing");
	}
}