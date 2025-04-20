package ludi.commons.pattern;

class RepoState {
    private var repos: Map<String, Repo> = [];

    public function new() {}

    public function get<T: Repo>(source: Class<T>): T {
        var name = Type.getClassName(source);
        var castRepos: Map<String, T> = cast repos;
        if(!castRepos.exists(name)){
            var inst = Type.createInstance(source, [this]);
            castRepos[name] = inst;
            repos[name] = inst;
        }
        return castRepos[name];
    }
    
}