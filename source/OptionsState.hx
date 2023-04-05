package;

import flixel.FlxG;

class OptionsState extends MenuState
{
    var menuItemNames: Array<Array<Dynamic>> = [ // Menu name, internal name, is number, min, max
        ["FPS Counter: ", "fpsCounter", false],
        ["Antialiasing: ", "antialiasing", false],
        ["Music: ", "music", true, 0, 100],
        ["Sounds: ", "sounds", true, 0, 100]
        #if desktop
       ,["FPS Cap: ", "fpsCap", true, 60, 240]
        #end
    ];

    override public function create()
    {
        super.create();

        for (i in 0...menuItemNames.length) {
            var menuItem = new Grand9K(0, i * 90 + 170);
            var menuItemName = menuItemNames[i];
            menuItem.text = menuItemName[0] + menuItemName[2] ?
                Std.string(Reflect.getProperty(Game.Options, menuItemName[1])) :
                cast(Reflect.getProperty(Game.Options, menuItemName[1]), Bool) ? "On" : "Off";
            menuItem.screenCenter(X);
            menuItems.add(menuItem);
        }

        changeSelection();
    }

    var holdTime: Float = 0;
    override public function update(elapsed: Float)
    {
        super.update(elapsed);

        if (Game.Controls.BACK)
            FlxG.switchState(new MainMenuState());

        var menuItemName = menuItemNames[curSelected];
        var menuItem = menuItems.members[curSelected];
        if (menuItemName[2]) {
            if (holdTime < 0.5 ? (Game.Controls.LEFT_P || Game.Controls.RIGHT_P) : (Game.Controls.LEFT || Game.Controls.RIGHT)) {
                var newValue = Std.int(Math.max(menuItemName[3], Math.min(Reflect.getProperty(Game.Options, menuItemName[1]) + 
                    ((holdTime < 0.5 ? Game.Controls.RIGHT_P : Game.Controls.RIGHT) ? 1 : -1), menuItemName[4])));
                Reflect.setProperty(Game.Options, menuItemName[1], newValue);
                menuItem.text = menuItemName[0] + newValue;
                menuItem.screenCenter(X);
            }

            if (Game.Controls.LEFT_R || Game.Controls.RIGHT_R)
                holdTime = 0;
            if (Game.Controls.LEFT || Game.Controls.RIGHT)
                holdTime += elapsed;
        } else if (Game.Controls.ENTER_P) {
            var option = Reflect.getProperty(Game.Options, menuItemName[1]);
            Reflect.setProperty(Game.Options, menuItemName[1], !option);
            menuItem.text = menuItemName[0] + (!option ? "On" : "Off");
            menuItem.screenCenter(X);
        }
    }
}
