package;

import flixel.FlxG;

class CreditsState extends MenuState
{
    var menuItemNames: Array<String> = [
        "Developer", "BWBJustin",
        "Original Game", "Daxylitz",
        "Menu Theme", "Raigon50",
        "Ending Song", "JPB"
    ];

    override public function create()
    {
        super.create();

        for (i in 0...menuItemNames.length) {
            var menuItem = new Grand9K(0, i * 90 + 25, menuItemNames[i], i % 2 == 0 ? 0.5 : 1);
            menuItem.screenCenter(X);
            if (i % 2 == 1) {
                menuItem.y -= 45;
                menuItems.add(menuItem);
            } else {
                menuItem.color = 0xFF808080;
                add(menuItem);
            }
        }

        changeSelection();
    }

    override public function update(elapsed: Float)
    {
        super.update(elapsed);

        if (Game.Controls.BACK)
            FlxG.switchState(new MainMenuState());

        if (Game.Controls.ENTER_P) {
            switch (curSelected) {
                case 0:
                    Game.openURL("https://www.youtube.com/c/BWBJustin");
                case 1:
                    Game.openURL("https://www.youtube.com/c/Daxylitzviansaw");
                case 2:
                    Game.openURL("https://www.newgrounds.com/audio/listen/288505");
                case 3:
                    Game.openURL("https://youtu.be/9yrKfWJgDek");
            }
        }
    }
}
