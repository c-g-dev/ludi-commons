package ludi.commons.math;


class Vec2  {
	public var x:Float;
	public var y:Float;

	public function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function scale(scaler:Float):Vec2 {
		var copy = this.clone();
		copy.x *= scaler;
		copy.y *= scaler;
		return copy;
	}

	public function clone() {
		return new Vec2(this.x, this.y);
	}

	public function add(vec2:Vec2) {
		return new Vec2(this.x + vec2.x, this.y + vec2.y);
	}

	public function subtract(vec2:Vec2) {
		return new Vec2(this.x - vec2.x, this.y - vec2.y);
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

	public function distance(otherVec:Vec2):Float {
		return this.subtract(otherVec).magnitude();
	}

	public function equals(otherVec:Vec2):Bool {
		return (this.x == otherVec.x) && (this.y == otherVec.y);
	}

	public function toString():String {
		return "[x: " + x + ", y: " + y + "]";
	}

}
