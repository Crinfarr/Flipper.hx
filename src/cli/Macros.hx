package cli;

import haxe.io.Bytes;
import sys.io.File;
import sys.FileStat;
import sys.FileSystem;
import haxe.zip.Entry;
import haxe.ds.List;
import haxe.zip.Reader;
import haxe.io.Output;
import haxe.io.BytesBuffer;
import haxe.zip.Writer;
import haxe.zip.Tools;
import haxe.zip.Compress;
import haxe.macro.Context;
import haxe.macro.Compiler;

private class BBWrite extends Output {
	final bb:BytesBuffer;

	public function new(buffer:Null<BytesBuffer> = null) {
		bb = (buffer != null ? buffer : new BytesBuffer());
	}

	override function writeByte(c:Int) {
		bb.addByte(c);
	}

	override function write(b:haxe.io.Bytes) {
		bb.addBytes(b, bb.length, b.length);
	}

	public function getBytes() {
		return bb.getBytes();
	}
}

class Macros {
	public static macro function packDir(path:String) {
		final buf = new BBWrite();
		final zw = new Writer(buf);
		zw.write(getEntries(path));
        Context.addResource(~/\/\\/gm.split(path).pop(), buf.getBytes());
		return macro null;
	}

	private static function getEntries(dir:String):List<Entry> {
        final r = new List<Entry>();
        for (itm in FileSystem.readDirectory(dir)) {
            if (FileSystem.isDirectory('$dir/$itm'))
                getEntries('$dir/$itm').map(r.push);
            else {
				final content:Bytes = File.getBytes('$dir/$itm');
                r.push({
                    fileName: '$dir/$itm',
                    extraFields: null,
                    crc32: null,
                    data: content,
                    dataSize: content.length,
                    compressed: true,
                    fileTime: Date.now(),
                    fileSize: content.length
                });
            }
        }
        return r;
    }
}
