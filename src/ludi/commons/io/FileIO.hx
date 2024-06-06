package ludi.commons.io;

import haxe.io.Path;

using StringTools;

class FileIO {
	public static function forEachFileRecursive(directory:String, pathCallback: (Path) -> Void) {
		if (sys.FileSystem.exists(directory)) {
			for (file in sys.FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);
				if (!sys.FileSystem.isDirectory(path)) {
					if (path.contains(".hx")) {
                        pathCallback(new Path(path));
                    }
				} else {
					var directory = haxe.io.Path.addTrailingSlash(path);
					forEachFileRecursive(directory, pathCallback);
				}
			}
		} else {
			trace('"$directory" does not exists');
		}
	}

	public static function forEachDirectory(directory:String, pathCallback: (Path) -> Void) {
		if (sys.FileSystem.exists(directory)) {
			for (file in sys.FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);
				if (sys.FileSystem.isDirectory(path)) {
                    pathCallback(new Path(path));
				}
			}
		} else {
			trace('"$directory" does not exists');
		}
	}	
	
}
