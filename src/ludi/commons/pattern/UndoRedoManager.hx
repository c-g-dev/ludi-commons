package ludi.commons.pattern;

import ludi.commons.messaging.Notifier;

enum UndoRedoManagerEvent<StateType, ReturnType> {
    GetState: UndoRedoManagerEvent<StateType, StateType>;
    SetState(state: StateType): UndoRedoManagerEvent<StateType, StateType>;
    SerializeState(s: StateType): UndoRedoManagerEvent<StateType, String>;
    DeserializeState(s: String): UndoRedoManagerEvent<StateType, StateType>;
}

class UndoRedoManager<StateType> {
    private var undoStack:Array<String>;
    private var redoStack:Array<String>;
    private var handler:UndoRedoManagerEvent<StateType, Dynamic> -> Dynamic;
    private var maxStackSize:Int;

    public function new(maxStackSize:Int, handler:UndoRedoManagerEvent<StateType, Dynamic> -> Dynamic) {
        this.maxStackSize = maxStackSize;
        this.handler = handler;
        undoStack = [];
        redoStack = [];
        pushInitialState();
    }
    
    private function pushInitialState():Void {
        var state = cast handler(UndoRedoManagerEvent.GetState);
        var serializedState = cast handler(UndoRedoManagerEvent.SerializeState(state));
        undoStack.push(serializedState);
    }

    public function push():Void {
        redoStack = [];
        
        var state = cast handler(UndoRedoManagerEvent.GetState);
        var serializedState = cast handler(UndoRedoManagerEvent.SerializeState(state));
        undoStack.push(serializedState);

        if (undoStack.length > maxStackSize) {
            undoStack.shift();
        }
    }

    public function undo():Void {
        trace("undo: " + undoStack.length);
        if (canUndo()) {
            var currentState = cast handler(UndoRedoManagerEvent.GetState);
            var serializedCurrentState = cast handler(UndoRedoManagerEvent.SerializeState(currentState));
            redoStack.push(serializedCurrentState);

            undoStack.pop();

            if (undoStack.length > 0) {
                var serializedPrevState = undoStack[undoStack.length - 1];
                var prevState = cast handler(UndoRedoManagerEvent.DeserializeState(serializedPrevState));
                handler(UndoRedoManagerEvent.SetState(prevState));
            } else {
                trace("No more states to undo to.");
            }
        } else {
            trace("Cannot undo.");
        }
    }

    public function redo():Void {
        if (canRedo()) {
            var serializedNextState = redoStack.pop();
            var nextState = cast handler(UndoRedoManagerEvent.DeserializeState(serializedNextState));

            undoStack.push(serializedNextState);

            handler(UndoRedoManagerEvent.SetState(nextState));
        } else {
            trace("Cannot redo.");
        }
    }

    public function canUndo():Bool {
        return undoStack.length > 1;
    }

    public function canRedo():Bool {
        return redoStack.length > 0;
    }
}