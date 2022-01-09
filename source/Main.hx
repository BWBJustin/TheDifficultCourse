package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
    public static var fpsCounter: FPS;

    public function new()
    {
        super();
        
        addChild(new FlxGame(1280, 720, StartupState, 1, 60, 60, true));
        
        fpsCounter = new FPS(10, 10, 0xFFFFFF);
        fpsCounter.visible = Game.Options.fpsCounter;
        addChild(fpsCounter);
    }
}
