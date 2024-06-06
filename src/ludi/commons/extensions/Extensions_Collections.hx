package ludi.commons.extensions;

import ludi.commons.model.GUID;
import haxe.Json;

class Extensions_Collections {

    static public function toKeyValueArray<K, V>(map: Map<K, V>): Array<{key: K, value: V}> {
        var arr = new Array<{key: K, value: V}>();
        for (key in map.keys()) {
            arr.push({key: key, value: map.get(key)});
        }
        return arr;
    }

    public static function cartesianProduct<T>(array1:Array<T>, array2:Array<T>):Array<{a: T, b: T}> {
        var result:Array<{a: T, b: T}> = [];
        for (elem1 in array1) {
            for (elem2 in array2) {
                result.push({a: elem1, b: elem2});
            }
        }
        return result;
    }

    public static function firstOrNull<T>(arr:Array<T>): T {
        if(arr.length > 0) {
            return arr[0];
        } else {
            return null;
        }
    }

    public static function findByUUID<T: {uuid: GUID}>(arr: Array<T>, uuid: GUID): T {
        for (eachArr in arr) {
            if(eachArr.uuid == uuid){
                return eachArr;
            }
        }
        return null;
    }
    public static function getsert<T>(map: Map<String, T>, key: String, def: T): T {
        if(map.exists(key)){
            return map.get(key);
        }
        map.set(key, def);
        return def;
    }

    public static function upsert<T>(arr: Array<T>, filter: (T) -> Bool, defaultItem: T): Void {
        for (i in 0...arr.length) {
            if (filter(arr[i])) {
                arr[i] = defaultItem;
            }
        }
        arr.push(defaultItem);
    }

    static public function jsonified<T>(arr: Array<T>): Array<String> {
        return arr.map((eachItem) -> {
            return Json.stringify(eachItem);
        });
    }

    static public function surgery<T>(arr: Array<T>, idxes: Array<Int>) {
        var result: Array<T> = [];

        for(i in idxes){
            result.push(arr[i]);
        }

        return result;
    }

    static public function range<T>(arr: Array<T>, idxStart: Int, idxEnd: Int) {
        var result: Array<T> = [];

        for(i in idxStart...(idxEnd + 1)){
            result.push(arr[i]);
        }

        return result;
    }

    static public function find<T>(arr: Array<T>, filter: (T) -> Bool): T {
        var items = arr.filter(filter);
        if(items.length > 0){
            return items[0];
        }
        return null;
    }

    static public function reduce<T>(arr: Array<T>, callback: (T, T) -> T, initialValue: T) : T {
        var accumulator: T = initialValue;
        for (item in arr) {
            accumulator = callback(accumulator, item);
        }
        return accumulator;
    }
	
	static public function all<T>(arr: Array<T>, filter: (T) -> Bool): Bool {
        for(eachItemInArr in arr){
            if(!filter(eachItemInArr)){
                return false;
            }
        }
        return true;
    }

    static public function some<T>(arr: Array<T>, filter: (T) -> Bool): Bool {
        for(eachItemInArr in arr){
            if(filter(eachItemInArr)){
                return true;
            }
        }
        return false;
    }

    static public function every<T>(arr: Array<T>, filter: (T) -> Bool): Bool {
        for(eachItemInArr in arr){
            if(!filter(eachItemInArr)){
                return false;
            }
        }
        return true;
    }

    
    static public function take<T>(arr: Array<T>, amount: Int): Array<T> {
        var result = [];
        for (i in 0...arr.length) {
          if(i < amount)
            result.push(arr[i]);
          else
            break;
        }
        return result;
      }


    static public function maxInt<T>(arr: Array<T>, compute: (T) -> Int): T {
        var currentMaxValue = Math.NEGATIVE_INFINITY;
        var currentMaxItem = null;
        for(eachItem in arr){
            var val = compute(eachItem);
            if(val > currentMaxValue){
                currentMaxValue = val;
                currentMaxItem = eachItem;
            }
        }
        return currentMaxItem;
    }

    static public function pushAll<T>(arr: Array<T>, toAdd: Array<T>): Array<T> {
        for(eachItem in toAdd){
            arr.push(eachItem);
        }
        return arr;
    }

    static public function random<T>(arr: Array<T>) {
        return arr[Math.floor(Math.random() * arr.length)];
    }

    public static function subtract<T>(arr1:Array<T>, arr2:Array<T>):Array<T> {
        var result = new Array<T>();
    
        for (item in arr1) {
            if (!arr2.contains(item)) {
                result.push(item);
            }
        }
    
        return result;
    }

    static public function removeWhere<T>(arr: Array<T>, func: (T) -> Bool) {
        var itemsToRemove = [];
        for(eachItemInArr in arr){
            if(func(eachItemInArr)){
                itemsToRemove.push(eachItemInArr);
            }
        }
        for(eachItemInItemsToRemove in itemsToRemove){
            arr.remove(eachItemInItemsToRemove);
        }
    }

}