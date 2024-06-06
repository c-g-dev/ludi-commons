package ludi.commons.collections;

import ludi.commons.model.Direction;
import haxe.ds.Option;

abstract CardinalGraph<K>(Array<CardinalGraphNode<K>>) from Array<CardinalGraphNode<K>> to Array<CardinalGraphNode<K>> {
    public inline function new(nodes:Array<CardinalGraphNode<K>>) {
      this = nodes;
    }
  
    public function addEdge(node:CardinalGraphNode<K>):Void {
      this.push(node);
    }
  
    public function reverse(dir: Direction): Direction {
        switch dir {
            case UP: return DOWN;
            case RIGHT: return LEFT;
            case DOWN: return UP;
            case LEFT: return RIGHT;
        }
    }

    public function get(key:K, dir: Direction):Option<K> {
        for (node in this) {
            switch (node) {
                case Edge(nodeKey, nodeDir, nodeVal): {
                    if((nodeKey == key) && (nodeDir == dir)){
                        return Some(nodeVal);
                    }
                }
                case ReversibleEdge(nodeKey, nodeDir, nodeVal): {
                    if((nodeKey == key) && (nodeDir == dir)){
                        return Some(nodeVal);
                    }
                    if((nodeVal == key) && (nodeDir == reverse(dir))){
                        return Some(nodeVal);
                    }
                }
            }
        }
        return None;
    }
}

enum CardinalGraphNode<K> {
    Edge(key: K, direction: Direction, val: K);
    ReversibleEdge(key: K, direction: Direction, val: K);
}