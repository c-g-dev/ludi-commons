package ludi.commons.build;

import ludi.commons.build.TypeAnnotator.AnnotatedFileRef;
import haxe.io.Path;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.FileSystem;

using StringTools;

class SplitFile {
    public static function main(filePathOriginal: String) {
        var annotatedInfo: AnnotatedFileRef = TypeAnnotator.annotate(filePathOriginal);

        var outputDir = Path.directory(filePathOriginal) + "/split/";
        if (!FileSystem.exists(outputDir)) {
            FileSystem.createDirectory(outputDir);
        }

        var packStatement = (annotatedInfo.info.pack == "") ? "" : annotatedInfo.info.pack + "\n";
        packStatement = "package " + packStatement.trim() + ".split;";
        var importStatements = (annotatedInfo.info.importBlock == "") ? "" : annotatedInfo.info.importBlock + "\n";

        for (typeInfo in annotatedInfo.info.foundTypes) {
            var typePath = outputDir + typeInfo.typename + ".hx";
            var typeContent = packStatement + "\n\n" + importStatements + "\n" + typeInfo.typeFullText;
            trace("Created " + typePath);
            File.saveContent(typePath, typeContent);
        }

        annotatedInfo.deleteAnnotatedFile();
    }
}