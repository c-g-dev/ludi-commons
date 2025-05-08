package ludi.commons.io;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;

class LudiZip
{
    var entries : Array<LudiZipEntry>;

    public function new()
    {
        entries = [];
    }


    public function addFile(name:String, data:Bytes):Void
    {
        if (getFile(name) != null) throw 'File "$name" already exists inside this ZIP';

        entries.push(LudiZipEngine.makeEntry(name, data));
    }

    public function getFile(name:String):Bytes
    {
        for (e in entries) if (e.name == name) return e.data;
        return null;
    }

    public function forEachFile(cb:(name:String, data:Bytes)->Void):Void
    {
        for (e in entries) cb(e.name, e.data);
    }

    public function toBytes():Bytes
    {
        return LudiZipEngine.build(entries);
    }

    public static function fromBytes(b:Bytes):LudiZip
    {
        var z = new LudiZip();
        z.entries = LudiZipEngine.parse(b);
        return z;
    }
}


class LudiZipEntry
{
    public var name   : String;
    public var data   : Bytes;
    public var crc32  : Int;
    public var offset : Int;    

    public function new(name:String, data:Bytes, crc32:Int, offset:Int = 0)
    {
        this.name   = name;
        this.data   = data;
        this.crc32  = crc32;
        this.offset = offset;
    }
}

class LudiZipEngine
{
    public static inline function makeEntry(name:String, data:Bytes):LudiZipEntry
    {
        return new LudiZipEntry(name, data, crc32(data));
    }

    public static function build(entries:Array<LudiZipEntry>):Bytes
    {
        var out = new BytesBuffer();

        for (e in entries)
        {
            e.offset = out.length;
            writeLocalHeader(out, e);
            out.add(e.data);
        }

        var cdStart = out.length;
        for (e in entries) writeCentralHeader(out, e);
        var cdSize = out.length - cdStart;

        writeEOCD(out, entries.length, cdSize, cdStart);

        return out.getBytes();
    }

    public static function parse(bytes:Bytes):Array<LudiZipEntry>
    {
        var out = new Array<LudiZipEntry>();

        var sig = 0x06054b50;
        var maxSearch = 0xFFFF + 22;           
        var p = bytes.length - 4;
        var bottom = bytes.length - maxSearch;
        if (bottom < 0) bottom = 0;

        var eocdPos = -1;
        while (p >= bottom)
        {
            if (bytes.getInt32(p) == sig) { eocdPos = p; break; }
            p--;
        }
        if (eocdPos == -1) throw "EOCD record not found – not a ZIP file";

        var r = new LEReader(bytes, eocdPos + 4);
        r.skip(2);                      
        r.skip(2);              
        var entryCount = r.readUI16();
        r.skip(2);                      
        var cdSize  = r.readUI32();
        var cdOff   = r.readUI32();
        r.skip(2);         

        var pos = cdOff;
        for (i in 0...entryCount)
        {
            if (bytes.getInt32(pos) != 0x02014b50)
                throw "Central directory corrupted";

            var hdr = new LEReader(bytes, pos + 28); 
            var nameLen  = hdr.readUI16();
            var extraLen = hdr.readUI16();
            var commLen  = hdr.readUI16();
            hdr.skip(8);         
            var lfhOff   = hdr.readUI32();

            var name = bytes.getString(pos + 46, nameLen);

            var lfh = new LEReader(bytes, lfhOff + 18);
            var compSize = lfh.readUI32();  
            var uncomp   = lfh.readUI32();
            var fnameLen = lfh.readUI16();
            var extraL   = lfh.readUI16();

            var dataPos = lfhOff + 30 + fnameLen + extraL;
            var data = bytes.sub(dataPos, uncomp);

            var crc = bytes.getInt32(lfhOff + 14);
            out.push(new LudiZipEntry(name, data, crc));
            pos += 46 + nameLen + extraLen + commLen;
        }

        return out;
    }

    static inline function writeLocalHeader(b:BytesBuffer, e:LudiZipEntry):Void
    {
        ui32(b, 0x04034b50);               
        ui16(b, 20);                       
        ui16(b, 0);                        
        ui16(b, 0);                        
        ui16(b, 0); ui16(b, 0);            
        ui32(b, e.crc32);
        ui32(b, e.data.length);
        ui32(b, e.data.length);
        ui16(b, e.name.length);
        ui16(b, 0);                        
        b.addString(e.name);               
    }

    static inline function writeCentralHeader(b:BytesBuffer, e:LudiZipEntry):Void
    {
        ui32(b, 0x02014b50);               
        ui16(b, 20);                       
        ui16(b, 20);                       
        ui16(b, 0); ui16(b, 0);            
        ui16(b, 0); ui16(b, 0);            
        ui32(b, e.crc32);
        ui32(b, e.data.length);
        ui32(b, e.data.length);
        ui16(b, e.name.length);
        ui16(b, 0); ui16(b, 0);            
        ui16(b, 0);                        
        ui16(b, 0);                        
        ui32(b, 0);                        
        ui32(b, e.offset);                 
        b.addString(e.name);
    }

    static inline function writeEOCD(b:BytesBuffer, files:Int, cdSize:Int, cdOff:Int):Void
    {
        ui32(b, 0x06054b50);               
        ui16(b, 0); ui16(b, 0);            
        ui16(b, files); ui16(b, files);    
        ui32(b, cdSize);
        ui32(b, cdOff);
        ui16(b, 0);                        
    }

    static inline function ui16(b:BytesBuffer, v:Int) {
        b.addByte( v & 0xFF );
        b.addByte( (v >> 8) & 0xFF );
    }
    static inline function ui32(b:BytesBuffer, v:Int) {
        b.addByte(  v & 0xFF );
        b.addByte( (v >> 8 ) & 0xFF );
        b.addByte( (v >> 16) & 0xFF );
        b.addByte( (v >> 24) & 0xFF );
    }

    public static inline function crc32(bytes:Bytes):Int
    {
        var c = 0xFFFFFFFF;
        for (i in 0...bytes.length)
            c = crcTable[ (c ^ bytes.get(i)) & 0xFF ] ^ (c >>> 8);
        return (c ^ 0xFFFFFFFF) >>> 0;
    }

    static final crcTable:Array<Int> = buildCRCTable();
    static function buildCRCTable():Array<Int>
    {
        var t = new Array<Int>();
        for (i in 0...256)
        {
            var c = i;
            for (j in 0...8)
                c = (c & 1) == 1 ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
            t.push(c);
        }
        return t;
    }
}

class LEReader
{
    public var pos:Int;
    final bytes:Bytes;

    public inline function new(b:Bytes, p:Int = 0) { bytes = b; pos = p; }

    public inline function readUI16():Int
    {
        var v = bytes.get(pos) | (bytes.get(pos + 1) << 8);
        pos += 2;
        return v & 0xFFFF;
    }

    public inline function readUI32():Int
    {
        var v =  bytes.get(pos)        |
                (bytes.get(pos+1) << 8)|
                (bytes.get(pos+2) <<16)|
                (bytes.get(pos+3) <<24);
        pos += 4;
        return v >>> 0;
    }

    public inline function skip(n:Int):Void pos += n;
}
