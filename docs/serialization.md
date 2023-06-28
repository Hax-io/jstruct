Serialization
=============

Below we define a struct called `Person`:

```d
struct Person
{
    public string firstname, lastname;
    public int age;
    public string[] list;
    public JSONValue extraJSON;
    public EnumType eType;
}
```

Our enum is defined as:

```d
enum EnumType
{
	DOG,
	CAT
}
```

Let's create a instance and set some values before we continue:

```d
Person p1;
p1.firstname  = "Tristan";
p1.lastname = "Kildaire";
p1.age = 23;
p1.list = ["1", "2", "3"];
p1.extraJSON = parseJSON(`{"item":1, "items":[1,2,3]}`);
p1.eType = EnumType.CAT;
```

Now, we make a call to `serializeRecord` as follows:

```d
JSONValue serialized = serializeRecord(p1);
```

This returns the following JSON:

```json
{
    "age": 23,
    "eType": "CAT",
    "extraJSON": {
        "item": 1,
        "items": [
            1,
            2,
            3
        ]
    },
    "firstname": "Tristan",
    "lastname": "Kildaire",
    "list": [
        "1",
        "2",
        "3"
    ]
}
```