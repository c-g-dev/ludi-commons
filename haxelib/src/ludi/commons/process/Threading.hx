package ludi.commons.process;

import sys.thread.ElasticThreadPool;

class Threading {
    private static var threadPool: ElasticThreadPool;

    private static function createThreadpool(){
        threadPool = new ElasticThreadPool(100);
    }

    public static function runInChildThread(task: () -> Void){
        if(threadPool == null){
            createThreadpool();
        }
        threadPool.run(task);
    }

    public static function runWithEventLoop(task: () -> Void){
        sys.thread.Thread.createWithEventLoop(task);
    }
}