package ludi.commons.enums;

import haxe.EnumTools;

class EnumUtils {
    
    public static function shiftAndCycle<T: EnumValue>(kind: Enum<T>, i: T, amt: Int): T {
        var newIdx = (EnumValueTools.getIndex(i) + amt) % EnumTools.getConstructors(kind).length;
        return EnumTools.createByIndex(kind, newIdx, []);
    }
}