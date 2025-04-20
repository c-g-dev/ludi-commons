package ludi.commons.extensions;

import ludi.commons.math.MathTools;

class Extensions_Math {

    public static function sign(math: Class<Math>, val: Float): Int {
       if(val < 0) {
        return -1;
       }
       if(val > 0) {
        return 1;
       }
       return 0;
    }

    public static function maxAll(math: Class<Math>, vals: Array<Int>): Int {
        var max = MathTools.INT_MIN;
        for (value in vals) {
            max = Std.int(Math.max(max, value));
        }
        return max;
    }

    public static function sum(arr: Array<Int>): Int {
        var val = 0;
        for (i in arr) {
            val += i;
        }
        return val;
    }

    public static function minInt(math: Class<Math>, a:Int, b:Int):Int {
        return a < b || Math.isNaN(a) ? a : b;
    }
		

    public static function maxInt(math: Class<Math>, a: Int, b: Int): Int {
        return a > b ? a : b;
    }

    public static function bound(math: Class<Math>, v: Int, min: Int, max: Int): Int {
        if(v < min){
            return min;
        }
        if(v > max){
            return max;
        }
        return v;
    }

    public static function boundFloat(math: Class<Math>, v: Float, min: Float, max: Float): Float {
        if(v < min){
            return min;
        }
        if(v > max){
            return max;
        }
        return v;
    }


}