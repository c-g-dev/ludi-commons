package ludi.commons;

typedef MapCheck<T> = {
    public function exists(key:T):Bool;
    public function get(key:T):Null<Dynamic>;
    public function set(key:T, value:Dynamic): Void;
}

class Nulls {
    public static function getOrDefault<T>(v: T, def: T) : T {
        if(v == null){
            return def;
        }
        return v;
    }

    public static function mapGetDefault<K,V,T:MapCheck<K>>(v: T, key: K, def: V) : V {
        if(v == null){
            return def;
        }
        if(!v.exists(key) || (v.get(key) == null)){
            v.set(key, def);
            return def;
        }
        return v.get(key);
    }
}