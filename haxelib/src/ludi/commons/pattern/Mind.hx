package ludi.commons.pattern;

class Mind<T> {
    private var repos: Map<String, T> = [];

    public function new() {}

    public function get<K: T>(source: Class<K>): K {
        var name = Type.getClassName(source);
        var castRepos: Map<String, T> = cast repos;
        if(!castRepos.exists(name)){
            var inst = Type.createInstance(source, []);
            castRepos[name] = inst;
            repos[name] = inst;
        }
        return cast castRepos[name];
    }

    public function set(item: T){
        var name = Type.getClassName(Type.getClass(item));
        repos[name] = item;
    }
}
