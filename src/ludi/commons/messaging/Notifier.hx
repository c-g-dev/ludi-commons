package ludi.commons.messaging;

import ludi.commons.util.UUID;

class Notifier<T: EnumValue> {

    private var subscribers: Map<T, Array<() -> Void>> = [];

    public function new(){}

    public function notify(kind: T){
        if(subscribers.exists(kind)){
            for (cb in subscribers[kind]) {
                cb();
            }
        }
        subscribers[kind] = [];
    }

    public function on(kind: T, callback: () -> Void): Void {
        if(!subscribers.exists(kind)){
            subscribers[kind] = [];
        }
        subscribers[kind].push(callback);
    }

}
