package ludi.commons.math;

class MaxIntFinder {
    private var max: Int = MathTools.INT_MIN;
	public function new() {}
    public function consume(i: Int): Void {
        if(i > max){
            max = i;
        }
    }
    public function getMax(): Int {
        return max;
    }
}