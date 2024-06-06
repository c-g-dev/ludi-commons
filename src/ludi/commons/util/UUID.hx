package ludi.commons.util;

import uuid.Uuid;

class UUID {

    public static function generate(): String{
        return Uuid.nanoId();
    }
}