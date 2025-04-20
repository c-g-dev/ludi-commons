package ludi.commons.math;

class MinIntFinder {
    private var min: Int = MathTools.INT_MAX;
	public function new() {}
    public function consume(i: Int): Void {
        if(i < min){
            min = i;
        }
    }
    public function getMin(): Int {
        return min;
    }
}