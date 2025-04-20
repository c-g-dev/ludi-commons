package ludi.commons.math;

import ludi.commons.math.IVec2;

class IVec4 {
    public var x: Int;
    public var y: Int;
    public var z: Int;
    public var w: Int;

    public function new(x: Int, y: Int, z: Int, w: Int) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    public function add(other: IVec4): IVec4 {
        return new IVec4(this.x + other.x, this.y + other.y, this.z + other.z, this.w + other.w);
    }

    public function subtract(other: IVec4): IVec4 {
        return new IVec4(this.x - other.x, this.y - other.y, this.z - other.z, this.w - other.w);
    }

    public function multiply(scalar: Int): IVec4 {
        return new IVec4(this.x * scalar, this.y * scalar, this.z * scalar, this.w * scalar);
    }

    public function dot(other: IVec4): Int {
        return this.x * other.x + this.y * other.y + this.z * other.z + this.w * other.w;
    }

    public function equals(arg: IVec4): Bool {
        return this.x == arg.x && this.y == arg.y && this.z == arg.z && this.w == arg.w;
    }

    public function clone(): IVec4 {
        return new IVec4(x, y, z, w);
    }

    public function vec2(): IVec2 {
        return new IVec2(x, y);
    }
}