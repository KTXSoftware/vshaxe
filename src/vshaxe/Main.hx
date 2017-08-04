package vshaxe;

import vshaxe.commands.Commands;
import vshaxe.commands.InitProject;
import vshaxe.dependencyExplorer.DependencyExplorer;
import vshaxe.display.DisplayArguments;
import vshaxe.display.HaxeDisplayArgumentsProvider;
import vshaxe.helper.HxmlParser;
import vshaxe.helper.HaxeExecutable;
import vshaxe.server.LanguageServer;
import vshaxe.tasks.HxmlTaskProvider;

class Main {
    var api:Vshaxe;

    function init(context:ExtensionContext) {
        var displayArguments = new DisplayArguments(context);
        var haxeExecutable = new HaxeExecutable(context);
        api = {
            haxeExecutable: haxeExecutable,
            registerDisplayArgumentsProvider: displayArguments.registerProvider,
            parseHxmlToArguments: HxmlParser.parseToArgs
        };

        var server = new LanguageServer(context, haxeExecutable, displayArguments);
        new Commands(context, server);
        new InitProject(context);
        new DependencyExplorer(context, displayArguments, haxeExecutable);
        var hxmlDiscovery = new HxmlDiscovery(context);
        new HaxeDisplayArgumentsProvider(context, api, hxmlDiscovery);
        new HxmlTaskProvider(hxmlDiscovery, haxeExecutable);

        server.start();
    }

    function new(context:ExtensionContext) {
        if (!js.node.Fs.existsSync(js.node.Path.join(Vscode.workspace.rootPath, "build", "project-debug-html5.hxml"))) {
            Vscode.extensions.getExtension('ktx.kha').exports.compile("debug-html5").then(
                function (value: Dynamic){
                    init(context);
                },
                function (error: Dynamic) {

                }
            );
        }
        else {
            init(context);
        }
    }

    @:keep
    @:expose("activate")
    static function main(context:ExtensionContext) {
        return new Main(context).api;
    }
}
