package ludi.commons.tools;

import ludi.commons.enums.EnumMetadata;
import haxe.EnumTools;

class CliRunApi {
	public function new() {}

	public function parseCLICall<T>(clazz:Enum<T>):T {
		var args = Sys.args();
		var tag = args[0];
		var c = EnumMetadata.matchConstructorWhereMetadataEquals(cast clazz, "tag", tag);
		
		if(c == null){
			for(eachConstructor in clazz.getConstructors()){
				if(eachConstructor.toLowerCase() == tag.toLowerCase()){
					c = eachConstructor;
				}
			}
		}
		var allConstructs: Array<T> = clazz.getConstructors().map((eachConstructor) -> {
			var attempt = 0;
			while(true){
				try{
					var ev = EnumTools.createByName(clazz, eachConstructor, [for(i in 0...attempt) null]);
					return ev;
				}
				catch(e){
					attempt++;
				}
			}
			return null;
		});
		for (eachConstruct in allConstructs) {
			if (EnumValueTools.getName(cast eachConstruct) == c) {
				var params = EnumValueTools.getParameters(cast eachConstruct);
				var newParams:Array<Dynamic> = [];
				for (i in 0...params.length) {
					newParams.push(args[i + 1]);
				}
				return EnumTools.createByName(cast clazz, c, newParams);
			}
		}
		return null;
	}
}