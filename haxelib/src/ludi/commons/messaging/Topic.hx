package ludi.commons.messaging;

import ludi.commons.util.UUID;

class Topic<T> {

    private var subscribers: Map<String, T -> Void> = [];

    public function new(){}

    public function notify(arg: T = null){
        var __this = this;
        for(key => val in subscribers){
            if(subscribers[key] !=null){
                subscribers[key](arg);
            }
        }
    }

    public function unsubscribe(id: String): Void {
        this.subscribers.remove(id);
    }

    public function subscribe(callback: (arg: T) -> Void): String {
        var ticket = UUID.generate();
        this.subscribers[ticket] = callback;
        return ticket;
    }

    public function subscribeOnce(callback: (arg: T) -> Void){
        var wrappedCallback = null;
        var uuid = null;
        wrappedCallback = (arg1) -> {
            this.subscribers.remove(uuid);
            callback(arg1);
        }
        uuid = subscribe(wrappedCallback);
        return uuid;
    }

    public function subscribeUntil(callback:(event:T) -> Bool): String  {
        var wrappedCallback = null;
        var uuid = null;
        wrappedCallback = (arg1) -> {
            var result = callback(arg1);
            if(!result){
                this.subscribers.remove(uuid);
            }
        }
        uuid = subscribe(wrappedCallback);
        return uuid;
    }

}
