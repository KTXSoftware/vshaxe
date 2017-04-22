package vshaxe;

import js.node.Path;
import Vscode.*;
import vscode.*;

class Main {
    function new(context:ExtensionContext) {
        new InitProject(context);
        var server = new LanguageServer(context);
        new Commands(context, server);

        setLanguageConfiguration();
        server.start();
    }

    function setLanguageConfiguration() {
        var defaultWordPattern = "(-?\\d*\\.\\d\\w*)|([^\\`\\~\\!\\@\\#\\%\\^\\&\\*\\(\\)\\-\\=\\+\\[\\{\\]\\}\\\\\\|\\;\\:\\'\\\"\\,\\.\\<\\>\\/\\?\\s]+)";
        var wordPattern = defaultWordPattern + "|(@:\\w*)"; // metadata
        languages.setLanguageConfiguration("Haxe", {wordPattern: new js.RegExp(wordPattern)});
    }

    static function findKha():String {
        var khaapi = Vscode.extensions.getExtension('ktx.kha').exports;
        return khaapi.findKha();
    }

    @:keep
    @:expose("activate")
    static function main(context:ExtensionContext) {
        new Main(context);
    }
}
