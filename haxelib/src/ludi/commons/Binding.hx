package ludi.commons;

//fyi if you wanted this to be auto generated as a macro:
    // init macro -> addGlobalMetadata to assign build macro for ALL types to check for binding metadata
    
abstract Binding<T>({data: T, bindings: Array<T-> Void>}) {

    public function new(a:T) {
        this = {data: a, bindings: []};
    }

    @:from
    static public function fromT<T>(v: T) {
      return new Binding(v);
    }

    @:to
    public function toT(): T {
      return this.data;
    }

    public function setData(a:T) {
        this.data = a;
    }

    public function getData(): T {
        return this.data;
    }
    
    
    public function bind(b: T-> Void) {
        this.bindings.push(b);
    }

    public function fire() {
        for (b in this.bindings) {
            b(this.data);
        }
    }
}