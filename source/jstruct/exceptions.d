/**
 * Exception types
 */
module jstruct.exceptions;

/** 
 * General exception type
 */
public abstract class JStructException : Exception
{
    this(string msg)
    {
        super("JStructException: "~msg);
    }
}

/** 
 * Error on serialization
 */
public final class SerializationError : JStructException
{
	this()
	{
		super("Error serializing");
	}
}

/** 
 * Error on deserialization
 */
public final class DeserializationError : JStructException
{
	this()
	{
		super("Error deserializing");
	}
}