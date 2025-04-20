package ludi.commons.messaging;


enum SentinelEvent {
    Started;
    Completed;
}


abstract Sentinel({state: Int, topic: SentinelEvent -> Void, afterCompletes: Array<Void -> Void>}) {
    public function new(topic: SentinelEvent -> Void) {
        this = {state: 0, topic: topic, afterCompletes: []};
    }

    public function litigate(cb: Void -> Void, ?afterComplete: Void -> Void): Void {
        abstract.push();
        cb();
        if(afterComplete != null){
            this.afterCompletes.push(afterComplete);
        }
        abstract.pop();
    }

    public function push(): Void {
        this.state++;
        if(this.state == 1){
            this.topic(Started);
        }
    }

    public function pop(): Void {
        this.state--;
        if(this.state <= 0){
            this.topic(Completed);
            for(each in this.afterCompletes){
                each();
            }
            this.afterCompletes = [];
        }
    }
}
