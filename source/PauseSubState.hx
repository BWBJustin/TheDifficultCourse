package;

import flixel.FlxG;
import haxe.Timer;

class PauseSubState extends MenuSubState {
    public static var toOptions: Bool;
    public static var fromOptions: Bool;

    var menuItemNames: Array<String> = ["Resume", "Restart", "Options", "Quit"];

    public function new() {
        super();

        for (i in 0...menuItemNames.length) {
            var menuItem = new Grand9K(0, i * 90 + 170, menuItemNames[i]);
            menuItem.screenCenter(X);
            menuItems.add(menuItem);
        }

        changeSelection();
    }

    override public function update(elapsed: Float) {
        super.update(elapsed);

        if (Game.Controls.BACK)
            close();

        if (Game.Controls.ENTER_P) {
            switch (curSelected) {
                case 0:
                    close();
                case 1:
                    PlayState.levelIndex = 1;
                    PlayState.started = Std.int(Timer.stamp());
                    FlxG.switchState(new PlayState());
                case 2:
                    toOptions = true;
                    close();
                case 3:
                    PlayState.levelIndex = 1;
                    Main.resetWorms();
                    Main.worm1.visible = true;
                    Main.worm2.visible = true;
                    FlxG.switchState(new MainMenuState());
            }
        }
    }
}