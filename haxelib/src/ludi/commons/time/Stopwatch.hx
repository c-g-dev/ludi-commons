package ludi.commons.time;

class Stopwatch {
	var startTime: Float;
	var endTime: Float;
	
	public function new() {}
	
	public function start() {
		startTime = Sys.time();
	}

	public function stop(){
		endTime = Sys.time();
	}

	public function getElapsedMillis(){
		return endTime - startTime;
	}

	public function reset(){
		startTime = 0;
		endTime = 0;
	}
}