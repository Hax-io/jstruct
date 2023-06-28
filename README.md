![](branding/logo.png)

jstruct
=======

#### _Struct JSON serializer/deserializer_

----

[![D](https://github.com/Hax-io/jstruct/actions/workflows/d.yml/badge.svg)](https://github.com/Hax-io/jstruct/actions/workflows/d.yml) ![DUB](https://img.shields.io/dub/v/jstruct?color=%23c10000ff%20&style=flat-square) ![DUB](https://img.shields.io/dub/dt/jstruct?style=flat-square) ![DUB](https://img.shields.io/dub/l/jstruct?style=flat-square)

## Usage

### Serialization

Below we define a struct called `Person`:

```d
struct Person
{
    public string firstname, lastname;
    public int age;
    public string[] list;
    public JSONValue extraJSON;
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
```

Now, we make a call to `serializeRecord` as follows:

```d
JSONValue serialized = serializeRecord(p1);
```

This returns the following JSON:

```json
{
    "age": 23,
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
    "list": ["1", "2", "3"]
}
```

### Deserialization

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

## Installing

In order to use jstruct in your project simply run:

```bash
dub add jstruct
```

And then in your D program import as follows:

```d
import jstruct;
```
