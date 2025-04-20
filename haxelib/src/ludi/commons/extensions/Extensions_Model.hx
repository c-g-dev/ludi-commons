package ludi.commons.extensions;

import ludi.commons.math.MathTools;

class Extensions_Model {


    public static function invert(dir: ludi.commons.model.Direction): ludi.commons.model.Direction {
        switch dir {
            case Up: return Down;
            case Right: return Left;
            case Down: return Up;
            case Left: return Right;
        }
    }


}