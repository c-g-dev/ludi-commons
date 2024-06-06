package ludi.commons.collections;

class Stack<T>{
    public var storage: Array<T> = [];

    public function new() {}
  
    public function push(item: T): Void {
      this.storage.push(item);
    }
  
    public function pop(): T {
      return this.storage.pop();
    }
  
    public function peek(): T {
        if(storage.length > 0){
            return this.storage[this.size() - 1];
        }
        return null;
      
    }
  
    public function size(): Int {
      return this.storage.length;
    }

    public function isEmpty(): Bool {
        return (this.storage.length <= 0);
    }

    public function pushAll(items: Array<T>): Void {
        for(eachItem in items){
            this.storage.push(eachItem);
        }
    }

  }