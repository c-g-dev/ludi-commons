package ludi.commons.enums;

abstract IntFlags<T:Int>(T) to T {
	public inline function new(value:T) {
		this = value;
	}

	@:from static function fromInt<T:Int>(e:T):IntFlags<T> {
		return new IntFlags<T>(cast(1 << e));
	}

	@:op(a | b) function or(a:T):IntFlags<T>;

	@:op(a & b) function and(a:T):IntFlags<T>;

	public inline function has(v:T):Bool {
		return (this & v) == v;
	}

	public inline function set(v:T):Void {
		this = cast this | v;
	}

	public inline function unset(v:T):Void {
		this = cast this & (0xFFFFFFFF - v);
	}
}
