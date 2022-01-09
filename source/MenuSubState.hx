package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;

class MenuSubState extends FlxSubState {
    var curSelected: Int = 0;
    var menuItems: FlxTypedGroup<Grand9K>;

    public function new() {
        super(0x80000000);

        menuItems = new FlxTypedGroup<Grand9K>();
        add(menuItems);
    }

    override public function update(elapsed: Float) {
        super.update(elapsed);

        if (Game.Controls.UP_P)
            changeSelection(-1);

        if (Game.Controls.DOWN_P)
            changeSelection(1);
    }

    function changeSelection(change: Int = 0) {
        curSelected += change;

        if (curSelected < 0)
            curSelected = menuItems.length - 1;
        if (curSelected >= menuItems.length)
            curSelected = 0;

        menuItems.forEach(menuItem -> {
            if (menuItem.ID == menuItems.members[curSelected].ID)
                menuItem.color = 0xFFFFFFFF;
            else
                menuItem.color = 0xFF404040;
        });
    }
}