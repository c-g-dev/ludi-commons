package ludi.commons.build;

import ludi.commons.io.FileIO;

class FixPackages {
    public static function fix(directory: String, srcPath: String = "./src") {
        FileIO.forEachFileRecursive(directory, (path) -> {
            var e = new HxFileEditor(path.toString());
            e.fixPackage(srcPath);
            e.saveChanges();
        });
    }
}