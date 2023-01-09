jstruct
=======

#### _Struct JSON serializer/deserializer_

----

## API

For full API documentation see [DUB API Spec](https://jstruct.dpldocs.info/index.html).

## Installing

In order to use jstruct in your project simply run:

```bash
dub add jstruct
```

And then in your D program import as follows:

```d
import jstruct;
```

## Help wanted

There are some outstanding issues I want to be able to fix/have implemented, namely:

- [ ] Support for array serialization/deserialization - see issue #1
- [ ] Support for custom types serialization/deserialization (think `enums` for example) - see issue #2