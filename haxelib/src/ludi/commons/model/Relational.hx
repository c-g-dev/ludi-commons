package ludi.commons.model;

enum Relational {
    EQ;
    NOT_EQ;
    GT;
    LT;
    GT_EQ;
    LT_EQ;
}

class RelationalUtil {

    public static function evaluateInt(a: Int, r: Relational, b: Int): Bool {
        switch(r){
            case EQ: {
                return a == b;
            }
            case NOT_EQ: {
                return a != b;
            }
            case GT: {
                return a > b;
            }
            case LT: {
                return a < b;   
            }
            case GT_EQ: {
                return a >= b;
            }
            case LT_EQ: {
                return a <= b;
            }
            default:
        }
        return false;
    }

    public static function stringExpression(a: Int, r: Relational): String {
        switch(r){
            case EQ: {
                return "exactly " + a;
            }
            case NOT_EQ: {
                return "not " + a;
            }
            case GT: {
                return "more than " + a;
            }
            case LT: {
                return "less than " + a;   
            }
            case GT_EQ: {
                return "at least " + a;
            }
            case LT_EQ: {
                return "at most " + a;
            }
            default: {
                return "Unknown relational operator";
            }
        }
    }
}