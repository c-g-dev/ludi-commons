package ludi.commons.process;

import haxe.Exception;
import sys.thread.Thread;
import sys.thread.FixedThreadPool;

class Timeout {
    static var threadPool: FixedThreadPool;
    var maxTime: Int;
    var onTimeout: () -> Void;
    var startTime: Float;

    var stopToken: Bool = false;

    public function new(maxTime: Int, onTimeout: () -> Void) {
        this.maxTime = maxTime;
        this.onTimeout = onTimeout;
        if(threadPool == null){
            threadPool = new FixedThreadPool(5);
        }
    }

    public function start() {
        this.stopToken = false;
        startTime = Sys.time();
        threadPool.run(() -> {
            while(!stopToken){
                Sys.sleep(1);
                if(Sys.time() > (maxTime + startTime)){
                    stopToken = true;
                    onTimeout();
                }
            }
        });
    }

    public function stop() {
        this.stopToken = true;
    }

}