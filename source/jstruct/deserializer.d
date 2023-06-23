module jstruct.deserializer;

import std.json;
import jstruct.exceptions : SerializationError;
import std.traits : FieldTypeTuple, FieldNameTuple, isArray;

/** 
 * Deserializes the provided JSON into a struct of type RecordType
 *
 * Params:
 *   jsonIn = the JSON to deserialize
 * Throws:
 *   RemoteFieldMissing = if the field names in the provided RecordType
 *   	      cannot be found within the prpvided JSONValue `jsonIn`.
 * Returns: an instance of RecordType
 */
public RecordType fromJSON(RecordType)(JSONValue jsonIn)
{
	RecordType record;

	// Alias as to only expand later when used in compile-time
	alias structTypes = FieldTypeTuple!(RecordType);
	alias structNames = FieldNameTuple!(RecordType);
	alias structValues = record.tupleof;

	static foreach(cnt; 0..structTypes.length)
	{
		debug(dbg)
		{
			pragma(msg, structTypes[cnt]);
			pragma(msg, structNames[cnt]);
			// pragma(msg, structValues[cnt]);
		}

		debug(dbg)
		{
			pragma(msg, "Bruh type");
			pragma(msg,  structTypes[cnt]);
			// pragma(msg, __traits(identifier, mixin(structTypes[cnt])));
		}

		try
		{
			static if(__traits(isSame, structTypes[cnt], byte))
			{
				mixin("record."~structNames[cnt]) = cast(byte)jsonIn[structNames[cnt]].integer();
			}
			else static if(__traits(isSame, structTypes[cnt], ubyte))
			{
				mixin("record."~structNames[cnt]) = cast(ubyte)jsonIn[structNames[cnt]].uinteger();
			}
			else static if(__traits(isSame, structTypes[cnt], short))
			{
				mixin("record."~structNames[cnt]) = cast(short)jsonIn[structNames[cnt]].integer();
			}
			else static if(__traits(isSame, structTypes[cnt], ushort))
			{
				mixin("record."~structNames[cnt]) = cast(ushort)jsonIn[structNames[cnt]].uinteger();
			}
			else static if(__traits(isSame, structTypes[cnt], int))
			{
				mixin("record."~structNames[cnt]) = cast(int)jsonIn[structNames[cnt]].integer();
			}
			else static if(__traits(isSame, structTypes[cnt], uint))
			{
				mixin("record."~structNames[cnt]) = cast(uint)jsonIn[structNames[cnt]].uinteger();
			}
			else static if(__traits(isSame, structTypes[cnt], ulong))
			{
				mixin("record."~structNames[cnt]) = cast(ulong)jsonIn[structNames[cnt]].uinteger();
			}
			else static if(__traits(isSame, structTypes[cnt], long))
			{
				mixin("record."~structNames[cnt]) = cast(long)jsonIn[structNames[cnt]].integer();
			}
			else static if(__traits(isSame, structTypes[cnt], string))
			{
				mixin("record."~structNames[cnt]) = jsonIn[structNames[cnt]].str();

				debug(dbg)
				{
					pragma(msg,"record."~structNames[cnt]);
				}
			}
			else static if(__traits(isSame, structTypes[cnt], JSONValue))
			{
				mixin("record."~structNames[cnt]) = jsonIn[structNames[cnt]];

				debug(dbg)
				{
					pragma(msg,"record."~structNames[cnt]);
				}
			}
			else static if(__traits(isSame, structTypes[cnt], bool))
			{
				mixin("record."~structNames[cnt]) = jsonIn[structNames[cnt]].boolean();

				debug(dbg)
				{
					pragma(msg,"record."~structNames[cnt]);
				}
			}
			//FIXME: Not sure how to get array support going, very new to meta programming
			// FIXME: Add component type checking
			else static if(isArray!(structTypes[cnt]))
			{
				import std.traits : ForeachType;
				import std.conv : to;

				alias recordArrayComponent = mixin("record."~structNames[cnt]);

				JSONValue[] jsonArray = jsonIn[structNames[cnt]].array();

				for(ulong i = 0; i < jsonArray.length; i++)
				{
					JSONValue jsonVal = jsonArray[i];

					static if(__traits(isSame, ForeachType!(structTypes[cnt]), byte))
					{
						mixin("record."~structNames[cnt])~= cast(byte)jsonVal.integer();
					}
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), ubyte))
					{
						mixin("record."~structNames[cnt])~= cast(ubyte)jsonVal.uinteger();
					}
					static if(__traits(isSame, ForeachType!(structTypes[cnt]), short))
					{
						mixin("record."~structNames[cnt])~= cast(short)jsonVal.integer();
					}
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), ushort))
					{
						mixin("record."~structNames[cnt])~= cast(ushort)jsonVal.uinteger();
					}
					static if(__traits(isSame, ForeachType!(structTypes[cnt]), int))
					{
						mixin("record."~structNames[cnt])~= cast(int)jsonVal.integer();
					}
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), uint))
					{
						mixin("record."~structNames[cnt])~= cast(uint)jsonVal.uinteger();
					}
					static if(__traits(isSame, ForeachType!(structTypes[cnt]), long))
					{
						mixin("record."~structNames[cnt])~= cast(long)jsonVal.integer();
					}
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), ulong))
					{
						mixin("record."~structNames[cnt])~= cast(ulong)jsonVal.uinteger();
					}
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), bool))
					{
						mixin("record."~structNames[cnt])~= jsonVal.boolean();
					}
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), float))
					{
						mixin("record."~structNames[cnt])~= cast(float)jsonVal.floating();
					}
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), double))
					{
						mixin("record."~structNames[cnt])~= cast(double)jsonVal.floating();
					}
					


				}


				// mixin("record."~structNames[cnt]) = jsonIn[structNames[cnt]].array();

				debug(dbg)
				{
					pragma(msg,"record."~structNames[cnt]);
				}
			}
			else
			{
				// throw new
				//TODO: Throw error
				debug(dbg)
				{
					pragma(msg, "Unknown type for de-serialization");
				}
			}
		}
		catch(JSONException e)
		{
			throw new SerializationError();
		}
	}

	return record;
}

