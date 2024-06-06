package ludi.commons.extensions;

class Extensions_Math {

    public static function sign(math: Class<Math>, val: Float): Int {
       if(val < 0) {
        return -1;
       }
       if(val > 0) {
        return 1;
       }
       return 0;
    }

}