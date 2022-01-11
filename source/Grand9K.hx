package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class Grand9K extends FlxSpriteGroup {
    public var text(default, set): String;
    public var typedText: Bool;
    public var size: Float;
    public var typingSound: FlxSound = new FlxSound();

    public function new(X: Float, Y: Float, Text: String = "", Size: Float = 1, TypedText: Bool = false) {
        super(X, Y);

        this.size = Size;
        this.typedText = TypedText;
        this.text = Text;
    }

    function set_text(value: String) {
        clear();

        var lastSprite: FlxSprite = null;
        var lines = value.split("\n");
        for (i in 0...lines.length) {
            for (character in lines[i].split("")) {
                lastSprite = new FlxSprite(lastSprite != null ? lastSprite.x + lastSprite.width - x + 10 * size : 0, i * 90 * size);
                if (character == " ")
                    lastSprite.makeGraphic(10, 70, 0x00000000);
                else
                    lastSprite.loadGraphic("assets/images/grand9k/" + StringTools.hex(character.charCodeAt(0)).toLowerCase() + ".png");
                lastSprite.antialiasing = Game.Options.antialiasing;
                lastSprite.setGraphicSize(Std.int(lastSprite.width * size));
                lastSprite.updateHitbox();
                lastSprite.visible = !typedText;
                add(lastSprite);
            }

            lastSprite = null;
        }

        if (typedText && value != "") {
            var bullshit = 0;
            #if desktop
            typingSound.loadEmbedded(AssetPaths.dialogue__ogg);
            #else
            typingSound.loadEmbedded(AssetPaths.dialogue__mp3);
            #end
            typingSound.volume = Game.Options.sounds / 100;
            new FlxTimer().start(0.05, timer -> {
                typingSound.play(true);
                members[bullshit].visible = true;
                bullshit++;
            }, value.split("\n").join("").length);
        }

        return text = value;
    }
}