unittest
{
	import std.string : cmp;
	import std.stdio : writeln;
	
	struct Person
	{
		public string firstname, lastname;
		public int age;
		public bool isMale;
		public JSONValue obj;
		public int[] list;
		public bool[] list2;
		public float[] list3;
		public double[] list4;
	}
	
	JSONValue json = parseJSON(`{
"firstname" : "Tristan",
"lastname": "Kildaire",
"age": 23,
"obj" : {"bruh":1},
"isMale": true,
"list": [1,2,3],
"list2": [true, false],
"list3": [1.5, 1.4],
"list4": [1.5, 1.4]
}
`);

	Person person = fromJSON!(Person)(json);

	debug(dbg)
	{
		writeln(person);	
	}

	assert(cmp(person.firstname, "Tristan") == 0);
	assert(cmp(person.lastname, "Kildaire") == 0);
	assert(person.age == 23);
	assert(person.isMale == true);
	assert(person.obj["bruh"].integer() == 1);
	assert(person.list == [1,2,3]);
	assert(person.list2 == [true, false]);
	assert(person.list3 == [1.5F, 1.4F]);
	assert(person.list4 == [1.5, 1.4]);
}

unittest
{
	import std.string : cmp;
	import std.stdio : writeln;
	
	struct Person
	{
		public string firstname, lastname;
		public int age;
		public bool isMale;
		public JSONValue obj;
		public int[] list;
	}
	
	JSONValue json = parseJSON(`{
"firstname" : "Tristan",
"lastname": "Kildaire",
"age": 23,
"obj" : {"bruh":1},
"list": [1,2,3]
}
`);

	try
	{
		Person person = fromJSON!(Person)(json);
		assert(false);
	}
	catch(SerializationError)
	{
		assert(true);
	}
	
}