package ludi.commons.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import StringTools;

@:noCompletion
var hxmlCache:{path:String, content:Array<String>, modified:Float};

@:noCompletion
function findHxmlFile():String {
    var dir = FileSystem.fullPath(".");
    while (true) {
        var hxmlFile = dir + "/castle.hxml";
        if (FileSystem.exists(hxmlFile)) {
            return hxmlFile;
        }
        var parent = FileSystem.fullPath(dir + "/..");
        if (parent == dir) {
            // Reached root
            return null;
        }
        dir = parent;
    }
}
#end

macro function forceInclude() {
    #if macro
     // Get the caller's package
     var cls = Context.getLocalClass();
     var pack = cls.get().pack;
     
     if(StringTools.startsWith(pack[pack.length - 1], "_")){
        var newClass = pack[pack.length - 1].substr(1, pack[pack.length - 1].length);
        pack[pack.length - 1] = newClass;
     }

     var pkg = pack.join(".");

     var hxmlPath = findHxmlFile();
     if (hxmlPath == null) {
         Context.error("Could not find .hxml file in project folder or parent folders", Context.currentPos());
         return macro null;
     }

     var stat = FileSystem.stat(hxmlPath);
     if (hxmlCache == null || hxmlCache.path != hxmlPath || hxmlCache.modified < stat.mtime.getTime()) {
         hxmlCache = {
             path: hxmlPath,
             content: File.getContent(hxmlPath).split("\n"),
             modified: stat.mtime.getTime()
         };
     }

     var macroLine = '--macro include("' + pkg + '")';

     var found = false;
     for (line in hxmlCache.content) {
         var trimmed = StringTools.trim(line);
         if (trimmed == macroLine) {
             found = true;
             break;
         }
     }

     if (!found) {
         try {
             var fo = File.append(hxmlPath/*, "\n" + macroLine + "\n"*/);
             fo.writeString("\n" + macroLine + "\n");
             fo.close();
             hxmlCache.content.push(macroLine);
             hxmlCache.modified = FileSystem.stat(hxmlPath).mtime.getTime();
             Context.warning("Added macro include line to .hxml: " + macroLine, Context.currentPos());
         } catch (e:Dynamic) {
             Context.error("Failed to write to .hxml file: " + Std.string(e), Context.currentPos());
         }
     } else {
         // Do nothing
     }
     #end
     return macro null;
}
