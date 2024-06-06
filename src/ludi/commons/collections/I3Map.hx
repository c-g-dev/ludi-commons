package ludi.commons.collections;

import ludi.commons.math.IVec3;
import ludi.commons.math.MaxIntFinder;

class I3Map<T> {
	var data:Map<Int, Map<Int, Map<Int, T>>> = [];
	var xMax = new MaxIntFinder();
	var yMax = new MaxIntFinder();
	var zMax = new MaxIntFinder();

	public function new() {}

	public function all():Array<T> {
		var result = [];
		for (eachItemInData in data) {
			for (eachItemInEachItemInData in eachItemInData) {
				for (eachItemInEachItemInEachItemInData in eachItemInEachItemInData) {
					if(eachItemInEachItemInEachItemInData != null){
						result.push(eachItemInEachItemInEachItemInData);
					}
				}
			}
		}
		return result;
	}

	public function change(x1:Int, y1:Int, z1:Int, x2:Int, y2:Int, z2:Int, item:T):Void {
		add(x1, y1, z1, null);
		add(x2, y2, z2, item);
	}
	public function forEach(func:(x:Int, y:Int, z:Int, item:T) -> Void):Void {
		for (x in 0...(xMax.getMax() + 1)) {
			for (y in 0...(yMax.getMax() + 1)) {
				for (z in 0...(zMax.getMax() + 1)) {
					var check = get(x, y, z);
					if (check != null) {
						func(x, y, z, check);
					}
				}
			}
		}
	}

	public function add(x:Int, y:Int, z:Int, item:T):Void {
		xMax.consume(x);
		yMax.consume(y);
		zMax.consume(z);

		if (data[x] == null) {
			data[x] = new Map<Int, Map<Int, T>>();
		}
		if (data[x][y] == null) {
			data[x][y] = new Map<Int, T>();
		}
		data[x][y][z] = item;
	}

	public function remove(x:Int, y:Int, z:Int) {
		if (data[x] != null && data[x][y] != null) {
			data[x][y][z] = null;
		}
	}

	public function has(x:Int, y:Int, z:Int) {
		if (data[x] == null || data[x][y] == null || data[x][y][z] == null) {
			return false;
		}
		return true;
	}

	public function get(x:Int, y:Int, z:Int):T {
		if (data[x] == null) {
			data[x] = new Map<Int, Map<Int, T>>();
		}
		if (data[x][y] == null) {
			data[x][y] = new Map<Int, T>();
		}
		return data[x][y][z];
	}

	public function serialize():String {
		var flatData:Array<{
			x:Int,
			y:Int,
			z:Int,
			item:T
		}> = [];
		forEach((x, y, z, item) -> flatData.push({
			x: x,
			y: y,
			z: z,
			item: item
		}));
		return haxe.Json.stringify({
			data: flatData,
			xMax: xMax.getMax(),
			yMax: yMax.getMax(),
			zMax: zMax.getMax()
		});
	}

	public static function deserialize<T>(json:String):I3Map<T> {
		var obj = haxe.Json.parse(json);
		var grid = new I3Map<T>();
		grid.xMax = new MaxIntFinder();
		grid.xMax.consume(obj.xMax);
		grid.yMax = new MaxIntFinder();
		grid.yMax.consume(obj.yMax);
		grid.zMax = new MaxIntFinder();
		grid.zMax.consume(obj.zMax);
		for (item in (cast obj.data : Array<{
			x:Int,
			y:Int,
			z:Int,
			item:T
		}>)) {
			grid.add(item.x, item.y, item.z, item.item);
		}
		return grid;
	}

	public function clone():I3Map<T> {
		var newMap = new I3Map<T>();
		newMap.xMax = new MaxIntFinder();
		newMap.yMax = new MaxIntFinder();
		newMap.zMax = new MaxIntFinder();

		forEach((x, y, z, item) -> {
			newMap.add(x, y, z, item);
		});

		newMap.xMax.consume(xMax.getMax());
		newMap.yMax.consume(yMax.getMax());
		newMap.zMax.consume(zMax.getMax());

		return newMap;
	}

	public function clear() {
		data = [];
		xMax = new MaxIntFinder();
		yMax = new MaxIntFinder();
		zMax = new MaxIntFinder();
	}
}
