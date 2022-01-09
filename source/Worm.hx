package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

// When I fully completed PlayState, I debated whether I make this or not. I thought
// it would look cool, so I did. I was going to use an image, but I thought adding
// squares instead would make it more efficient and wouldn't take a lot of file space.
// "This is a long and sloppy file" - HaxeFlixel team
class Worm extends FlxSpriteGroup {
    public function new(X: Float = 0, Y: Float = 0, Flipped: Bool = false) {
        super(X, Y);

        add(new FlxSprite(Flipped ?   0 : 140).makeGraphic(20, 20, 0xFFFF0000));
        add(new FlxSprite(Flipped ?  20 : 120).makeGraphic(20, 20, 0xFFFFA500));
        add(new FlxSprite(Flipped ?  40 : 100).makeGraphic(20, 20, 0xFFFFFF00));
        add(new FlxSprite(Flipped ?  60 :  80).makeGraphic(20, 20, 0xFF00FF00));
        add(new FlxSprite(Flipped ?  80 :  60).makeGraphic(20, 20, 0xFF008000));
        add(new FlxSprite(Flipped ? 100 :  40).makeGraphic(20, 20, 0xFF00FFFF));
        add(new FlxSprite(Flipped ? 120 :  20).makeGraphic(20, 20, 0xFF0000FF));
        add(new FlxSprite(Flipped ? 140 :   0).makeGraphic(20, 20, 0xFF800080));
    }

    public function move() {
        if (group != null) {
            forEach(square -> {
                if (square.x == 0) {
                    switch (square.y) {
                        case 0:
                            square.x += 20;
                        case 700:
                            square.y -= 20;
                        default:
                            square.y -= 20;
                    }
                } else if (square.x == 1260) {
                    switch (square.y) {
                        case 0:
                            square.y += 20;
                        case 700:
                            square.x -= 20;
                        default:
                            square.y += 20;
                    }
                } else if (square.y == 0) {
                    square.x += 20;
                } else if (square.y == 700) {
                    square.x -= 20;
                }
            });
        }
    }
}