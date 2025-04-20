package ludi.commons.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;

class ChoiceMacro {
    static var cachedTypes: Map<String, ComplexType> = [];
    
	static public function build() {
		#if macro
		switch (Context.getLocalType()) {
			case TInst(_, [TInst(_.get() => {kind: KExpr(macro $v{(s : String)})}, _)]):
				if(cachedTypes.exists(s)) {
					return cachedTypes.get(s);
				} else {
					cachedTypes.set(s, createEnum("Choice__" + (s.replace(",", "_")), s.split(",")));
				}
				return cachedTypes.get(s);
			case t:
				return null;
		}
		#end
		return null;
	}

	#if macro
	static function makeEnumField(name, kind):Field {
		return {
			name: name,
			doc: null,
			meta: null,
			access: [],
			kind: kind,
			pos: Context.currentPos()
		}
	}

	static function createEnum(enumName:String, values:Array<String>) {
		Context.defineType({
			doc: null,
			meta: null,
			pos: Context.currentPos(),
			kind: TDEnum,
			fields: [
				for (eachValue in values) {
					makeEnumField(eachValue, FVar(null, null));
				}
			],
			name: enumName,
			params: [],
			pack: [],
		});

		return TPath({
			pack: [],
			name: enumName,
			params: null
		});
	}
	#end
}
