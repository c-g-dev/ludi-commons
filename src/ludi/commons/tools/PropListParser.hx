package ludi.commons.tools;

class PropListParser {
    public static function parse(s: String): Map<String, String> {
        var map:Map<String, String> = new Map<String, String>();
        var lines = s.split("\n");
        for (line in lines) {
            var parts = line.split("=");
            if (parts.length == 2) {
                map.set(parts[0], parts[1]);
            }
        }
        return map;
    }
}