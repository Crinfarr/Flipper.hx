package cli.lib;

import haxe.io.Bytes;

private enum OSType {
    Win;
    Mac;
    Linux;
    Unknown(s:String);
}


class OS {
    public static function detect(osstr:Null<String> = null):OSType {
        switch(osstr!=null ? osstr : Sys.systemName()) {
            case "Windows":
                return Win;
            case "Linux":
                return Linux;
            case "Mac":
                return Mac;
            default:
                return Unknown(Sys.systemName()+' [${Bytes.ofString(Sys.systemName()).toHex()}]');
        }
    }
}