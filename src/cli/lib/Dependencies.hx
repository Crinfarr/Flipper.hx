package cli.lib;

import sys.Http;
import sys.io.Process;

typedef DepStatus = {

}

class Dependencies {
    public var gitInvoke:String;
    private function new() {
    
    }

    public static function autocheck(verbose:Bool=false):Dependencies {
        final deps = new Dependencies();
        if (new Process('git -v').exitCode(true) != 0)
            null;
        return deps;
    }
}