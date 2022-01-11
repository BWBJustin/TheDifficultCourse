import flixel.FlxG;
import flixel.FlxState;
import haxe.Http;
#if desktop
import lime.app.Application;
#end

class StartupState extends FlxState {
    override public function create() {
        super.create();

        Game.initSave();

        var http = new Http("https://raw.githubusercontent.com/BWBJustin/TheDifficultCourse/master/version.txt");
        http.onData = data -> {
            if (data != Game.version)
                Game.outdated = true;
        }
        
        http.request();

        FlxG.mouse.visible = false;
        
        #if desktop
        RichPresence.initialize();
        Application.current.onExit.add(code -> RichPresence.shutdown());
        #end

        #if !SKIP_GAME
        #if desktop
        FlxG.sound.playMusic(AssetPaths.menuTheme__ogg, Game.Options.music / 100);
        #else
        FlxG.sound.playMusic(AssetPaths.menuTheme__mp3, Game.Options.music / 100);
        #end
        #end

        #if SKIP_MENU
        Main.worm1.visible = false;
        Main.worm2.visible = false;
        FlxG.switchState(new PlayState());
        #elseif SKIP_GAME
        Main.worm1.visible = false;
        Main.worm2.visible = false;
        FlxG.switchState(new WinState());
        #else
        FlxG.switchState(new MainMenuState());
        #end
    }
}