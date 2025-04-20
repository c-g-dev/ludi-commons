package ludi.commons.build;

using StringTools;

class HxFileEditor {
    var fileContent: String;
    var filepath: String;
    public function new(filepath: String) {
        this.filepath = filepath;
        this.fileContent = sys.io.File.getContent(filepath);
    }

    public function fixPackage(srcPath: String) {
        var expectedPack = inferPackageFromPath(srcPath);
        changePackage(expectedPack);
    }

    private function inferPackageFromPath(srcPath: String): String {
        var relativePath = filepath.substring(srcPath.length + 1);
        var pathParts = relativePath.split('/');
        pathParts.pop();
        return pathParts.join('.');
    }

    public function changePackage(newPack: String) {
        var lines = fileContent.split('\n');
        if (lines.length > 0 && lines[0].startsWith('package ')) {
            lines[0] = 'package ' + newPack + ';';
        } else {
            lines.unshift('package ' + newPack + ';');
        }
        fileContent = lines.join('\n');
    }

    public function saveChanges() {
        sys.io.File.saveContent(filepath, fileContent);
    }
}