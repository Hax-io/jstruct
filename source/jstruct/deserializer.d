/** 
 * Deserialization utilities
 */
module jstruct.deserializer;

import std.json;
import jstruct.exceptions : DeserializationError;
import std.traits : FieldTypeTuple, FieldNameTuple, isArray, ForeachType, EnumMembers, fullyQualifiedName;;
import std.conv : to;

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
			else static if(isArray!(structTypes[cnt]))
			{
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
					else static if(__traits(isSame, ForeachType!(structTypes[cnt]), string))
					{
						mixin("record."~structNames[cnt])~= jsonVal.str();
					}
					


				}


				// mixin("record."~structNames[cnt]) = jsonIn[structNames[cnt]].array();

				debug(dbg)
				{
					pragma(msg,"record."~structNames[cnt]);
				}
			}
			else static if(is(structTypes[cnt] == enum))
			{
				string enumChoice = jsonIn[structNames[cnt]].str();

				alias members = EnumMembers!(structTypes[cnt]);

				version(dbg)
				{
					import std.stdio : writeln;
				}
				
				static foreach(member; members)
				{
					version(dbg)
					{
						writeln(member);
						writeln(fullyQualifiedName!(member));
						writeln(__traits(identifier, member));
					}
					
					if(__traits(identifier, member) == enumChoice)
					{
						mixin("record."~structNames[cnt]) = member;
					}
				}
			}
			else
			{
				// throw new
				//TODO: Throw error
				debug(dbg)
				{
					pragma(msg, "Unknown type for de-serialization");

					pragma(msg, is(structTypes[cnt] == enum));


				}
			}
		}
		catch(JSONException e)
		{
			throw new DeserializationError();
		}
	}

	return record;
}

/**
 * Example deserialization of JSON
 * to our `Person` struct
 */
unittest
{
	enum EnumType
	{
		DOG,
		CAT
	}
	
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
		public string[] list5;
		public EnumType animal;
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
"list4": [1.5, 1.4],
"list5": ["baba", "booey"],
"animal": "CAT"
}
`);

	Person person = fromJSON!(Person)(json);

	debug(dbg)
	{
		writeln("Deserialized as: ", person);	
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
	assert(person.list5 == ["baba", "booey"]);
	assert(person.animal == EnumType.CAT);

}

version(unittest)
{
	import std.string : cmp;
	import std.stdio : writeln;
}

/**
 * Another example deserialization of JSON
 * to our `Person` struct but here there
 * is a problem with deserialization as
 * there is a missing field `isMale`
 * in the provided JSON
 */
unittest
{
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
	catch(DeserializationError)
	{
		assert(true);
	}
	
}


unittest
{
	enum EnumType
	{
		DOG,
		CAT
	}

	struct Person
	{
		public string firstname, lastname;

		
		public EnumType animal;
		
	}
	
	JSONValue json = parseJSON(`{
"firstname" : "Tristan",
"lastname": "Kildaire",
"animal" : "CAT"
}
`);

	try
	{
		Person person = fromJSON!(Person)(json);
		writeln(person);
		assert(true);
	}
	catch(DeserializationError)
	{
		assert(false);
	}
	
}