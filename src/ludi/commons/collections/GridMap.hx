package ludi.commons.collections;

import haxe.Json;
import ludi.commons.math.IVec2;
import ludi.commons.math.MaxIntFinder;

class GridMap<T> {
	var data:Map<Int, Map<Int, T>> = [];
	var xMax = new MaxIntFinder();
	var yMax = new MaxIntFinder();

	public function new() {}

	public function all():Array<T> {
		var result = [];
		for (eachItemInData in data) {
			for (eachItemInEachItemInData in eachItemInData) {
				if(eachItemInEachItemInData != null){
					result.push(eachItemInEachItemInData);
				}
			}
		}
		return result;
	}

	public function change(x1:Int, y1:Int, x2:Int, y2:Int, item:T):Void {
		add(x1, y1, null);
		add(x2, y2, item);
	}

	public function dimensions():IVec2 {
		return new IVec2(xMax.getMax(), yMax.getMax());
	}

	public function forEach(func:(x:Int, y:Int, item:T) -> Void):Void {
		for (x in 0...(xMax.getMax() + 1)) {
			for (y in 0...(yMax.getMax() + 1)) {
				var check = get(x, y);
				if (check != null) {
					func(x, y, check);
				}
			}
		}
	}

	public function add(x:Int, y:Int, item:T):Void {
		xMax.consume(x);
		yMax.consume(y);

		if (data[x] == null) {
			data[x] = new Map<Int, T>();
		}
		data[x][y] = item;
	}

	public function remove(x:Int, y:Int) {
		if (data[x] != null) {
			data[x][y] = null;
		}
	}

	public function has(x:Int, y:Int) {
		if (data[x] == null) {
			return false;
		}
		if (data[x][y] == null) {
			return false;
		}
		return true;
	}

	public function get(x:Int, y:Int):T {
		if (data[x] == null) {
			data[x] = new Map<Int, T>();
		}
		return data[x][y];
	}

	public function serialize():String {
		var flatData:Array<{x:Int, y:Int, item:T}> = [];
		forEach((x, y, item) -> flatData.push({x: x, y: y, item: item}));
		return haxe.Json.stringify({
			data: flatData,
			xMax: xMax.getMax(),
			yMax: yMax.getMax()
		});
	}

	public static function deserialize<T>(json:String):GridMap<T> {
		var obj = haxe.Json.parse(json);
		var grid = new GridMap<T>();
		grid.xMax = new MaxIntFinder();
		grid.xMax.consume(obj.xMax);
		grid.yMax = new MaxIntFinder();
		grid.yMax.consume(obj.yMax);

		for (item in (cast obj.data : Array<{x:Int, y:Int, item:T}>)) {
			grid.add(item.x, item.y, item.item);
		}
		return grid;
	}

	public function clone():GridMap<T> {
		var newGridMap = new GridMap<T>();
		for (x in data.keys()) {
			for (y in data[x].keys()) {
				newGridMap.add(x, y, data[x][y]);
			}
		}
		return newGridMap;
	}

	public function outerJoin(arg:GridMap<T>):Void {
		arg.forEach((x, y, item) -> {
			if (!this.has(x, y)) {
				this.add(x, y, item);
			}
		});
	}

	public function truncateTo(xMaxLimit:Int, yMaxLimit:Int):Void {
		var positionsToRemove = [];
		forEach((x, y, item) -> {
			if (x >= xMaxLimit || y >= yMaxLimit) {
				positionsToRemove.push({x: x, y: y});
			}
		});

		for (pos in positionsToRemove) {
			remove(pos.x, pos.y);
		}

		var newXMax = new MaxIntFinder();
		var newYMax = new MaxIntFinder();
		forEach((x, y, item) -> {
			newXMax.consume(x);
			newYMax.consume(y);
		});

		this.xMax = newXMax;
		this.yMax = newYMax;
	}
}
