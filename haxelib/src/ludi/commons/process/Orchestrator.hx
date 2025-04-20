package ludi.commons.process;

import haxe.Timer;

typedef OrchestratorOptions = {
    var skipFrameOnAdvance: Bool;
}

class Orchestrator {
    private var step:Int = -1;
    private var callback: (Int, Orchestrator) -> Void;
    private var isComplete: Bool = false;
    private var options: OrchestratorOptions = { skipFrameOnAdvance: true };

    public function new(cb: (Int, Orchestrator) -> Void, ?opts: OrchestratorOptions) {
        callback = cb;
        options = opts != null ? opts : this.options;
    }

    public function advance():Void {
        if (options.skipFrameOnAdvance) {
            Timer.delay(() -> {
                step++;
                callback(step, this);
            }, 0);
        } else {
            step++;
            callback(step, this);
        }
    }

    public function reset():Void {
        isComplete = false;
        step = -1;
    }
    
    public function end():Void {
        isComplete = true;
    }
}