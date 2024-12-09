package ludi.commons.messaging;

import ludi.commons.util.UUID;

class Notifier<T: EnumValue> {

    private var subscribers: Map<T, Array<() -> Void>> = [];
    private var isExexcuting: Bool = false;
    private var pendingSubscriptions: Array<{kind: T, cb: () -> Void}> = [];

    public function new(){}

    public function notify(kind: T){
        isExexcuting = true;
        trace("notifying: " + kind);
        if(subscribers.exists(kind)){
            trace(subscribers[kind].length);
            for (cb in subscribers[kind]) {
                cb();
            }
        }
        subscribers[kind] = [];
        if(pendingSubscriptions.length > 0){
            for (eachPending in pendingSubscriptions) {
                if(!subscribers.exists(eachPending.kind)){
                    subscribers[eachPending.kind] = [];
                }
                subscribers[eachPending.kind].push(eachPending.cb);
            }
            pendingSubscriptions = [];
        }
        isExexcuting = false;
    }

    public function on(kind: T, callback: () -> Void): Void {
        if(!isExexcuting){
            if(!subscribers.exists(kind)){
                subscribers[kind] = [];
            }
            subscribers[kind].push(callback);
        }
        else{
            pendingSubscriptions.push({kind: kind, cb: callback});
        }
    }

}
