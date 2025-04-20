package ludi.commons.math;

class MathTools {
	public static inline var INT_MIN:Int = -2147483648;
	public static inline var INT_MAX:Int = 2147483647;

    public static function minAllInt(values: Array<Int>, ?def: Int = INT_MAX): Int {
        if (values.length == 0) return def;
        var minValue = values[0];
        for (i in values) {
            if (i < minValue) {
                minValue = i;
            }
        }
        return minValue;
    }

    public static function maxAllInt(values: Array<Int>, ?def: Int = INT_MIN): Int {
        if (values.length == 0) return def;
        var maxValue = values[0];
        for (i in values) {
            if (i > maxValue) {
                maxValue = i;
            }
        }
        return maxValue;
    }

    public static function cartesianProductExclusive(x: Int, y: Int): Array<IVec2> {
        var result = new Array<IVec2>();
    
        for (i in 0...x) {
            for (j in 0...y) {
                result.push(new IVec2(i, j));
            }
        }
    
        return result;
    }

    function cartesian(vals: Array<Array<Dynamic>>): Array<Array<Dynamic>> {
        if (vals.length == 0)
            return [[]];
        else {
            var result: Array<Array<Dynamic>> = [];
            var allCasesFromRest = cartesian(vals.slice(1));
            for (i in 0...vals[0].length)
                for (j in 0...allCasesFromRest.length) {
                    var singleList = allCasesFromRest[j].copy();
                    singleList.insert(0, vals[0][i]);
                    result.push(singleList);
                }
            return result;
        }
    }
    
}



