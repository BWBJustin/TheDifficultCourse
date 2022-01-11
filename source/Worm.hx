package;

// When I fully completed PlayState, I debated whether I make this or not. I thought
// it would look cool, so I did. I was going to use an image, but I thought adding
// squares instead would make it more efficient and wouldn't take a lot of file space.
// "This is a long and sloppy file" - HaxeFlixel team

import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class Worm extends Sprite {
    public function new(X: Float = 0, Y: Float = 0, Flipped: Bool = false) {
        super();
        x = X;
        y = Y;

        addChild(new WormSquare(Flipped ?   0 : 140, 0, 0xFFFF0000));
        addChild(new WormSquare(Flipped ?  20 : 120, 0, 0xFFFFA500));
        addChild(new WormSquare(Flipped ?  40 : 100, 0, 0xFFFFFF00));
        addChild(new WormSquare(Flipped ?  60 :  80, 0, 0xFF00FF00));
        addChild(new WormSquare(Flipped ?  80 :  60, 0, 0xFF008000));
        addChild(new WormSquare(Flipped ? 100 :  40, 0, 0xFF00FFFF));
        addChild(new WormSquare(Flipped ? 120 :  20, 0, 0xFF0000FF));
        addChild(new WormSquare(Flipped ? 140 :   0, 0, 0xFF800080));
    }

    public function move() {
        for (i in 0...numChildren) {
            var square = getChildAt(i);
            var squareX = square.x + x;
            var squareY = square.y + y;

            if (squareX == 0) {
                switch (squareY) {
                    case 0:
                        square.x += 20;
                    case 700:
                        square.y -= 20;
                    default:
                        square.y -= 20;
                }
            } else if (squareX == 1260) {
                switch (squareY) {
                    case 0:
                        square.y += 20;
                    case 700:
                        square.x -= 20;
                    default:
                        square.y += 20;
                }
            } else if (squareY == 0)
                square.x += 20;
            else if (squareY == 700)
                square.x -= 20;
        }
    }
}

class WormSquare extends Bitmap {
    public function new(X: Float = 0, Y: Float = 0, Color: FlxColor = 0xFF000000) {
        super(new FlxSprite().makeGraphic(20, 20, Color).pixels);
        x = X;
        y = Y;
    }
}