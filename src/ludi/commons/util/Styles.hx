package ludi.commons.util;


class Styles {
    public static function upsert(a:Dynamic, b:Dynamic): Void {
        if(a != null && b != null) {
            for (key in Reflect.fields(b)) {
                Reflect.setField(a, key, Reflect.field(b, key));
            }
        }
    }
}
