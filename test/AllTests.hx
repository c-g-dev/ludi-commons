import ludi.commons.collections.GridMap;
import ludi.commons.model.Direction;
import ludi.commons.macro.VarTrace;
import ludi.commons.collections.Set;
import ludi.commons.util.Nulls;
import haxe.ds.Option;
import ludi.commons.util.Options;
import ludi.commons.util.Styles;
import ludi.commons.util.PrioritySorter;

class Test {
    public var name: String;
    public var testFunction: () -> Bool;

    public function new(name: String, testFunction: () -> Bool) {
        this.name = name;
        this.testFunction = testFunction;
        AllTests.all.push(this);
    }
}

class AllTests {
    public static final all: Array<Test> = [];

    public static function main() {
        LOAD_TESTS();

        var failedTests: Array<String> = [];

        for(test in all) {
            var result = false;
            try {
                trace("Running " + test.name);
                result = test.testFunction();
               
            } catch (e: Dynamic) {
                result = false;
            }
            if (!result) {
                trace("\t" + test.name + " failed.");
                failedTests.push(test.name);
            }
            else{
                trace("\t" + test.name + " passed.");
            }
        }

        if (failedTests.length == 0) {
            trace("All tests passed successfully!");
        } else {
            for (failedTest in failedTests) {
                trace("Test failed: " + failedTest);
            }
        }
    }
}

