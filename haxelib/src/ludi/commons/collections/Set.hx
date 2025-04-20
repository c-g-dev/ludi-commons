package ludi.commons.collections;

class Set<T> {
	public var _data = new Array<T>();

	public function new() {}

	public function push(newVal:T) {
		if (!exists(newVal)) {
			_data.push(newVal);
		}
	}

	public function exists(newVal:T):Bool {
		for (eachData in _data) {
			if (equals(newVal, eachData)) {
				return true;
			}
		}
		return false;
	}

    public function addAll(arrVals: Array<T>) {
        for(eachItemInArrVals in arrVals){
            push(eachItemInArrVals);
        }
    }

	public dynamic function equals(t1: T, t2: T): Bool {
		return t1 == t2;
	}
}
