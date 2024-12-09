package ludi.commons.util;

class JsonAccess {
    public static var serializers = {
        Int2IntMap: new Int2IntSerializer()
    }

    public static function toStringMap(jsob: Dynamic): Map<String, String> {
        var result = new Map<String, String>();

        for (field in Reflect.fields(jsob)) {
            var value = Reflect.field(jsob, field);
            result.set(field, Std.string(value));
        }

        return result;
    }

    public static function asArray(jsob: Dynamic): Array<Dynamic> {
        return cast jsob;
    }
}

abstract class JsonAccessSerializer<T> {
   public abstract function serialize(obj: T): String;
   public abstract function deserialize(json: String): T;
}

class Int2IntSerializer extends JsonAccessSerializer<Map<Int, Int>> {
    public function new() {}

    public function serialize(obj: Map<Int, Int>): String {
        var parts: Array<String> = [];
        for (key in obj.keys()) {
            var value = obj.get(key);
            parts.push('"${key}":${value}');
        }
        return '{' + parts.join(',') + '}';
    }

    public function deserialize(str: String): Map<Int, Int> {
        var map = new Map<Int, Int>();
        var entries = str.substr(1, str.length - 2).split(',');

        for (entry in entries) {
            var parts = entry.split(':');
            var key = Std.parseInt(parts[0].substr(1, parts[0].length - 2));
            var value = Std.parseInt(parts[1]);
            map.set(key, value);
        }

        return map;
    }
}