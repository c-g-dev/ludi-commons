package ludi.commons.process;

import ludi.commons.collections.Queue;

class ActionQueue {
	var queue:Queue<() -> Void> = new Queue();

	public function new() {}

	public function push(func:() -> Void) {
		queue.push(func);
		work();
	}

	private var isWorking:Bool = false;

	public function work() {
		if (isWorking) {
			return;
		}
		isWorking = true;
		while (!queue.isEmpty()) {
			queue.pop()();
		}
		isWorking = false;
	}
}
