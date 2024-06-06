package ludi.commons.util;


import haxe.Constraints.IMap;
import haxe.ds.Option;

class Options {
    public static inline function of<T>(item: T): Option<T> {
        if(item != null){
            return Some(item);
        }
        return None;
    }

    public static inline function tryArray<T, K: Array<T>>(item: K, idx: Int): Option<T> {
        if (idx >= 0 && idx < item.length) {
            return Some(item[idx]);
        }
        return None;
    }

    public static function get<T>(arg:Option<T>): T {
        switch arg {
            case Some(v): return v;
            case None: return null;
        }
    }

    public static function mapReduceExisting<K, V>(args:MapCircumvention): Map<K, V> {
        var result = args.fork();
        var kvs = args.toKeyValuePairs();
        for (eachPair in kvs) {
            var castedVal: Option<V> = cast eachPair.value;
            switch castedVal {
                case Some(v): {
                    result.add(eachPair.key, v);
                }
                case None:
            }
        }
        return cast result.toMap();

    }
    
}