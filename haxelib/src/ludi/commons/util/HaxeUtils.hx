package ludi.commons.util;

class HaxeUtils {

    public static function promote<K, T: K>(inst: K, clazz: Class<T>): T {
        var fields = Type.getInstanceFields(Type.getClass(inst));
        var newInstance = Type.createInstance(clazz, []);
        for(eachFieldStr in fields){
            var originalField = Reflect.field(inst, eachFieldStr);
            var promotedField = Reflect.field(newInstance, eachFieldStr);
            var originalFieldClass = Type.getClass(originalField);
            var promotedFieldClass = Type.getClass(promotedField);
            var isSubclass = Std.isOfType(promotedField, originalFieldClass);
            var isExactClass = exactClassEquality(promotedFieldClass, originalFieldClass);
            if(isSubclass && !isExactClass){
                Reflect.setField(newInstance, eachFieldStr, promote(originalField, promotedFieldClass));
            }
            else if(isExactClass){
                Reflect.setField(newInstance, eachFieldStr, originalField);
            }
        }
        return newInstance;
    }

    public static inline function exactClassEquality<K, T>(clazzA: Class<K>, clazzB: Class<T>): Bool {
        return Type.getClassName(clazzA) == Type.getClassName(clazzB);
    }

    public static function list2Array<T>(l: List<T>): Array<T> {
        var result = [];
        for(eachItemInL in l){
            result.push(eachItemInL);
        }
        return result;
    }

    public static function getClassName(obj: Dynamic): String {
        var t = Type.getClassName(Type.getClass(obj));
        return t.substr(t.lastIndexOf(".") + 1, t.length);
    }
 }