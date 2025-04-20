package ludi.commons.logging;

class Log {

    public static function error(str: String){
        trace("\033[31m" + str + "\033[0m");
    }

    public static function resetToken(): String {
        return "\033[0m";
    }

    public static function success(str: String){
        trace("\033[32m" + str + "\033[0m");
    }
}