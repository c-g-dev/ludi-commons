package ludi.commons.process;

class Multilock {
	public var degree:Int;
	public var onFulfilled:() -> Void;
    var isFinished: Bool = false;
    private var currentCount = 0;

	public function new(degree:Int, onFulfilled:() -> Void) {
		this.degree = degree;
		this.onFulfilled = onFulfilled;
	}

    public function increment() {
        if(isFinished){
            return;
        }
        this.currentCount++;
        if(this.currentCount >= this.degree){
            isFinished = true;
            onFulfilled();
            onFinished();
        }
    }

    public dynamic function onFinished(): Void {

    }

    public dynamic function onCancelled(): Void {

    }

    public function cancel() {
        if(isFinished){
            return;
        }
        isFinished = true;
        onCancelled();
        onFinished();
    }
}
