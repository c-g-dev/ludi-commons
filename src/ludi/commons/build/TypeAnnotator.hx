package ludi.commons.build;

import haxe.Json;
import haxe.ds.Option;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.FileSystem;

using StringTools;

class TypeAnnotator {

    public static function annotate(filePath: String): AnnotatedFileRef {
        var annotatedFilePath = createAnnotatedFile(filePath);
        annotatePackageDecl(annotatedFilePath);
        annotateImportBlock(annotatedFilePath);
        annotateTypes(annotatedFilePath);
        return collectInfo(filePath, annotatedFilePath);
    }

    static function createAnnotatedFile(filePath: String): String {
        var content = File.getContent(filePath);
        var annotatedFilePath = filePath + ".annotated.hx";
        File.saveContent(annotatedFilePath, content);
        return annotatedFilePath;
    }

    static function annotatePackageDecl(annotatedFilePath:String) {
        var content = File.getContent(annotatedFilePath);
        var lines = content.split('\n');
        var annotatedLines = new Array<String>();
        var inPackageBlock = false;

        for (line in lines) {
            if (line.trim().startsWith("package ")) {
                if (!inPackageBlock) {
                    annotatedLines.push("// BEGIN PACK");
                    inPackageBlock = true;
                }
            }

            annotatedLines.push(line);

            if (inPackageBlock && !line.trim().startsWith("package ")) {
                annotatedLines.push("// END PACK");
                inPackageBlock = false;
            }
        }

        File.saveContent(annotatedFilePath, annotatedLines.join('\n'));
    }

    static function annotateImportBlock(annotatedFilePath:String) {
        var content = File.getContent(annotatedFilePath);
        var lines = content.split('\n');
        var annotatedLines = new Array<String>();
        var inImportBlock = false;

        for (line in lines) {
            if (line.trim().startsWith("import ")) {
                if (!inImportBlock) {
                    annotatedLines.push("// BEGIN IMPORTS");
                    inImportBlock = true;
                }
            }

            if (inImportBlock && !line.trim().startsWith("import ") && !(line.trim().length <= 0) ) {
                annotatedLines.push("// END IMPORTS");
                inImportBlock = false;
            }

            annotatedLines.push(line);
        }

        File.saveContent(annotatedFilePath, annotatedLines.join('\n'));
    }

    

    static function annotateTypes(annotatedFilePath: String): String {
        var content = File.getContent(annotatedFilePath);
        var lines = content.split('\n');
        var annotatedLines = new Array<String>();

        var typePattern = ~/^(abstract class|abstract|class|typedef|enum|interface) (\w+)/;
        var typeStack = new List<{type:String, depth:Int}>();
        var currentDepth = 0;

        for (line in lines) {
            if (typePattern.match(line)) {
                var matched = typePattern.matched(0);
                var typeName = typePattern.matched(2);
                annotatedLines.push("// BEGIN TYPE: " + typeName);
                typeStack.add({type: typeName, depth: currentDepth});
            }

            annotatedLines.push(line);

            if (line.trim().indexOf("{") != -1) {
                currentDepth++;
            }
            if (line.trim().indexOf("}") != -1) {
                currentDepth--;
                if (!typeStack.isEmpty() && typeStack.last().depth == currentDepth) {
                    var endType = typeStack.pop();
                    annotatedLines.push("// END TYPE: " + endType.type);
                }
            }
        }

        File.saveContent(annotatedFilePath, annotatedLines.join('\n'));
        return annotatedFilePath;
    }

    static function collectInfo(originalFilePath: String, annotatedFilePath:String): AnnotatedFileRef {
        var content = File.getContent(annotatedFilePath);
        var lines = content.split('\n');

        var pack = "";
        var importBlock = "";
        var foundTypes = new Array<AnnotatedFileTypeInfo>();

        var inPack = false;
        var inImports = false;

        var typePattern = ~/^(abstract class|abstract|class|typedef|enum|interface) (\w+)/;
        var currentType: AnnotatedFileTypeInfo = null;

        for (line in lines) {
            if (line.startsWith("// BEGIN PACK")) {
                inPack = true;
            } else if (line.startsWith("// END PACK")) {
                inPack = false;
            } else if (inPack) {
                pack += line + "\n";
            }

            if (line.startsWith("// BEGIN IMPORTS")) {
                inImports = true;
            } else if (line.startsWith("// END IMPORTS")) {
                inImports = false;
            } else if (inImports) {
                importBlock += line + "\n";
            }

            if (line.startsWith("// BEGIN TYPE: ")) {
                var typeName = line.substr("// BEGIN TYPE: ".length);
                currentType = {typename: typeName, kind: "", extendsType: None, typeFullText: ""};
            } else if (line.startsWith("// END TYPE: ")) {
                if (currentType != null) {
                    foundTypes.push(currentType);
                    currentType = null;
                }
            } else if (currentType != null) {
                currentType.typeFullText += line + "\n";
                if (typePattern.match(line)) {
                    currentType.kind = typePattern.matched(1);
                }
            }
        }

        pack = pack.replace("package ", "").replace(";", "").trim();

        var info: AnnotatedFileInfo = {
            pack: pack,
            importBlock: importBlock.trim(),
            foundTypes: foundTypes,
            annotatedFilePath: annotatedFilePath,
            originalFilePath: originalFilePath
        };

        var updatedContent = content + "\n\n/* " + Json.stringify(info, "") + "\n*/";
        File.saveContent(annotatedFilePath, updatedContent);

        return new AnnotatedFileRef(info);
    }
}

class AnnotatedFileRef {
    public var info: AnnotatedFileInfo;

    public function new(info: AnnotatedFileInfo) {
        this.info = info;
    }

    public function deleteAnnotatedFile() {
        FileSystem.deleteFile(info.annotatedFilePath);
    }
}

typedef AnnotatedFileInfo = {
    pack: String,
    importBlock: String,
    foundTypes: Array<AnnotatedFileTypeInfo>,
    annotatedFilePath: String,
    originalFilePath: String
}

typedef AnnotatedFileTypeInfo = {
    typename: String,
    kind: String, //class/abstract class/typedef/interface/abstract/enum/etc
    extendsType: Option<String>,
    typeFullText: String
}