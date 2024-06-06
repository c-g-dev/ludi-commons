package ludi.commons.process;

abstract CallbackCollection(Array<() -> Void>){
    public inline function new() {
        this = [];
    }

    public inline function add(func: () -> Void){
        this.push(func);
    }

    public inline function fire(){
        for(func in this){
            func();
        }
    }

    public inline function reset(){
        this = [];
    }
}