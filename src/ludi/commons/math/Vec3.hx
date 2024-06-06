package ludi.commons.math;

class Vec3 {
    public var x: Float;
    public var y: Float;
    public var z: Float;

    public function new(x: Float, y: Float, z: Float) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function add(other: Vec3): Vec3 {
        return new Vec3(this.x + other.x, this.y + other.y, this.z + other.z);
    }

    public function subtract(other: Vec3): Vec3 {
        return new Vec3(this.x - other.x, this.y - other.y, this.z - other.z);
    }

    public function multiply(scalar: Float): Vec3 {
        return new Vec3(this.x * scalar, this.y * scalar, this.z * scalar);
    }

    public function divide(scalar: Float): Vec3 {
        return new Vec3(this.x / scalar, this.y / scalar, this.z / scalar);
    }

    public function dot(other: Vec3): Float {
        return this.x * other.x + this.y * other.y + this.z * other.z;
    }

    public function cross(other: Vec3): Vec3 {
        return new Vec3(
            this.y * other.z - this.z * other.y,
            this.z * other.x - this.x * other.z,
            this.x * other.y - this.y * other.x
        );
    }
}