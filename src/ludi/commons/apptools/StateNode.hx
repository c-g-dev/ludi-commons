package ludi.commons.apptools;

import haxe.ds.Option;
import ludi.commons.util.UUID;
import ludi.commons.messaging.Topic;
import ludi.commons.util.JsonAccess;
import haxe.Json;

typedef AnyStateNode = StateNode<Dynamic>;

class StateNode<T> {
    public var uuid: String;
    public var tag: String;
    public var name: String;
    public var virtual: Bool = false;
    public var attrs: T;
    public var children: Array<StateNode<Dynamic>>;
    public var parent: StateNode<Dynamic>;
    public var topic: Topic<StateNodeEvent> = new Topic();

    public function new(tag: String, attrs: T) {
        this.uuid = UUID.generate();
        this.tag = tag;
        this.attrs = attrs;
        this.children = [];
        this.parent = null;
    }

    public function addChild(child: StateNode<Dynamic>): Void {
        child.parent = this;
        this.children.push(child);
        child.topic.notify(OnAttached);
    }

    public function hasAttr(attr: String): Bool {
        for (s in Reflect.fields(attrs)) {
            if(s == attr){
                return true;
            }
        }
        return false;
    }
    
    public function getAttr(attr: String): Dynamic {
        return Reflect.field(attrs, attr);
    }

    public dynamic function serialize(): String {
        var serializedChildren: Array<String> = [];
        for (node in children) {
            if(!node.virtual){
                serializedChildren.push(node.serialize());
            }
        }
        return Json.stringify({
            uuid: this.uuid,
            tag: this.tag,
            attrs: this.attrs,
            children: serializedChildren
        });
    }

    public dynamic function serializeOne(): String {
        return Json.stringify({
            uuid: this.uuid,
            tag: this.tag,
            attrs: this.attrs,
            children: []
        });
    }

    public dynamic function deserializeOne(data: String): StateNode<T> {
        var jsob = Json.parse(data);
        var newNode = new StateNode<T>(jsob.tag, jsob.attrs);
        newNode.uuid = jsob.uuid;
        newNode.virtual = jsob.virtual;
        return newNode;
    }


    public dynamic function deserialize(data: String): StateNode<Dynamic> {
        var jsob = Json.parse(data);
        var newNode = new StateNode<Dynamic>(jsob.tag, jsob.attrs);
        newNode.uuid = jsob.uuid;
        newNode.virtual = jsob.virtual;
        for (childData in JsonAccess.asArray(jsob.children)) {
            var childNode = deserialize(childData);
            newNode.addChild(childNode);
        }

        return newNode;
    }

    public function removeByUUID(guid:String) {
         for (i in 0...children.length) {
            if (children[i].uuid == guid) {
                children.splice(i, 1);
                return;
            }
        }
        for (child in children) {
            child.removeByUUID(guid);
        }
    }
    

    public function clone(): StateNode<T> {
		var clone = new StateNode<T>(this.tag, this.attrs);
		clone.uuid = this.uuid;
		clone.name = this.name;
		clone.virtual = this.virtual;

		for (child in this.children) {
			var childClone = child.clone();
			clone.addChild(childClone);
		}

		return cast clone;
	}
    public function root(): StateNode<Dynamic> {
        var topmost: StateNode<Dynamic> = this;
        while (topmost.parent != null) {
            topmost = topmost.parent;
        }
        return topmost;
    }
    

    public function getNearestParent(s: String): StateNode<Dynamic> {
        var current: StateNode<Dynamic> = this;
        while (current != null) {
            if (current.tag == s) {
                return cast current;
            }
            current = current.parent;
        }
        return null;
    }
    
    public function firstChildOf(s: String): StateNode<Dynamic> {
        for (child in children) {
            if (child.tag == s) {
                return cast child;
            }
        }
        return null;
    }

    public function forEachBreadthFirst(cb: (StateNode<Dynamic>) -> Void): Void {
        var queue: Array<StateNode<Dynamic>> = [cast this];
        while (queue.length > 0) {
            var node = queue.shift();
            cb(node);
            for (child in node.children) {
                queue.push(child);
            }
        }
    }

