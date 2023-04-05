package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
    public static var fpsCounter: FPS;
    public static var instance: Main;
    public static var version: Game.Version;
    public static var worm1: Worm;
    public static var worm2: Worm;

    public function new()
    {
        super();
        instance = this;
        
        addChild(new FlxGame(1280, 720, StartupState, 60, 60, true));

        worm1 = new Worm(0, 0, false);
        addChild(worm1);
        worm2 = new Worm(1120, 700, true);
        addChild(worm2);
        
        fpsCounter = new FPS(10, 10, 0xFFFFFF);
        fpsCounter.visible = Game.Options.fpsCounter;
        addChild(fpsCounter);
    }

    public static function resetWorms() {
        worm1 = new Worm(0, 0, false);
        instance.addChild(worm1);
        worm2 = new Worm(1120, 700, true);
        instance.addChild(worm2);
        instance.addChild(fpsCounter);
        instance.addChild(version);
    }
}
