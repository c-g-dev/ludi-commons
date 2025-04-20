package ludi.commons.enums;

import haxe.EnumTools;



@:genericBuild(ludi.commons.macro.EnumKeysBuildMacro.build())
class EnumKeys<T> {}

class EnumKeysUtil {
    public static function has<T: EnumValue>(arr: Array<T>, enumConstructor: EnumValue): Bool{
        var keyName = enumConstructor.getName();
        for (t in arr) {
            if(t.getName() == keyName){
                return true;
            }
        }
        return false;
    }
    public static function params<T: EnumValue>(arr: Array<T>, enumConstructor: EnumValue): Array<Dynamic>{
        var keyName = enumConstructor.getName();
        for (t in arr) {
            if(t.getName() == keyName){
                return Type.enumParameters(t);
            }
        }
        return [];
    }
    public static function check<T: EnumValue>(arr: Array<T>, enumConstructor: EnumValue, cb: Array<Dynamic> -> Void): Void{
        var keyName = enumConstructor.getName();
        for (t in arr) {
            if(t.getName() == keyName){
                cb(Type.enumParameters(t));
            }
        }
    }
}