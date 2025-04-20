package ludi.commons.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

#if macro
class EnumKeysBuildMacro {

    public static var typeDefs: Array<String> = [];

    public static function build(): ComplexType{
        var type = Context.getLocalType();
        var name: String = "";
        var generatedConstructors:Array<Field> = [];
        switch type {
            case null:
            case TInst(t, params): {
                switch params[0] {
                    case TEnum(t, params): {
                        name = t.get().name;
                        for (key => value in t.get().constructs) {
                            generatedConstructors.push(makeEnumField(key, FVar(null, null)));
                        }
                    }
                    default:
                }
            }
            default:
        }
        return addType(name + "_keys", ["ludi", "commons", "macro"], generatedConstructors);
    }

    static function addType(name: String, pack: Array<String>, fields: Array<Field>): ComplexType {
        var typePath = pack.join(".") + "." + name;
        if(!typeDefs.contains(typePath)){
            var td =  {
                name: name,
                params: null,
                pack: pack,
                fields: fields,
                doc: null,
                meta: null,
                access: [],
                kind: TDEnum,
                pos: Context.currentPos()
            };
            typeDefs.push(typePath);
            Context.defineType(td);
        }
        return TPath({
            name: name,
            pack: pack,
            params: null,
            sub: null
        });
    }

    static function makeEnumField(name, kind): Field {
        return {
            name: name,
            doc: null,
            meta: [],
            access: [],
            kind: kind,
            pos: Context.currentPos()
          }
    }
}
#end