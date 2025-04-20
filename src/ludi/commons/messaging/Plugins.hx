package ludi.commons.messaging;

import ludi.commons.messaging.Topic;

class Plugins<C> {
    var plugins:Array<Plugin<WithPlugins<C>>> = [];
    var topicPlugin:TopicPlugin<C>;
    
    public function new() {}

    public function notify(event:C):Void {
        for (plugin in plugins) {
            @:privateAccess plugin.on(plugin.host, event);
        }
    }

    public function createTopic():Topic<C> {
        if (topicPlugin == null) {
            topicPlugin = new TopicPlugin<C>();
            plugins.push(cast topicPlugin);
        }
        return topicPlugin.topic;
    }

    public static function add<C>(host:WithPlugins<C>, plugin:Plugin<WithPlugins<C>>):Void {
        @:privateAccess if (host.plugins.plugins.indexOf(plugin) == -1) {
            @:privateAccess host.plugins.plugins.push(plugin);
            plugin.onAttached(host);
        }
    }

    public function remove(plugin:Plugin<WithPlugins<C>>):Void {
        if (plugins.remove(plugin)) {
            @:privateAccess plugin.onRemoved(plugin.host);
        }
    }
}

class TopicPlugin<C> extends Plugin {
    public var topic = new Topic<C>();

    public function onAttached(obj:Dynamic):Void {}

    public function on(object: Dynamic, event:Dynamic):Void {
        topic.notify(event);
    }

    public function onRemoved(obj:Dynamic):Void {}
}

abstract class Plugin<T:WithPlugins<C> = Dynamic, C = Dynamic> {
    var typecode: TypeCode;
    var host:T;

    public function new() {
        this.typecode = new TypeCode(this);
    }

    public function attach(obj:T):Void {
        this.host = obj;
        onAttached(obj);
    }

    public abstract function onAttached(obj:T):Void;
    public abstract function on(object: T, event:C):Void;
    public abstract function onRemoved(obj:T):Void;
}

interface WithPlugins<C> {
    private var plugins: Plugins<C>;
}
