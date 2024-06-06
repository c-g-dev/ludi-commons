package ludi.commons.collections;


import ludi.commons.math.Vec2;
import ludi.commons.math.MaxIntFinder;

class GridDepthMap<T> {
	var data:Map<Int, Map<Int, Array<T>>> = [];
	var xMax = new MaxIntFinder();
	var yMax = new MaxIntFinder();

	public function new() {}

	public function all():Array<T> {
		var result = [];
		for (eachItemInData in data) {
			for (eachItemInEachItemInData in eachItemInData) {
				for (item in eachItemInEachItemInData) {
					result.push(item);
				}
			}
		}
		return result;
	}

	public function dimensions():Vec2 {
		return new Vec2(xMax.getMax(), yMax.getMax());
	}

	public function forEach(func:(x:Int, y:Int, item:T) -> Void):Void {
		for (x in 0...(xMax.getMax() + 1)) {
			for (y in 0...(yMax.getMax() + 1)) {
				var check = getAll(x, y);
				if (check.length > 0) {
					for (item in check) {
						func(x, y, item);
					}
				}
			}
		}
	}

	public function upsert(x:Int, y:Int, item:T):Void {
		removeItem(item);
		xMax.consume(x);
		yMax.consume(y);

		if (data[x] == null) {
			data[x] = new Map<Int, Array<T>>();
		}
		if (data[x][y] == null) {
			data[x][y] = [];
		}
		data[x][y].push(item);
	}

	public function removeItem(item:T):Void {
		for (eachItemInData in data) {
			for (eachItemInEachItemInData in eachItemInData) {
				for (i in 0...eachItemInEachItemInData.length) {
					if (eachItemInEachItemInData[i] == item) {
						eachItemInEachItemInData.splice(i, 1);
						return;
					}
				}
			}
		}
	}


	public function getAll(x:Int, y:Int):Array<T> {
		if (data[x] == null || data[x][y] == null) {
			return [];
		}
		return data[x][y];
	}
}