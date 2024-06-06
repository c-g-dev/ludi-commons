package ludi.commons.math;

class IVec3 {
    public var x: Int;
    public var y: Int;
    public var z: Int;

    public function new(x: Int, y: Int, z: Int) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function add(other: IVec3): IVec3 {
        return new IVec3(this.x + other.x, this.y + other.y, this.z + other.z);
    }

    public function subtract(other: IVec3): IVec3 {
        return new IVec3(this.x - other.x, this.y - other.y, this.z - other.z);
    }

    public function multiply(scalar: Int): IVec3 {
        return new IVec3(this.x * scalar, this.y * scalar, this.z * scalar);
    }

    public function dot(other: IVec3): Int {
        return this.x * other.x + this.y * other.y + this.z * other.z;
    }

    public function cross(other: IVec3): IVec3 {
        return new IVec3(
            this.y * other.z - this.z * other.y,
            this.z * other.x - this.x * other.z,
            this.x * other.y - this.y * other.x
        );
    }

    public function equals(arg:IVec3) {
        return this.x == arg.x && this.y == arg.y && this.z == arg.z;
    }

    public function clone():IVec3 {
        return new IVec3(x, y, z);
    }
}