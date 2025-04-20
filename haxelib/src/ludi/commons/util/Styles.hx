package ludi.commons.util;

import haxe.EnumTools;


class Styles {

    public static function upsert(a:Dynamic, b:Dynamic): Dynamic {
        if(a != null && b != null) {
            for (key in Reflect.fields(b)) {
                Reflect.setField(a, key, Reflect.field(b, key));
            }
        }
        return a;
    }
    public static function cloning(a:Dynamic, cb: (KeyValuePair) -> KeyValuePair): Dynamic {
        if(a == null) {
            return null;
        }
        var b:Dynamic = {};
        for (key in Reflect.fields(a)) {
            var kvp = cb({key:key, value: Reflect.field(a, key)});
            Reflect.setField(b, kvp.key, kvp.value);
        }
        return b;
    }

    public static function check<T: EnumValue>(opts: Array<T>, allVals: Enum<T>): Array<CheckStyle<T>> {
        var result: Array<CheckStyle<T>> = [];
        opts = (opts == null) ? [] : opts;
        var enumeration: Array<String> = EnumTools.getConstructors(allVals);
        var optNames: Array<String> = [for (opt in opts) Type.enumConstructor(opt)];

        var includedOpts: Array<T> = [];
        for (element in enumeration) {
            if (optNames.contains(element)) {
                for (eachOpt in opts) {
                    if(Type.enumConstructor(eachOpt) == element){
                        if(!includedOpts.contains(eachOpt)){
                            result.push(CheckStyle.With(eachOpt));
                            includedOpts.push(eachOpt);
                        }
                    }
                }
            } else {
                result.push(CheckStyle.Without(element));
            }
        }

        return result;
    }
}

enum CheckStyle<T> {
    With(t: T);
    Without(enumName: String);
}

typedef KeyValuePair = {key: String, value: Dynamic};