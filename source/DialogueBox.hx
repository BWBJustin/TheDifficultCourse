package;

import lime.utils.Assets;
import haxe.Json;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class DialogueBox extends FlxSpriteGroup {
    public var box: FlxSprite;
    public var portrait: FlxSprite;
    public var text: Grand9K;
    public var event: Bool;

    var data: DialogueData;

    public function new(X: Float, Y: Float, Data: DialogueData) {
        super(X, Y);
        data = Data;
        event = data.text.toUpperCase() == "[EVENT]";

        if (!event)
            add(new FlxSprite().makeGraphic(1280, 720, 0x99FFFFFF));

        var speaking = Json.parse(Assets.getText("assets/data/characters/" + data.speaking + ".json"));
        portrait = new FlxSprite(speaking.x, speaking.y, "assets/images/" + speaking.image + ".png");
        portrait.antialiasing = Game.Options.antialiasing;
        if (!event)
            add(portrait);

        box = new FlxSprite(0, 420).makeGraphic(1280, 300, 0xFFFFFFFF);
        if (!event)
            add(box);

        text = new Grand9K(50, 470, data.text, 1, !event);
        text.color = 0xFF000000;
        if (!event)
            add(text);
    }
}

typedef DialogueData = {
    speaking: String,
    text: String
}

typedef DialogueCharacter = {
    x: Int,
    y: Int,
    image: String
}