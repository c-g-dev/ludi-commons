# ludi-commons

Yet another Haxe utility lib that no one asked for. I'm just pushing this to haxelib so that it can be easily referenced by my other, more functional repos.

The content of this lib might have frequent breaking changes, so it isn't well suited for independent use. It is better used as reading material for those who are interested in Haxe.

The following classes are the most interesting:
 
### ludi.commons.collections
Lots of useful collections. Aside from the normal collections like `Queue`, `Set`, and `Stack`, `GridMap` is one of my most used classes in the lib. It is mostly just a wrapper for `Map<Int, Map<Int, T>>` (i.e., a map whose keys are `(x,y)`).

---

### ludi.commons.enums.EnumMetadata
Methods for accessing metadata on Enums easier.

---

### ludi.commons.enums.EnumParser
Builds a parser that converts string values into enum values.

---

### ludi.commons.tools.CliRunApi
Define a CLI program with an Enum.

---

### ludi.commons.tools.pattern.SyncPair
Holds two copies of the data, a "committed" version and a "dirty" version. You can commit the dirty version whenever necessary to sync them, and listen to callbacks based on this. Intended to be used as part of a GUI, where the committed version represents the actual state of the application, while you make changes to the dirty version before you bulk update.

---

### ludi.commons.tools.pattern.Mind
Holds a collection of singletons, which are getserted on access by class name. Sort of hard to describe but not really complicated at all. Look at the class and you will immediately understand what it does. I'm not sure what the "official" name for this kind of pattern would be, so I just named it "Mind" because each singleton is like a concept or something.

---