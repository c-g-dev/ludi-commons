package ludi.commons.macro;

import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.Expr;


//usage: Functions.attach(element.onClick, (arg1, arg2, etc) -> {...});
//translates to: 
/*
    element.onClick = (args1, args2, etc) -> {
        element.onClick();
        newCallback();
    }
*/

class Functions {
    public static macro function attach(e: Expr, newCallback: Expr): Expr {
        return switch (e) {
            case macro $a.$b:
                var originalFunc = macro $a.$b;
                switch (newCallback) {
                    case macro ($params) -> $body:

                        var callOriginalFunc: Expr = macro $i{"originalFunc"}($i{params});

                        var result = macro {
                            var originalFunc = $a.$b;
                            $a.$b = function($params) {
                                $callOriginalFunc;
                                $body;
                            };
                        }
                        return result;

                    default:
                        Context.error("Expected a function expression as the second argument", newCallback.pos);
                        return null;
                };

            default:
                Context.error("Expected a field access expression as the first argument", e.pos);
                return null;
        }
    }

    public static macro function print(e: Expr): Expr {
        trace(ExprTools.toString(e));
        return e;
    }
}
