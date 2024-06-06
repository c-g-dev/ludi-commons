package ludi.commons.enums;

import haxe.EnumTools;

class EnumParser {
    var parserRules: Map<String, (Array<Dynamic>) -> Dynamic>;

    public function new(parserRules: Map<String, (Array<Dynamic>) -> Dynamic>) {
        this.parserRules = parserRules;
    }

    public function parseBlock(str: String): Array<EnumValue> {
        var enumValues = new Array<EnumValue>();
        var lines = str.split("\n");
        for (line in lines) {
            if (line == "") continue;
            enumValues.push(parse(line));
        }
        return enumValues;
    }
    
    public function parse(str: String): EnumValue {
        var splits = str.split(" ");
        var command = splits[0];
        var args = splits.slice(1, splits.length);
        var convertedArgs: Array<Dynamic> = [];
        for (arg in args) {
            var intArg = Std.parseInt(arg);
            convertedArgs.push(intArg != null ? intArg : arg);
        }
        
        return parserRules.get(command.toLowerCase())(convertedArgs);
    }
}

class EnumParserBuilder {

    static public function build<T>(clazz:Enum<T>): EnumParser {
        var paramInfo = enumNumberOfParamsPerConstructor(clazz);
        var args: Map<String, (Array<Dynamic>) -> Dynamic> = [];

        for (key => value in paramInfo) {
            var cb: (Array<Dynamic>) -> Dynamic = (args) -> {
                return Type.createEnum(clazz, key, args.slice(0, value));
            };
            args[key.toLowerCase()] = cb;
        }

        return new EnumParser(args);
    }

    static public function enumNumberOfParamsPerConstructor<T>(clazz:Enum<T>): Map<String, Int> {
		var result:Map<String, Int> = [];
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
			var params = EnumValueTools.getParameters(cast eachConstruct);
			result[EnumValueTools.getName(cast eachConstruct)] = params.length;
		}
		return result;
	}
}