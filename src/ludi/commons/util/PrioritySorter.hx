package ludi.commons.util;

class PrioritySorter<T> {
	var items: Array<{tag: String, item: T, priority: Priority}> = [];
	var currentOrder: Array<String> = [];
	var collisionStrategy: CollisionStrategy<T>;

	public function new(?collisionStrategyArg: CollisionStrategy<T>) {
		collisionStrategy = collisionStrategyArg == null ? CollisionStrategy.PrioritizeFirstInserted : collisionStrategyArg;
	}

	public function consume(tag: String, item: T, priority: Priority) {
		items.push({tag: tag, item: item, priority: priority});
		rebalanceOrder();
	}

	public function getItemsInOrder(): Array<T> {
		var orderedItems = [];
		for (tag in currentOrder) {
			for (item in items) {
				if (item.tag == tag) {
					orderedItems.push(item.item);
				}
			}
		}
		return orderedItems;
	}

	private function rebalanceOrder() {
		currentOrder = items.map(item -> item.tag);
		currentOrder.sort((a, b) -> {
			var priorityA = getPriority(a);
			var priorityB = getPriority(b);
			if (priorityA == priorityB) {
				return resolveCollision(items.filter(item -> item.tag == a)[0], items.filter(item -> item.tag == b)[0]);
			}
			return priorityA - priorityB;
		});
	}

	private function getPriority(tag: String): Null<Int> {
		for (item in items) {
			if (item.tag == tag) {
				return getPriorityValue(item.priority);
			}
		}
		return 0;
	}

	private function getPriorityValue(priority: Priority): Null<Int> {
		switch (priority) {
			case Lowest: return -1;
			case Normal: return 0;
			case Highest: return 1;
			case Exact(i): return i;
			case Above(group):
				var groupPriority = getPriority(group);
				return groupPriority != null ? (groupPriority + 1) : 0;
			case Below(group):
				var groupPriority = getPriority(group);
				return groupPriority != null ? (groupPriority - 1) : 0;
		}
	}

	private function resolveCollision(a: {tag: String, item: T, priority: Priority}, b: {tag: String, item: T, priority: Priority}): Int {
		switch (collisionStrategy) {
			case PrioritizeFirstInserted:
				return items.indexOf(a) - items.indexOf(b);
			case Custom(cb):
				return cb(a) - cb(b);
		}
	}
}

enum Priority {
	Lowest;
	Normal;
	Highest;
	Exact(i: Int);
	Above(group: String);
	Below(group: String);
}

enum CollisionStrategy<T> {
    PrioritizeFirstInserted;
    Custom(cb: ({tag: String, item: T, priority: Priority}) -> Int);
}