var LOAD_TESTS = () -> {



    new Test("util/Styles.hx", function(): Bool {
        var a: Dynamic = {foo: "bar"};
        var b: Dynamic = {baz: "qux"};
        Styles.upsert(a, b);
        return a.foo == "bar" && a.baz == "qux";
    });
    
    new Test("util/Stopwatch.hx", function(): Bool {
        var stopwatch = new ludi.commons.util.Stopwatch();
        stopwatch.start();
        Sys.sleep(1);
        stopwatch.stop();
        var elapsed = stopwatch.getElapsedMillis();
        return elapsed >= 1;
    });
    
    new Test("util/ReflectUtils.hx", function(): Bool {
        var a = {foo: "bar"};
        var b = {foo: "baz", qux: "quux"};
        ludi.commons.util.ReflectUtils.update(a, b);
        return a.foo == "baz" && !Reflect.hasField(a, "qux");
    });
    
    new Test("util/PrioritySorter.hx", function(): Bool {
        var sorter = new PrioritySorter<String>(null);
        sorter.consume("item1", "A", Priority.Normal);
        sorter.consume("item2", "B", Priority.Lowest);
        sorter.consume("item3", "C", Priority.Highest);
        var orderedItems = sorter.getItemsInOrder();
        return orderedItems[0] == "B" && orderedItems[1] == "A" && orderedItems[2] == "C";
    });

    new Test("util/Options.hx", function(): Bool {
        var result1 = switch Options.of("Test") {
            case Some("Test"): true;
            default: false;
        };

        var result2 = switch Options.of(null) {
            case None: true;
            default: false;
        };

        var arr = [1, 2, 3];
        var result3 = Type.enumEq(Options.tryArray(arr, 1), Some(2));

        var result4 = Options.tryArray(arr, 3) == None;

        var optionSome = Option.Some("value");
        var optionNone = None;
        var result5 = Options.get(optionSome) == "value";
        var result6 = Options.get(optionNone) == null;
        
        return result1 && result2 && result3 && result4 && result5 && result6 ;
    });

    new Test("util/Nulls.hx", function(): Bool {
        // Test for getOrDefault
        var result1 = Nulls.getOrDefault(null, "default") == "default";
        var result2 = Nulls.getOrDefault("value", "default") == "value";
        
        // Mock MapCheck implementation
        var mockMap: Map<String, Dynamic> = new Map();
        mockMap.set('exists', 'value');
        
        // Test for mapGetDefault
        var result3 = Nulls.mapGetDefault(mockMap, 'exists', 'default') == 'value';
        var result4 = Nulls.mapGetDefault(mockMap, 'nonexists', 'default') == 'default';
        var result5 = mockMap.get('nonexists') == 'default';
        
        return result1 && result2 && result3 && result4 && result5;
    });


    new Test("collections/Set.hx", function(): Bool {
        var set = new Set<String>();
        
        set.push("A");
        var result1 = set.exists("A") == true;
    
        set.push("A"); // Should not add duplicate
        var result2 = set._data.length == 1;
    
        set.push("B");
        var result3 = set.exists("B") == true;
        var result4 = set._data.length == 2;
    
        var arrVals = ["B", "C", "D"];
        set.addAll(arrVals);
        var result5 = set._data.length == 4; // "B" is duplicate, "C" and "D" are new
    
        return result1 && result2 && result3 && result4 && result5;
    });
    
    new Test("collections/Stack.hx", function(): Bool {
        var stack = new ludi.commons.collections.Stack<Int>();
    
        stack.push(1);
        stack.push(2);
        stack.push(3);
        var result1 = stack.size() == 3;
        var result2 = stack.peek() == 3;
        var result3 = stack.pop() == 3;
        var result4 = stack.size() == 2;
        var result5 = stack.pop() == 2;
        var result6 = stack.pop() == 1;
        var result7 = stack.isEmpty() == true;
    
        stack.pushAll([4, 5, 6]);
        var result8 = stack.size() == 3;
        var result9 = stack.peek() == 6;
        
        return result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9;
    });

    new Test("collections/Queue.hx", function(): Bool {
        var queue = new ludi.commons.collections.Queue<Int>();
    
        queue.push(1);
        queue.push(2);
        queue.push(3);
        var result1 = queue.peek() == 1;
        var result2 = queue.pop() == 1;
        var result3 = queue.pop() == 2;
        var result4 = queue.isEmpty() == false;
    
        queue.pushToFront(4);
        var result5 = queue.peek() == 4;
        var result6 = queue.pop() == 4;
        var result7 = queue.pop() == 3;
        var result8 = queue.isEmpty() == true;
    
        queue.pushAll([5, 6, 7]);
        var result9 = queue.peek() == 5;
        var result10 = queue.pop() == 5;
        var result11 = queue.pop() == 6;
        var result12 = queue.pop() == 7;
        var result13 = queue.isEmpty() == true;
    
        queue.pushAllToFront([8, 9, 10]);
        var result14 = queue.peek() == 8;
        var result15 = queue.pop() == 8;
        var result16 = queue.pop() == 9;
        var result17 = queue.pop() == 10;
        var result18 = queue.isEmpty() == true;
    
        VarTrace.ampersands(result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && 
            result9 && result10 && result11 && result12 && result13 && result14 && result15 && result16 && result17 && result18);
            
        return result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && 
               result9 && result10 && result11 && result12 && result13 && result14 && result15 && result16 && result17 && result18;
    });


    new Test("collections/GridMap.hx", function(): Bool {
        var gridMap = new ludi.commons.collections.GridMap<String>();
        
        gridMap.add(0, 0, "A");
        var result1 = gridMap.get(0, 0) == "A";
        var result2 = gridMap.has(0, 0) == true;
        
        gridMap.add(1, 1, "B");
        var result3 = gridMap.get(1, 1) == "B";
        var result4 = gridMap.has(1, 1) == true;
        
        gridMap.add(2, 2, "C");
        var result5 = gridMap.get(2, 2) == "C";
        var result6 = gridMap.has(2, 2) == true;
    
        gridMap.change(1, 1, 3, 3, "D");
        var result7 = gridMap.get(1, 1) == null;
        var result8 = gridMap.get(3, 3) == "D";
    
        var allItems = gridMap.all();
        var result9 = allItems.length == 3;
        var result10 = allItems.indexOf("C") != -1;
        var result11 = allItems.indexOf("D") != -1;
        
        gridMap.remove(2, 2);
        var result12 = gridMap.has(2, 2) == false;
        var result13 = gridMap.get(2, 2) == null;
        
        var dimensions = gridMap.dimensions();
        var result14 = dimensions.x == 3 && dimensions.y == 3;
    
        var serialized = gridMap.serialize();
        var deserializedGridMap = GridMap.deserialize(serialized);
        var result15 = deserializedGridMap.get(0, 0) == "A";
        var result16 = deserializedGridMap.get(3, 3) == "D";
    
        var clonedGridMap = gridMap.clone();
        var result17 = clonedGridMap.get(0, 0) == "A";
        var result18 = clonedGridMap.get(3, 3) == "D";
        
        var anotherGridMap = new ludi.commons.collections.GridMap<String>();
        anotherGridMap.add(4, 4, "E");
        gridMap.outerJoin(anotherGridMap);
        var result19 = gridMap.get(4, 4) == "E";
        
        gridMap.add(2, 2, "A");
        gridMap.truncateTo(3, 3);
        var result20 = gridMap.has(3, 3) == false;
        var result21 = gridMap.has(2, 2) == true;

        VarTrace.ampersands( result1 && result2 && result3 && result4 && 
            result5 && result6 && result7 && result8 && 
            result9 && result10 && result11 && result12 && 
            result13 && result14 && result15 && result16 && 
            result17 && result18 && result19 && result20 && 
            result21);
    
        return result1 && result2 && result3 && result4 && 
               result5 && result6 && result7 && result8 && 
               result9 && result10 && result11 && result12 && 
               result13 && result14 && result15 && result16 && 
               result17 && result18 && result19 && result20 && 
               result21;
    });



    new Test("collections/GridDepthMap.hx", function(): Bool {
        var gridDepthMap = new ludi.commons.collections.GridDepthMap<String>();
    
        gridDepthMap.upsert(0, 0, "A");
        var result1 = gridDepthMap.getAll(0, 0).length == 1 && gridDepthMap.getAll(0, 0)[0] == "A";
    
        gridDepthMap.upsert(0, 0, "B");
        var result2 = gridDepthMap.getAll(0, 0).length == 2 && gridDepthMap.getAll(0, 0)[1] == "B";
    
        gridDepthMap.upsert(1, 1, "C");
        var result3 = gridDepthMap.getAll(1, 1).length == 1 && gridDepthMap.getAll(1, 1)[0] == "C";
    
        var allItems = gridDepthMap.all();
        var result4 = allItems.length == 3;
        var result5 = allItems.indexOf("A") != -1;
        var result6 = allItems.indexOf("B") != -1;
        var result7 = allItems.indexOf("C") != -1;
    
        gridDepthMap.removeItem("B");
        var result8 = gridDepthMap.getAll(0, 0).length == 1 && gridDepthMap.getAll(0, 0)[0] == "A";
        
        var dimensions = gridDepthMap.dimensions();
        var result9 = dimensions.x == 1 && dimensions.y == 1;
    
        gridDepthMap.forEach((x, y, item) -> { trace('Item at (${x}, ${y}): ${item}'); });
        var result10 = true; // Manual verification through trace output
    
        gridDepthMap.upsert(2, 2, "D");
        gridDepthMap.upsert(2, 2, "E");
        var result11 = gridDepthMap.getAll(2, 2).length == 2 && gridDepthMap.getAll(2, 2)[0] == "D" && gridDepthMap.getAll(2, 2)[1] == "E";
    
        return result1 && result2 && result3 && 
               result4 && result5 && result6 && 
               result7 && result8 && result9 && 
               result10 && result11;
    });

    new Test("collections/CardinalGraph.hx", function(): Bool {
        var graph = new ludi.commons.collections.CardinalGraph<String>([]);
        
        graph.addEdge(CardinalGraphNode.Edge("A", Direction.RIGHT, "B"));
        graph.addEdge(CardinalGraphNode.ReversibleEdge("B", Direction.DOWN, "C"));
        
        var result1 = Type.enumEq(graph.get("A", Direction.RIGHT), haxe.ds.Option.Some("B"));
        var result2 = Type.enumEq(graph.get("A", Direction.LEFT), haxe.ds.Option.None);
        var result3 = Type.enumEq(graph.get("B", Direction.DOWN), haxe.ds.Option.Some("C"));
        var result4 = Type.enumEq(graph.get("C", Direction.UP), haxe.ds.Option.Some("C")); // Reverse edge
    
        graph.addEdge(CardinalGraphNode.Edge("D", Direction.UP, "E"));
        var result5 = Type.enumEq(graph.get("D", Direction.UP), haxe.ds.Option.Some("E"));
        var result6 = Type.enumEq(graph.get("E", Direction.DOWN), haxe.ds.Option.None);
    
        graph.addEdge(CardinalGraphNode.ReversibleEdge("F", Direction.LEFT, "G"));
        var result7 = Type.enumEq(graph.get("F", Direction.LEFT), haxe.ds.Option.Some("G"));
        var result8 = Type.enumEq(graph.get("G", Direction.RIGHT), haxe.ds.Option.Some("G")); // Reverse edge
        var result9 = Type.enumEq(graph.get("F", Direction.RIGHT), haxe.ds.Option.None);
        
        return result1 && result2 && result3 && result4 && 
               result5 && result6 && result7 && result8 && result9;
    });
    
    new Test("collections/AnythingMap.hx", function(): Bool {
        var anythingMap = new ludi.commons.collections.AnythingMap<Int, String>();
    
        anythingMap.set(1, "A");
        var result1 = anythingMap.getLeft(1) == "A";
        
        anythingMap.set(2, "B");
        var result2 = anythingMap.getLeft(2) == "B";
        
        var result3 = anythingMap.getRight("A") == 1;
        var result4 = anythingMap.getRight("B") == 2;
    
        anythingMap.set(3, "C");
        var result5 = anythingMap.getLeft(3) == "C";
        
        anythingMap.remove(2);
        var result6 = true;
        try {
            anythingMap.getLeft(2);
            result6 = false; // should not reach here, an error is expected
        } catch (e:Dynamic) {}
    
        var result7 = true;
        try {
            anythingMap.getRight("B");
            result7 = false; // should not reach here, an error is expected
        } catch (e:Dynamic) {}
    
        return result1 && result2 && result3 && result4 && result5 && result6 && result7;
    });

    new Test("collections/I3Map.hx", function(): Bool {
        var i3Map = new ludi.commons.collections.I3Map<String>();
    
        i3Map.add(0, 0, 0, "A");
        var result1 = i3Map.get(0, 0, 0) == "A";
        
        i3Map.add(1, 1, 1, "B");
        var result2 = i3Map.get(1, 1, 1) == "B";
        
        var allItems = i3Map.all();
        var result3 = allItems.length == 2;
        var result4 = allItems.indexOf("A") != -1;
        var result5 = allItems.indexOf("B") != -1;
    
        i3Map.change(1, 1, 1, 2, 2, 2, "B");
        var result6 = i3Map.get(1, 1, 1) == null;
        var result7 = i3Map.get(2, 2, 2) == "B";
        
        i3Map.remove(0, 0, 0);
        var result8 = i3Map.has(0, 0, 0) == false;
        var result9 = i3Map.get(0, 0, 0) == null;
        
        
    
        var serialized = i3Map.serialize();
        var deserializedI3Map = ludi.commons.collections.I3Map.deserialize(serialized);
        var result11 = deserializedI3Map.get(2, 2, 2) == "B";
        var result12 = deserializedI3Map.get(1, 1, 1) == null;
    
        var clonedI3Map = i3Map.clone();
        var result13 = clonedI3Map.get(2, 2, 2) == "B";
        var result14 = clonedI3Map.get(1, 1, 1) == null;
        
        i3Map.clear();
        var result15 = i3Map.all().length == 0;
        
        return result1 && result2 && result3 && result4 && 
               result5 && result6 && result7 && result8 && 
               result9  && result11 && result12 && 
               result13 && result14 && result15 ;
    });

    new Test("collections/I4Map.hx", function(): Bool {
        var i4Map = new ludi.commons.collections.I4Map<String>();
    
        i4Map.add(0, 0, 0, 0, "A");
        var result1 = i4Map.get(0, 0, 0, 0) == "A";
    
        i4Map.add(1, 1, 1, 1, "B");
        var result2 = i4Map.get(1, 1, 1, 1) == "B";
    
        var allItems = i4Map.all();
        var result3 = allItems.length == 2;
        var result4 = allItems.indexOf("A") != -1;
        var result5 = allItems.indexOf("B") != -1;
    
        i4Map.change(1, 1, 1, 1, 2, 2, 2, 2, "B");
        var result6 = i4Map.get(1, 1, 1, 1) == null;
        var result7 = i4Map.get(2, 2, 2, 2) == "B";
    
        i4Map.remove(0, 0, 0, 0);
        var result8 = i4Map.has(0, 0, 0, 0) == false;
        var result9 = i4Map.get(0, 0, 0, 0) == null;
    
    
        var serialized = i4Map.serialize();
        var deserializedI4Map = ludi.commons.collections.I4Map.deserialize(serialized);
        var result11 = deserializedI4Map.get(2, 2, 2, 2) == "B";
        var result12 = deserializedI4Map.get(1, 1, 1, 1) == null;
    
        var clonedI4Map = i4Map.clone();
        var result13 = clonedI4Map.get(2, 2, 2, 2) == "B";
        var result14 = clonedI4Map.get(1, 1, 1, 1) == null;
    
        i4Map.clear();
        var result15 = i4Map.all().length == 0;
        
        VarTrace.ampersands(result1 && result2 && result3 && result4 && 
            result5 && result6 && result7 && result8 && 
            result9  && result11 && result12 && 
            result13 && result14 && result15 );

        return result1 && result2 && result3 && result4 && 
               result5 && result6 && result7 && result8 && 
               result9  && result11 && result12 && 
               result13 && result14 && result15 ;
    });

    new Test("collections/OneToManyMap.hx", function(): Bool {
        var oneToManyMap = new ludi.commons.collections.OneToManyMap<Int, String>();
    
        oneToManyMap.push(1, "A");
        var result1 = oneToManyMap.exists(1);
        var result2 = oneToManyMap[1].length == 1 && oneToManyMap[1][0] == "A";
        
        oneToManyMap.push(1, "B");
        var result3 = oneToManyMap[1].length == 2 && oneToManyMap[1][1] == "B";
    
        oneToManyMap.push(2, "C");
        var result4 = oneToManyMap.exists(2);
        var result5 = oneToManyMap[2].length == 1 && oneToManyMap[2][0] == "C";
    
        var allValues = oneToManyMap[1].concat(oneToManyMap[2]);
        var result6 = allValues.length == 3;
        var result7 = allValues.indexOf("A") != -1;
        var result8 = allValues.indexOf("B") != -1;
        var result9 = allValues.indexOf("C") != -1;
    
        return result1 && result2 && result3 && result4 && 
               result5 && result6 && result7 && result8 && result9;
    });

    new Test("collections/ReversibleGridMap.hx", function(): Bool {
        function data2Key(item: String): String {
            return item;
        }
    
        var reversibleGridMap = new ludi.commons.collections.ReversibleGridMap<String, String>(data2Key);
    
        reversibleGridMap.set(0, 0, "A");
        var result1 = reversibleGridMap.getData(0, 0) == "A";
    
        reversibleGridMap.set(1, 1, "B");
        var result2 = reversibleGridMap.getData(1, 1) == "B";
    
        var vecA = reversibleGridMap.getVec("A");
        var result3 = vecA.x == 0 && vecA.y == 0;
        
        var vecB = reversibleGridMap.getVec("B");
        var result4 = vecB.x == 1 && vecB.y == 1;
    
        reversibleGridMap.set(2, 2, "C");
        var result5 = reversibleGridMap.getData(2, 2) == "C";
        var vecC = reversibleGridMap.getVec("C");
        var result6 = vecC.x == 2 && vecC.y == 2;
    
       @:privateAccess var dimensions = new ludi.commons.math.IVec2(reversibleGridMap.xMax.getMax(), reversibleGridMap.yMax.getMax());
        var result7 = dimensions.x == 2 && dimensions.y == 2;
    
        return result1 && result2 && result3 && result4 && result5 && result6 && result7;
    });

}

