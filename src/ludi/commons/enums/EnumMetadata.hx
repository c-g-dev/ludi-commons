package ludi.commons.enums;

import haxe.EnumTools;
import haxe.Exception;
import haxe.EnumTools.EnumValueTools;
import haxe.rtti.Meta;

class EnumMetadata {
	var metas:Map<String, EnumMetadataValue> = [];

	public function new() {}

	public function getMetadata(tag:String):EnumMetadataValue {
		return metas[tag];
	}

    public function getSingleStringValue(tag:String):String {
		var v = getMetadata(tag);
        if(v == null){
            return null;
        }
        switch(v){
            case SINGLE(STRING(v)): {
                return v;
            }
            default: {
                throw new Exception("Single string value expected for metadata.");
            }
        }
	}

        
	public static function matchConstructorWhereMetadataEquals(enumType:Enum<Dynamic>, tag: String, expectedVal: String): String{
        var metas: Map<String, EnumMetadata> = getAllMetaFields(enumType);
        for(key => val in metas){
            var v = val.getSingleStringValue(tag);
            if(v == expectedVal){
                return key;
            }
        }
        return null;
    }
    
	public static function getAllMetaFields(enumType:Enum<Dynamic>):Map<String, EnumMetadata> {
        var result: Map<String, EnumMetadata> = [];
        var constructs: Array<String> = EnumTools.getConstructors(enumType);
        for(eachConstruct in constructs){
            result[eachConstruct] = getMetaFieldsFromName(eachConstruct, enumType);
        }
        return result;
    }

    public static function getMetaFieldsFromName(enumConstructName: String, enumType:Enum<Dynamic>):EnumMetadata {
        var result = new EnumMetadata();

		var metaObject = Meta.getFields(enumType);

		var fieldMap = Reflect.field(metaObject, enumConstructName);
		var availableMetadatas = Reflect.fields(fieldMap);

		for (eachMetadataEntry in availableMetadatas) {
            var enumVal: EnumMetadataValue;
            var f = Reflect.field(fieldMap, eachMetadataEntry);
            var fCast:Array<Dynamic> = cast f;
            if (fCast.length == 1) {
                var item = fCast[0];
                enumVal = SINGLE(valueType(item));
            } else if (fCast.length > 1) {
                enumVal = MULTIPLE([
                    for (fCastItem in fCast)
                        valueType(fCastItem)
                ]);
            }
            else{
                enumVal = NONE;
            }
            result.metas[eachMetadataEntry] = enumVal;
        }

		return result;
    }

	public static function getMetaFields(enumValue:EnumValue):EnumMetadata {
        var result = new EnumMetadata();

		var enumType = Type.getEnum(enumValue);
		var ename = EnumValueTools.getName(enumValue);

		return getMetaFieldsFromName(ename, enumType);
	}

	static function valueType(obj:Dynamic):EnumMetadataValueType {
		if (obj is String) {
			return STRING(obj);
		} else {
			return UNKNOWN(obj);
		}
	}
}

enum EnumMetadataValue {
	NONE;
	SINGLE(val:EnumMetadataValueType);
	MULTIPLE(vals:Array<EnumMetadataValueType>);
}

enum EnumMetadataValueType {
	STRING(val:String);
	UNKNOWN(val:Dynamic);
}
