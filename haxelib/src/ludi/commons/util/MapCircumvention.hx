package ludi.commons.util;

class MapCircumvention {
    var mkt: MapKeyType;
    var stringMap: Map<String, Dynamic>;

    private function new(mkt: MapKeyType) {
        this.mkt = mkt;
    }

    public static function stringKey<V>(m: Map<String, V>): MapCircumvention {
        var r = new MapCircumvention(String);
        r.stringMap = m;
        return r;
    }

    public function add(key: Dynamic, value: Dynamic) {
        switch mkt {
            case String: {
                stringMap[key] = value;
            }
        }
    }

    public function toKeyValuePairs(): Array<{key: Dynamic, value: Dynamic}> {
        var result: Array<{key: Dynamic, value: Dynamic}> = [];
        switch mkt {
            case String: {
                for (key => value in stringMap) {
                    result.push({key: key, value: value});
                }
            }
        }
        return result;
    }

    public function toMap(): Dynamic {
        switch mkt {
            case String: {
                return stringMap;
            }
        }
    }

    public function fork(): MapCircumvention {
        switch mkt {
            case String: {
                return MapCircumvention.stringKey([]);
            }
        }
    }
}

enum MapKeyType {
    String;
    //todo
}