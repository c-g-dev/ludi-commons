package ludi.commons.process;

import ludi.commons.collections.Queue;

class ConsumerQueue<T> {

    var queue: Queue<T> = new Queue<T>();

    public function new(){

    }

    public function consume(item: T) {
        queue.push(item);
        work(false);
    }

    var isWorking: Bool = false;
    function work(ignoreGuard: Bool) {
        if(isWorking && !ignoreGuard){
            return;
        }
        isWorking = true;

        if(queue.isEmpty()){
            onEmpty();
        }
        else{
            var item = queue.pop();
            onConsume(item, () -> {
                work(true);
            });    
        }
        isWorking = false;
    }

    public dynamic function onConsume(item: T, resolve: () -> Void): Void {}

    public dynamic function onEmpty(): Void {}


}