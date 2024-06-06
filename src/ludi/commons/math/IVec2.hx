package ludi.commons.math;

import haxe.Json;

class IVec2 {
	public var x:Int;
	public var y:Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}

	public function scale(scaler:Float):Vec2 {
		var copy = new Vec2(x, y);
		copy.x *= scaler;
		copy.y *= scaler;
		return copy;
	}

	public function clone() {
		return new IVec2(this.x, this.y);
	}

	public function add(vec2:IVec2) {
		return new IVec2(this.x + vec2.x, this.y + vec2.y);
	}

	public function subtract(vec2:IVec2) {
		return new IVec2(this.x - vec2.x, this.y - vec2.y);
	}

	public function magnitude():Float {
		return Math.sqrt((this.x * this.x) + (this.y * this.y));
	}

	public function normalize():Vec2 {
		if (this.magnitude() != 0) {
			return this.scale(1 / this.magnitude());
		} else {
			return new Vec2(0, 0);
		}
	}

	public function distance(otherVec:IVec2):Float {
		return this.subtract(otherVec).magnitude();
	}

	public function intDistance(otherVec:IVec2): Int {
		return Std.int(Math.abs((this.x - otherVec.x))) + Std.int(Math.abs((this.y - otherVec.y)));
	}

	public function equals(otherVec:IVec2):Bool {
		return (this.x == otherVec.x) && (this.y == otherVec.y);
	}

	public function toString():String {
		return Json.stringify(this);
	}

	public static function fromString(str: String):IVec2 {
		var v = Json.parse(str);
		return new IVec2(v.x, v.y);
	}

}
