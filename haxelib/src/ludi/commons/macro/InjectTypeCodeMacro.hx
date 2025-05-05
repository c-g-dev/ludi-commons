package ludi.commons.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#end


 class InjectTypeCodeMacro
 {
     #if macro
     public static macro function build() : Array<Field>
     {
        
         if (!hasField(fields, "typecode"))
         {
             var fqName = getFullyQualifiedName();
             fields.push({
                 name   : "typecode",
                 access : [APublic],
                 kind   : FVar(
                             macro : TypeCode,
                             macro new TypeCode($v{fqName})
                          ),
                 pos    : Context.currentPos()
             });
         }
 
      
         var localClassRef = Context.getLocalClass(); 
 
         if (localClassRef != null)
             addRequiresTypeCode(localClassRef);
 
         return fields;
     }

     private static function getFullyQualifiedName() : String
     {
         var c = Context.getLocalClass().get();
         return (c.pack.length > 0) ? c.pack.join(".") + "." + c.name : c.name;
     }
 
   
     private static function hasField(fields:Array<Field>, name:String):Bool
     {
         for (f in fields)
             if (f.name == name) return true;
         return false;
     }
 
     private static function addRequiresTypeCode(clRef:Ref<ClassType>):Void
     {
         var cl   = clRef.get();
 
         var reqRef:Ref<ClassType> = switch (Context.getType("ludi.commons.TypeCode.RequiresTypeCode"))
         {
             case TInst(r, _): r;
             default:
                 Context.error("RequiresTypeCode must be a class / interface", Context.currentPos());
         }

         for (inf in cl.interfaces)
             if (inf.t == reqRef) return;
 
         // otherwise add it
         cl.interfaces.push({ t: reqRef, params: [] });
     }
     #end
 }