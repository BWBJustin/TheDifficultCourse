package;

class OptionsSubState extends MenuSubState {
    var menuItemNames: Array<Array<Dynamic>> = [ // Menu name, internal name, is number, min, max
        ["FPS Counter: ", "fpsCounter", false],
        ["Antialiasing: ", "antialiasing", false],
        ["Music: ", "music", true, 0, 100],
        ["Sounds: ", "sounds", true, 0, 100]
        #if desktop
       ,["FPS Cap: ", "fpsCap", true, 60, 240]
        #end
    ];

    public function new() {
        super();

        for (i in 0...menuItemNames.length) {
            var menuItem = new Grand9K(0, i * 90 + 170);
            // Could've just used ? and : but hxcpp would have a stroke if I did
            if (menuItemNames[i][2])
                menuItem.text = menuItemNames[i][0] + cast(Reflect.getProperty(Game.Options, menuItemNames[i][1]), Int);
            else
                menuItem.text = menuItemNames[i][0] + (cast(Reflect.getProperty(Game.Options, menuItemNames[i][1]), Bool) ? "On" : "Off");
            menuItem.screenCenter(X);
            menuItems.add(menuItem);
        }

        changeSelection();
    }

    var holdTime: Float = 0;
    override public function update(elapsed: Float) {
        super.update(elapsed);

        if (Game.Controls.BACK) {
            PauseSubState.fromOptions = true;
            close();
        }

        if (Game.Controls.ENTER_P && !menuItemNames[curSelected][2]) {
            var option = Reflect.getProperty(Game.Options, menuItemNames[curSelected][1]);
            var menuItem = menuItems.members[curSelected];

            Reflect.setProperty(Game.Options, menuItemNames[curSelected][1], !option);
            menuItem.text = menuItemNames[curSelected][0] + (!option ? "On" : "Off");
            menuItem.screenCenter(X);
        }

        if (menuItemNames[curSelected][2]) {
            var option = Reflect.getProperty(Game.Options, menuItemNames[curSelected][1]);
            var menuItem = menuItems.members[curSelected];
            var newValue: Int;
            if (holdTime < 0.5) {
                if (Game.Controls.LEFT_P) {
                    var min = menuItemNames[curSelected][3];
                    var max = menuItemNames[curSelected][4];

                    newValue = option - 1;
                    newValue = newValue < min ? min : newValue > max ? max : newValue;
                    Reflect.setProperty(Game.Options, menuItemNames[curSelected][1], newValue);
                    menuItem.text = menuItemNames[curSelected][0] + newValue;
                    menuItem.screenCenter(X);
                }

                if (Game.Controls.RIGHT_P) {
                    var min = menuItemNames[curSelected][3];
                    var max = menuItemNames[curSelected][4];

                    newValue = option + 1;
                    newValue = newValue < min ? min : newValue > max ? max : newValue;
                    Reflect.setProperty(Game.Options, menuItemNames[curSelected][1], newValue);
                    menuItem.text = menuItemNames[curSelected][0] + newValue;
                    menuItem.screenCenter(X);
                }

                if (Game.Controls.LEFT_R || Game.Controls.RIGHT_R)
                    holdTime = 0;

                if (Game.Controls.LEFT || Game.Controls.RIGHT)
                    holdTime += elapsed;
            } else {
                if (Game.Controls.LEFT) {
                    var min = menuItemNames[curSelected][3];
                    var max = menuItemNames[curSelected][4];

                    newValue = option - 1;
                    newValue = newValue < min ? min : newValue > max ? max : newValue;
                    Reflect.setProperty(Game.Options, menuItemNames[curSelected][1], newValue);
                    menuItem.text = menuItemNames[curSelected][0] + newValue;
                    menuItem.screenCenter(X);
                }

                if (Game.Controls.RIGHT) {
                    var min = menuItemNames[curSelected][3];
                    var max = menuItemNames[curSelected][4];

                    newValue = option + 1;
                    newValue = newValue < min ? min : newValue > max ? max : newValue;
                    Reflect.setProperty(Game.Options, menuItemNames[curSelected][1], newValue);
                    menuItem.text = menuItemNames[curSelected][0] + newValue;
                    menuItem.screenCenter(X);
                }

                if (Game.Controls.LEFT_R || Game.Controls.RIGHT_R)
                    holdTime = 0;
            }
        }
    }
}