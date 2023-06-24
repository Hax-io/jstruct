Deserialization
===============

Deserialization works by having your predefined struct type and then looking up those field names in the provided JSON. Therefore for this we will be using the following struct type:

```d
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
```

Now, let's say we were given the following JSON:

```json
{
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
```

We can then deserialize the JSON to our type `Person`, with the `fromJSON` method:

```d
// Define our JSON
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

// Deserialize
Person person = fromJSON!(Person)(json);
```

And we can confirm this with:

```d
writeln(person):
```

Which will output:

```
Person("Tristan", "Kildaire", 23, true, {"bruh":1}, [1, 2, 3], [true, false], [1.5, 1.4], [1.5, 1.4])
```