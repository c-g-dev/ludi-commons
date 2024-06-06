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
}