    public function printTree(): Void {
        var topmost: StateNode<Dynamic> = this;
        while (topmost.parent != null) {
            topmost = topmost.parent;
        }
    
        function buildTreeString(node: StateNode<Dynamic>, depth: Int): String {
            var indent = "";
            for (i in 0...depth) {
                indent += "\t";
            }
            var result = indent + "<" + node.tag + ">\n";
            for (child in node.children) {
                result += buildTreeString(child, depth + 1);
            }
            result += indent + "</" + node.tag + ">\n";
            return result;
        }
    
        var treeString = buildTreeString(topmost, 0);
        trace(treeString);
    }
}

enum StateNodeEvent {
    AttributesChanged;
    ChildrenChanged;
    OnAttached;
}

class StateNodeConsumer {
    var deserializers: Map<String, (String, Option<StateNode<Dynamic>>) -> StateNode<Dynamic>>;
    var serializers: Map<String, (StateNode<Dynamic>, Option<StateNode<Dynamic>>) -> String>;

    public function new() {
        deserializers = new Map<String, (String, Option<StateNode<Dynamic>>) -> StateNode<Dynamic>>();
        serializers = new Map<String, (StateNode<Dynamic>, Option<StateNode<Dynamic>>) -> String>();
    }

    public function serialize(thisNode: StateNode<Dynamic>): String {
        return this.serializeWithHandlers(thisNode, None);
    }

    public function addSerializer(tag: String, serializer: (thisNode: StateNode<Dynamic>, parent: Option<StateNode<Dynamic>>) -> String): Void {
        serializers.set(tag, serializer);
    }

    public function deserialize(json: String): StateNode<Dynamic> {
        return this.deserializeWithHandlers(json, None);
    }

    public function addDeserializer(tag: String, deserializer: (nodeContent: String, parent: Option<StateNode<Dynamic>>) -> StateNode<Dynamic>): Void {
        deserializers.set(tag, deserializer);
    }

    private function deserializeWithHandlers(thisContent: String, parent: Option<StateNode<Dynamic>>): StateNode<Dynamic> {
        var jsob = Json.parse(thisContent);
        
        var tag = jsob.tag;
        var deserializer = deserializers.get(tag);
        var node: StateNode<Dynamic>;

        if (deserializer != null) {
            trace("deserializer found");
            node = deserializer(thisContent, parent);
        } else {
            trace("deserializer not found");
            node = new StateNode("", {}).deserializeOne(thisContent);
        }

        switch (parent) {
            case Some(p): {
                p.addChild(node);
            }
            case None: {
                // do nothing
            }
        }

        if(jsob.children != null){
            for (childData in JsonAccess.asArray(jsob.children)) {
                if(!childData.virtual){
                    this.deserializeWithHandlers(childData, Some(node));
                }
            }
        }

        return node;
    }

    private function serializeWithHandlers(thisNode: StateNode<Dynamic>, parent: Option<StateNode<Dynamic>>): String {
        var serializer = serializers.get(thisNode.tag);
        var serializedStr: String;

        if (serializer != null) {
            serializedStr = serializer(thisNode, parent);
        } else {
            serializedStr = thisNode.serializeOne();
        }
        
        var jsob = Json.parse(serializedStr);
        jsob.children = [];

        for (child in thisNode.children) {
            if(!child.virtual){
                jsob.children.push(this.serializeWithHandlers(child, Some(thisNode)));
            }
        }

        return Json.stringify(jsob);
    }
}

/*
class StateNodeConsumer {
    public function new() {}

    public function consume(json: String): StateNode<Dynamic> {
        var rootNode = new StateNode<Dynamic>("", {});
        this.deserialize(json, None);
        return rootNode;
    }

    public dynamic function deserialize(thisContent: String, parent: Option<StateNode<Dynamic>>): StateNode<Dynamic> {
        var node = new StateNode("", {}).deserializeOne(thisContent);
        switch (parent) {
            case Some(p): {
                p.addChild(node);
            }
            case None: {
                // do nothing
            }
        }

        var jsob = Json.parse(thisContent);
        for (childData in JsonAccess.asArray(jsob.children)) {
            this.deserialize(childData, Some(node));
        }

        return node;
    }
}
*/