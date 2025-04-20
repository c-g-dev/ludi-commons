package ludi.commons.collections;

import ludi.commons.math.IVec4;
import ludi.commons.math.MaxIntFinder;

class I4Map<T> {
	var data:Map<Int, Map<Int, Map<Int, Map<Int, T>>>> = [];
	var xMax = new MaxIntFinder();
	var yMax = new MaxIntFinder();
	var zMax = new MaxIntFinder();
	var wMax = new MaxIntFinder();

	public function new() {}

	public function all():Array<T> {
		var result = [];
		for (eachItemInData in data) {
			for (eachItemInEachItemInData in eachItemInData) {
				for (eachItemInEachItemInEachItemInData in eachItemInEachItemInData) {
					for (eachItem in eachItemInEachItemInEachItemInData) {
						if(eachItem != null){
							result.push(eachItem);
						}
					}
				}
			}
		}
		return result;
	}

	public function change(x1:Int, y1:Int, z1:Int, w1:Int, x2:Int, y2:Int, z2:Int, w2:Int, item:T):Void {
		add(x1, y1, z1, w1, null);
		add(x2, y2, z2, w2, item);
	}

	public function forEach(func:(x:Int, y:Int, z:Int, w:Int, item:T) -> Void):Void {
		for (x in 0...(xMax.getMax() + 1)) {
			for (y in 0...(yMax.getMax() + 1)) {
				for (z in 0...(zMax.getMax() + 1)) {
					for (w in 0...(wMax.getMax() + 1)) {
						var check = get(x, y, z, w);
						if (check != null) {
							func(x, y, z, w, check);
						}
					}
				}
			}
		}
	}

	public function add(x:Int, y:Int, z:Int, w:Int, item:T):Void {
		xMax.consume(x);
		yMax.consume(y);
		zMax.consume(z);
		wMax.consume(w);

		if (data[x] == null) {
			data[x] = new Map<Int, Map<Int, Map<Int, T>>>();
		}
		if (data[x][y] == null) {
			data[x][y] = new Map<Int, Map<Int, T>>();
		}
		if (data[x][y][z] == null) {
			data[x][y][z] = new Map<Int, T>();
		}
		data[x][y][z][w] = item;
	}

	public function remove(x:Int, y:Int, z:Int, w:Int) {
		if (data[x] != null && data[x][y] != null && data[x][y][z] != null) {
			data[x][y][z][w] = null;
		}
	}

	public function has(x:Int, y:Int, z:Int, w:Int) {
		if (data[x] == null || data[x][y] == null || data[x][y][z] == null || data[x][y][z][w] == null) {
			return false;
		}
		return true;
	}

	public function get(x:Int, y:Int, z:Int, w:Int):T {
		if (data[x] == null) {
			data[x] = new Map<Int, Map<Int, Map<Int, T>>>();
		}
		if (data[x][y] == null) {
			data[x][y] = new Map<Int, Map<Int, T>>();
		}
		if (data[x][y][z] == null) {
			data[x][y][z] = new Map<Int, T>();
		}
		return data[x][y][z][w];
	}

	public function serialize():String {
		var flatData:Array<{
			x:Int,
			y:Int,
			z:Int,
			w:Int,
			item:T
		}> = [];
		forEach((x, y, z, w, item) -> flatData.push({
			x: x,
			y: y,
			z: z,
			w: w,
			item: item
		}));
		return haxe.Json.stringify({
			data: flatData,
			xMax: xMax.getMax(),
			yMax: yMax.getMax(),
			zMax: zMax.getMax(),
			wMax: wMax.getMax()
		});
	}

	public static function deserialize<T>(json:String):I4Map<T> {
		var obj = haxe.Json.parse(json);
		var grid = new I4Map<T>();
		grid.xMax = new MaxIntFinder();
		grid.xMax.consume(obj.xMax);
		grid.yMax = new MaxIntFinder();
		grid.yMax.consume(obj.yMax);
		grid.zMax = new MaxIntFinder();
		grid.zMax.consume(obj.zMax);
		grid.wMax = new MaxIntFinder();
		grid.wMax.consume(obj.wMax);
		for (item in (cast obj.data : Array<{
			x:Int,
			y:Int,
			z:Int,
			w:Int,
			item:T
		}>)) {
			grid.add(item.x, item.y, item.z, item.w, item.item);
		}
		return grid;
	}

	public function clone():I4Map<T> {
		var newMap = new I4Map<T>();
		newMap.xMax = new MaxIntFinder();
		newMap.yMax = new MaxIntFinder();
		newMap.zMax = new MaxIntFinder();
		newMap.wMax = new MaxIntFinder();

		forEach((x, y, z, w, item) -> {
			newMap.add(x, y, z, w, item);
		});

		newMap.xMax.consume(xMax.getMax());
		newMap.yMax.consume(yMax.getMax());
		newMap.zMax.consume(zMax.getMax());
		newMap.wMax.consume(wMax.getMax());

		return newMap;
	}

	public function clear() {
		data = [];
		xMax = new MaxIntFinder();
		yMax = new MaxIntFinder();
		zMax = new MaxIntFinder();
		wMax = new MaxIntFinder();
	}
}
