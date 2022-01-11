package;

import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Timer;
import openfl.display.Bitmap;

class MainMenuState extends MenuState
{
    var chooseGamemode(default, set): Bool = false;

    override public function create()
    {
        super.create();

        if (Main.version == null) {
            Main.version = new Game.Version(5, 680);
            Main.instance.addChild(Main.version);
        } else
            Main.version.visible = true;

        var logo = new FlxSprite(0, 26).loadGraphic(AssetPaths.logo__png);
        logo.antialiasing = Game.Options.antialiasing;
        logo.screenCenter(X);
        add(logo);

        reloadMenuItems(["Play Game", "Options", "Credits"]);
        changeSelection();
    }

    override public function update(elapsed: Float)
    {
        super.update(elapsed);

        if (Game.Controls.BACK && chooseGamemode)
            chooseGamemode = false;

        if (Game.Controls.ENTER_P) {
            if (chooseGamemode) {
                switch (curSelected) {
                    case 0:
                        PlayState.challenge = false;
                    case 1:
                        PlayState.challenge = true;
                }
                PlayState.started = Std.int(Timer.stamp());
                FlxG.switchState(new PlayState());
            } else {
                switch (curSelected) {
                    case 0:
                        chooseGamemode = true;
                    case 1:
                        FlxG.switchState(new OptionsState());
                    case 2:
                        FlxG.switchState(new CreditsState());
                }
            }
        }
    }

    function reloadMenuItems(itemNames: Array<String>) {
        menuItems.clear();

        for (i in 0...itemNames.length) {
            var menuItem = new Grand9K(0, i * 90 + 360, itemNames[i]);
            menuItem.color = curSelected == i ? 0xFFFFFFFF : 0xFF808080;
            menuItem.screenCenter(X);
            menuItems.add(menuItem);
        }
    }

    function set_chooseGamemode(value: Bool) {
        curSelected = 0;
        reloadMenuItems(value ? ["Normal Mode", "Challenge Mode"] : ["Play Game", "Options", "Credits"]);

        return chooseGamemode = value;
    }
}
