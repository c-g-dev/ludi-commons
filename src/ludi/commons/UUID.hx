package ludi.commons;

import uuid.Uuid;

class UUID {

    static var init: Bool = false;

    public static function generate(): String{
        if(!init){
            @:privateAccess Uuid.rndSeed = haxe.Int64.fromFloat(#if js js.lib.Date.now() #elseif sys Sys.time()*1000 #else Date.now().getTime() #end);
            @:privateAccess Uuid.state0 = Uuid.splitmix64_seed(Uuid.rndSeed);
            @:privateAccess Uuid.state1 = Uuid.splitmix64_seed(Uuid.rndSeed + Std.random(10000) + 1);
            init = true;
        }
        return Uuid.nanoId();
    }
}