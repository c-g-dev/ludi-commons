package ludi.commons.process;

class Callback {
	var onCompleteSet:Bool = false;
	var isComplete:Bool = false;
	var cb:() -> Void;

	public function new() {
		
	}

    public static function completed(): Callback {
        var c = new Callback();
        c.complete();
        return c;
    }

	public function onComplete(cb:() -> Void) {
		onCompleteSet = true;
		this.cb = cb;

		// If already complete when callback is set,
		// invoke the callback function immediately.
		if (isComplete) {
			this.cb();
		}
	}

	public function complete() {
		isComplete = true;

		// If onComplete has been set when complete() is called,
		// invoke the callback function.
		if (onCompleteSet) {
			this.cb();
		}
	}
}
