package ludi.commons.collections;

class Queue<T> {
    public var _store: Array<T> = [];

    public function new() {}

    public function push(val: T) {
      this._store.push(val);
    }

    public function pushToFront(val: T) {
      this._store.unshift(val);
    }

    public function pushAll(valArr: Array<T>) {
      for(eachItem in valArr){
        this._store.push(eachItem);
      }
    }

    public function pushAllToFront(valArr: Array<T>) {
      for(eachItem in valArr){
        this._store.unshift(valArr[(valArr.length - 1) - valArr.indexOf(eachItem)]);
      }
    }

    public function peek(){
      if(_store.length > 0){
        return this._store[0];
      }
      return null;
    }

    public function isEmpty(): Bool {
      return this._store.length <= 0;
    }

    public function pop(): T  {
      return this._store.shift();
    }
  }