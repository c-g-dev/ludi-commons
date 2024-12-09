package ludi.commons.util;

class ReflectUtils {
    public static function update(a:Dynamic, b:Dynamic): Void {
        if (a != null && b != null) {
            for (key in Reflect.fields(b)) {
                if (Reflect.hasField(a, key)) {
                    Reflect.setField(a, key, Reflect.field(b, key));
                }
            }
        }
    }
    public static function upsert(a:Dynamic, b:Dynamic): Void {
        if(a != null && b != null) {
            for (key in Reflect.fields(b)) {
                Reflect.setField(a, key, Reflect.field(b, key));
            }
        }
    }

    public static function fieldsAsMap(a:Dynamic): Map<String, Dynamic> {
        var map = new Map<String, Dynamic>();
        if (a != null) {
            for (key in Reflect.fields(a)) {
                map.set(key, Reflect.field(a, key));
            }
        }
        return map;
    }

    public static function mapToObject(arg:Map<String, Dynamic>): Dynamic {
        var obj = {};
        for (key in arg.keys()) {
            Reflect.setField(obj, key, arg.get(key));
        }
        return obj;
    }

    public static function remove(obj:Dynamic, field:String):Dynamic {
        if (Reflect.hasField(obj, field)) {
            Reflect.deleteField(obj, field);
        }
        return obj;
    }
}