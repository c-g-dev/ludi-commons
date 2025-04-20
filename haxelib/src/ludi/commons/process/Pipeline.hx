package ludi.commons.process;

class Pipeline {
	var items:Array<Dynamic> = [];
	var steps:Array<PipelineStep> = [];
	var lastItem:Dynamic;

	public function new(items:Array<Dynamic>) {
		this.items = items;
		this.lastItem = items;
	}

	public function map(func:(e:Dynamic) -> Dynamic):Pipeline {
        steps.push(new PipelineMapStep(func));
		return this;
	}

	public function filter(func:(e:Dynamic) -> Dynamic):Pipeline {
        steps.push(new PipelineFilterStep(func));
		return this;
	}

	public function run():Void {
		for (eachItemInSteps in steps) {
			lastItem = eachItemInSteps.execute(lastItem);
		}
	}
}

abstract class PipelineStep {
	public abstract function execute(item:Dynamic):Dynamic;
}

class PipelineMapStep extends PipelineStep {
	var callback:(Dynamic) -> Dynamic;

	public function new(callback:(Dynamic) -> Dynamic) {
		this.callback = callback;
	}

	public function execute(item:Dynamic):Dynamic {
        var result = [];
		var castedI:Array<Dynamic> = cast item;
        for(eachItem in castedI){
            result.push(callback(eachItem));
        }
        return result;
	}
}

class PipelineFilterStep extends PipelineStep {
	var callback:(Dynamic) -> Dynamic;

	public function new(callback:(Dynamic) -> Dynamic) {
		this.callback = callback;
	}

	public function execute(item:Dynamic):Dynamic {
        var result = [];
		var castedI:Array<Dynamic> = cast item;
        for(eachItem in castedI){
			if(callback(eachItem)){
				result.push(eachItem);
			}
        }
        return result;
	}
}

