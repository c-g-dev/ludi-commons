package ludi.commons;

abstract TypeCode(String) to String from String {
    public function new(value: Dynamic) {
        switch Type.typeof(value) {
            case TObject: {
                if (Std.isOfType(value, String)) {
                    this = value; 
                } 
                else if (Std.isOfType(value, Class)) {
                    this = Type.getClassName(value);
                } else {
                    this = Type.getClassName(Type.getClass(value));
                }
            }
            case TClass(c): {
                if(Std.isOfType(value, String)) {
                    this = value;
                }
                else {
                    this = Type.getClassName(c);
                }
            }
            default: {
                this = null;
            }
        }
    }

    public function equals(other: TypeCode): Bool {
        return this.toString() == (cast other: String).toString();
    }

    public static function of(value: Dynamic): TypeCode {
        return new TypeCode(value);
    }

    public static macro function here(): haxe.macro.Expr.ExprOf<TypeCode> {
        var classType = haxe.macro.Context.getLocalClass().get();
        var className = classType.pack.length > 0 
            ? classType.pack.join('.') + '.' + classType.name 
            : classType.name;
        return macro new TypeCode($v{className});
    }
}

interface RequiresTypeCode {
    public var typecode: TypeCode;
}

@:autoBuild(ludi.commons.macro.InjectTypeCodeMacro.build())
interface InjectTypeCode {}