# ludi-commons

Yet another Haxe utility lib that no one asked for. I'm just pushing this to haxelib so that it can be easily referenced by my other, more functional repos.

The content of this lib might have frequent breaking changes, so it isn't well suited for independent use. It is better used as reading material for those who are interested in Haxe.

There are lots of utilities in this repo, but here are the ones I find myself using the most:
 
### ludi.commons.collections.GridMap
2D array wrapper

---

### ludi.commons.UUID
"-lib uuid" wrapper

---

### ludi.commons.TypeCode
Macro utilities for keeping a reference for the type of an object. For non-class types I don't know of any other unified way to consistently get the name of the type. For classes you could use Type.getClassName(Type.getClass(obj)) but this caches that result to prevent unnecessary Reflection calls. Also check the "InjectTypeCode" interface which @:autobuild runs a macro to inject the typecode automatically.

---

### ludi.commons.messaging.Topic
Basic pub/sub utility.

---

### ludi.commons.pattern.UndoRedoManager
Generic manager class for the "command" design pattern.

---