package ludi.commons.util;

class JsonAccess {
    public static function toStringMap(jsob: Dynamic): Map<String, String> {
        var result = new Map<String, String>();

        for (field in Reflect.fields(jsob)) {
            var value = Reflect.field(jsob, field);
            result.set(field, Std.string(value));
        }

        return result;
    }
}