package ludi.commons.extensions;

import ludi.commons.math.MathTools;

class Extensions_Enum {

	    public static function convert<T>(e: Enum<T>, v: EnumValue): T {
			trace("converting: " + v + "  " + v.getIndex() + "  " + v.getParameters());
			return e.createByIndex(v.getIndex(), v.getParameters());
		}

}