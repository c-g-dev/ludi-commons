package ludi.commons.pattern;

class SyncPair<T> {
    private var target: T;
    private var existing: T;
    public var isDirty: Bool = false;
    private var cloneFunc: (T) -> T;
    private var eventHandlers: Array<(SyncPairEvent<T>) -> Void> = [];
    public var changesContext: Map<String, Dynamic> = [];

    public function new(initialValue: T, clone: (T) -> T) {
        this.cloneFunc = clone;
        this.existing = initialValue;
        this.target = clone(initialValue);
    }

    public function editTarget(cb: (target: T) -> Void): Void {
        cb(target);
        isDirty = true;
        dispatchEvent(TargetEdited(target));
    }

    public function smudge(): T {
        isDirty = true;
        dispatchEvent(Smudged(target));
        return target;
    }

    public function readExisting(): T {
        return existing;
    }

    public function commit(): Void {
        existing = target;
        target = cloneFunc(target);
        isDirty = false;
        changesContext = [];
        dispatchEvent(Committed(existing));
    }

    public function onEvent(handler: (SyncPairEvent<T>) -> Void): Void {
        eventHandlers.push(handler);
    }

    private function dispatchEvent(event: SyncPairEvent<T>): Void {
        for (handler in eventHandlers) {
            handler(event);
        }
    }
}

enum SyncPairEvent<T> {
    TargetEdited(target: T);
    Smudged(target: T);
    Committed(existing: T);
}