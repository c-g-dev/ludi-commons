package ludi.commons.pattern;

class Singleton<T> {

    private var generator: () -> T;
    private var didCreate: Bool = false;
    private var instance: T;

    public function new(generator: () -> T) {
        this.generator = generator;
    }

    public function get(): T {
        if(didCreate){
            return this.instance;
        }
        this.instance = generator();
        didCreate = true;
        return this.instance;
    }

}