package ludi.commons.collections;

import ludi.commons.math.IVec2;
import ludi.commons.math.MaxIntFinder;

class ReversibleGridMap<T, K: String> {
	var vecToDataMap: Map<Int, Map<Int, T>> = [];
	var dataToVecMap: Map<K, IVec2> = [];
	
	var xMax = new MaxIntFinder();
	var yMax = new MaxIntFinder();
	
	var data2Key: (T) -> K;

	public function new(data2Key: (T) -> K) {
		this.data2Key = data2Key;
	}


	public function set(x:Int, y:Int, item:T):Void {
		xMax.consume(x);
		yMax.consume(y);

		if (vecToDataMap[x] == null) {
			vecToDataMap[x] = new Map<Int, T>();
		}
		vecToDataMap[x][y] = item;
		
		dataToVecMap[data2Key(item)] = new IVec2(x, y);
	}

	public function getData(x:Int, y:Int):T {
		if (vecToDataMap[x] == null) {
			vecToDataMap[x] = new Map<Int, T>();
		}
		return vecToDataMap[x][y];
	}
	
	public function getVec(data: T): IVec2 {
		return dataToVecMap[data2Key(data)];
	}
}
