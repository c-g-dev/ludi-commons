package ludi.commons.collections;

@:arrayAccess
@:forward
abstract VectorGrid<T>(Array<T>) to Array<T> from Array<T>{


	public function new(a:Array<T>) {
		this = a;
	}

	public function fillBlanks(width: Int, height: Int, value: T):Void {
		for (y in 0...height) {
			for (x in 0...width) {
				if(this[(y * width) + x] == null){
					this[(y * width) + x] = value;
				}
			}
		}
	}

	public function get(x:Int, y:Int, stride: Int):T {
		return this[(y * stride) + x];
	}

	public function set(x:Int, y:Int, stride: Int, v:T) {
		if(x < stride) {
			this[(y * stride) + x] = v;
		}
	}

	public function xyIterate(stride: Int, callback: (x:Int, y:Int, item: T) -> Void):Void {
		var y = 0;
		var x = 0;
		for(eachItem in this){
			callback(x, y, eachItem);
			x++;
			if(x >= stride){
				x = 0;
				y++;
			}
		}
	}
}
