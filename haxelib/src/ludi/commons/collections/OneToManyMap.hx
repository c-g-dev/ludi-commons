package ludi.commons.collections;

@:forward
@:forward.new
abstract OneToManyMap<K, V>(Map<K, Array<V>>)  {

    public inline function push(key: K, value: V) {
        if(!this.exists(key)){
            this[key] = new Array<V>();
        }
        this[key].push(value);
    }

    @:arrayAccess
    public inline function get(key:K){
        return this.get(key);
    }
		
}