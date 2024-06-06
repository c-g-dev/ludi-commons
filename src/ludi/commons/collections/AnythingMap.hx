package ludi.commons.collections;

class AnythingMap<K, V> {
	var left:Array<K> = [];
	var right:Array<V> = [];

	public function new() {}

	public function set(k:K, v:V) {
        left.push(k);
        right.push(v);
    }

    public function remove(k:K) {
        var idx = left.indexOf(k);
        right.remove(right[idx]);
        left.remove(left[idx]);
    }

	public function getLeft(k:K):V {
        var idx = left.indexOf(k);
        return right[idx];
    }

	public function getRight(v:V):K {
        var idx = right.indexOf(v);
        return left[idx];
    }
}
