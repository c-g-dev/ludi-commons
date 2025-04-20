package ludi.commons.tools;

abstract class GADTDatabase<T: EnumValue> {
    var entryLoaders: Array<() -> T> = [];
    var entries: Map<String, T> = [];
	var hasLoaded: Bool = false;


    abstract function getId(item: T): String;

    public function register(loader: () -> T): Void {
        entryLoaders.push(loader);
    }

    function load() {
        for (eachLoader in entryLoaders) {
            var item = eachLoader();
            entries[getId(item)] = item;    
        }
        hasLoaded = true;
    }

    public function get(id: String): T {
        if(!hasLoaded){
            load();
        }
        return entries[id];
    }

}