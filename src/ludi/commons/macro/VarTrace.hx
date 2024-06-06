package ludi.commons.macro;

import haxe.macro.Context;
import haxe.macro.Expr;

class VarTrace {
    public static macro function ampersands(e: Expr): Expr {
        return switch e {
            case macro $a && $b:
                var exprs = extractVars(e);
                macro trace(${createTraceString(exprs)});
            case _:
                throw Context.currentPos();
        }
    }
  
    #if macro
    private static function extractVars(expr: Expr): Array<Expr> {
        return switch expr {
            case macro $a && $b:
                extractVars(a).concat(extractVars(b));
            case _:
                [expr];
       }
    }

    private static function createTraceString(exprs: Array<Expr>): Expr {
        var content: Array<Expr> = [];
        for (eachExpr in exprs) {
            switch eachExpr.expr {
                case EConst(CIdent(name)): {
                    content.push(macro $v{"" + name + ":"} );
                    content.push(eachExpr);
                }
                default:
            }
        }
        return combineAsBinop(content);
    }

    private static function combineAsBinop(exprs: Array<Expr>): Expr {
        if (exprs.length == 0) return macro "";
        if (exprs.length == 1) return exprs[0];

        var result: Expr = exprs[0];
        for (i in 1...exprs.length) {
            result = macro $result + " " + ${exprs[i]};
        }
        return result;
    }
    #end
}

/*
    usage:

    VarTrace.ampersands(test1 && test2 && test3);

    becomes:

    trace("test1: " + test1 + " test2: " + test2 + " test3: " + test3);
*/