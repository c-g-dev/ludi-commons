package ludi.commons.collections;

class MutableArrayImpl<T> {
	var data = new Array<T>();
	var currentIdx = 0;

	public function new() {}
}

abstract MutableArray<T>(MutableArrayImpl<T>) {
	public function new() {
		this = new MutableArrayImpl<T>();
	}

	public function inlineRemove(item:T):Void {
		@:privateAccess for (i in 0...this.data.length) {
			@:privateAccess if (this.data[i] == item) {
				@:privateAccess this.data.splice(i, 1);
				if (i <= this.currentIdx) {
					@:privateAccess this.currentIdx--;
				}
				break;
			}
		}
	}

	@:from
	static public function fromArray<T>(s:Array<T>) {
		var ab = new MutableArray<T>();
		@:privateAccess ab.setData(s);
		return ab;
	}

	@:to
	public function toArray():Array<T> {
		@:privateAccess return this.data;
	}

	public function hasNext():Bool {
        @:privateAccess if(this.data.length <= this.currentIdx){
            this.currentIdx = 0;
            return false;
        }
        return true;
	}

	public function next():T {
		@:privateAccess this.currentIdx++;
		@:privateAccess return this.data[this.currentIdx - 1];
	}

	function setData(items:Array<T>) {
		@:privateAccess this.data = items;
	}

    public function length(): Int {
		@:privateAccess return this.data.length;
	}

	public function push(item:T) {
		@:privateAccess this.data.push(item);
	}

	public function toString():String {
		@:privateAccess return this.data.toString();
	}

	@:arrayAccess
	public inline function get(key:Int) {
		@:privateAccess return this.data[key];
	}

	@:arrayAccess
	public inline function arrayWrite(k:Int, v:T):T {
		@:privateAccess this.data[k] = v;
		return v;
	}
}