package cli;

import haxe.io.Path;
import sys.FileSystem;
import sys.thread.Thread;
import haxe.Exception;
import sys.io.Process;
import cli.lib.OS;

class CLI {
	static function main() {
        final args = Sys.args();
		final libdir = Sys.getCwd();
        final cwd = args.pop();
		final target = args.splice(0, 1)[0];
		switch (target) {
			case "init":
				final gitver = new Process('git -v');
				if (gitver.exitCode(true) != 0) {
					Sys.stderr().writeString('[Error] Git is required to develop Flipper apps.\n');
					Sys.exit(1);
				} else {
					Sys.println('Found ${gitver.stdout.readAll()}');
				}
				final proc = new Process('git clone https://github.com/flipperdevices/flipperzero-firmware $cwd/tmp');
				Sys.println('Cloning flipper firmware...');
				try {
					if (proc.exitCode() != 0) {
						throw 'Invalid git exit code, expected 0 got ${proc.exitCode()}';
					}
				} catch (_) {
					Sys.stderr().writeString('[Warn] running behind child processes\n');
				}
				// Sys.stderr().writeString('[Info] ' + ~/\n/gm.replace(proc.stdout.readAll().toString(), '\n[Info] '));
                var fbtp:Null<Process> = null;
				switch (OS.detect()) {
					case Win:
						fbtp = new Process('$cwd/.fzfw/fbt.cmd');
					case Linux:
						fbtp = new Process('$cwd/.fzfw/fbt');
					case Mac:
						fbtp = new Process('$cwd/.fzfw/fbt');
					case Unknown(s):
						Sys.stderr().writeString('[Error] Unknown os: $s\ncannot init\n');
						Sys.exit(2);
					default:
						throw '!!! UNMATCHED ENUM VALUE !!!';
				}
				if (fbtp == null)
					throw 'FBTP not instantiated';
				Sys.println('Initializing FBT...');
				try {
					fbtp.exitCode();
				} catch (_) {
					Sys.stderr().writeString('[Warn] running behind child processes\n');
				}
				// Sys.stderr().writeString('[Info] ' + ~/\n/gm.replace(proc.stdout.readAll().toString(), '\n[Info] '));
			case "build":
                if (!FileSystem.exists('./.fzfw/fbft')){
                    Sys.stderr().writeString('[Error] System not initialized, run "flipperhx init"');
                    Sys.exit(1);
                }

            default:
				trace(target);
		}
	}
}
