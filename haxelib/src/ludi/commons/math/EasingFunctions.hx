package ludi.commons.math;

//you can check here: https://easings.net/

class EasingFunctions {
    public static function easeInSine(t:Float):Float {
        return 1 - Math.cos((t * Math.PI) / 2);
    }

    public static function easeOutSine(t:Float):Float {
        return Math.sin((t * Math.PI) / 2);
    }

    public static function easeInOutSine(t:Float):Float {
        return -(Math.cos(Math.PI * t) - 1) / 2;
    }

    public static function easeInQuad(t:Float):Float {
        return t * t;
    }

    public static function easeOutQuad(t:Float):Float {
        return t * (2 - t);
    }

    public static function easeInOutQuad(t:Float):Float {
        return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
    }

    public static function easeInCubic(t:Float):Float {
        return t * t * t;
    }

    public static function easeOutCubic(t:Float):Float {
        return (--t) * t * t + 1;
    }

    public static function easeInOutCubic(t:Float):Float {
        return t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1;
    }

    public static function easeInQuart(t:Float):Float {
        return t * t * t * t;
    }

    public static function easeOutQuart(t:Float):Float {
        return 1 - (--t) * t * t * t;
    }

    public static function easeInOutQuart(t:Float):Float {
        return t < 0.5 ? 8 * t * t * t * t : 1 - 8 * (--t) * t * t * t;
    }

    public static function easeInQuint(t:Float):Float {
        return t * t * t * t * t;
    }

    public static function easeOutQuint(t:Float):Float {
        return 1 + (--t) * t * t * t * t;
    }

    public static function easeInOutQuint(t:Float):Float {
        return t < 0.5 ? 16 * t * t * t * t * t : 1 + 16 * (--t) * t * t * t * t;
    }

    public static function easeInExpo(t:Float):Float {
        return t == 0 ? 0 : Math.pow(2, 10 * (t - 1));
    }

    public static function easeOutExpo(t:Float):Float {
        return t == 1 ? 1 : 1 - Math.pow(2, -10 * t);
    }

    public static function easeInOutExpo(t:Float):Float {
        if (t == 0) return 0;
        if (t == 1) return 1;
        if ((t /= 0.5) < 1) return 0.5 * Math.pow(2, 10 * (t - 1));
        return 0.5 * (-Math.pow(2, -10 * --t) + 2);
    }

    public static function easeInCirc(t:Float):Float {
        return 1 - Math.sqrt(1 - t * t);
    }

    public static function easeOutCirc(t:Float):Float {
        return Math.sqrt(1 - (--t) * t);
    }

    public static function easeInOutCirc(t:Float):Float {
        if ((t /= 0.5) < 1) return -0.5 * (Math.sqrt(1 - t * t) - 1);
        return 0.5 * (Math.sqrt(1 - (t -= 2) * t) + 1);
    }

    static inline var S:Float = 1.70158; // overshoot amount for back easings
    static inline var elasticAmplitude:Float = 1;
    static inline var elasticPeriod:Float = 0.3;

    public static function easeInBack(t:Float):Float {
        return t * t * ((S + 1) * t - S);
    }

    public static function easeOutBack(t:Float):Float {
        return (t = t - 1) * t * ((S + 1) * t + S) + 1;
    }

    public static function easeInOutBack(t:Float):Float {
        var s = S * 1.525;
        if ((t *= 2) < 1) {
            return 0.5 * (t * t * ((s + 1) * t - s));
        }
        return 0.5 * ((t -= 2) * t * ((s + 1) * t + s) + 2);
    }

    public static function easeInElastic(t:Float):Float {
        if (t == 0 || t == 1) return t;
        var p = elasticPeriod / 4;
        var s = p / (2 * Math.PI) * Math.asin(1 / elasticAmplitude);
        return -(elasticAmplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin((t - s) * (2 * Math.PI) / p));
    }

    public static function easeOutElastic(t:Float):Float {
        if (t == 0 || t == 1) return t;
        var p = elasticPeriod / 4;
        var s = p / (2 * Math.PI) * Math.asin(1 / elasticAmplitude);
        return elasticAmplitude * Math.pow(2, -10 * t) * Math.sin((t - s) * (2 * Math.PI) / p) + 1;
    }

    public static function easeInOutElastic(t:Float):Float {
        if ((t *= 2) == 0 || t == 2) return t * 0.5;
        var p = elasticPeriod * (0.3 * 1.5);
        var s = p / (2 * Math.PI) * Math.asin(1 / elasticAmplitude);
        if (t < 1) {
            return -0.5 * (elasticAmplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin((t - s) * (2 * Math.PI) / p));
        }
        return elasticAmplitude * Math.pow(2, -10 * (t -= 1)) * Math.sin((t - s) * (2 * Math.PI) / p) * 0.5 + 1;
    }

    public static function easeInBounce(t:Float):Float {
        return 1 - easeOutBounce(1 - t);
    }

    public static function easeOutBounce(t:Float):Float {
        if (t < (1 / 2.75)) {
            return 7.5625 * t * t;
        } else if (t < (2 / 2.75)) {
            return 7.5625 * (t -= (1.5 / 2.75)) * t + 0.75;
        } else if (t < (2.5 / 2.75)) {
            return 7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375;
        } else {
            return 7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375;
        }
    }

    public static function easeInOutBounce(t:Float):Float {
        if (t < 0.5) {
            return easeInBounce(t * 2) * 0.5;
        }
        return easeOutBounce(t * 2 - 1) * 0.5 + 0.5;
    }
}