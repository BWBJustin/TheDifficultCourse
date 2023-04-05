package;

// When I fully completed PlayState, I debated whether I make this or not. I thought
// it would look cool, so I did. I was going to use an image, but I thought adding
// squares instead would make it more efficient and wouldn't take a lot of file space.
// "It is a long and sloppy file" - HaxeFlixel team

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class Worm extends Sprite {
    public static var colors = [
        0xFFFF0000,
        0xFFFFA500,
        0xFFFFFF00,
        0xFF00FF00,
        0xFF008000,
        0xFF00FFFF,
        0xFF0000FF,
        0xFF800080
    ];

    public function new(X: Float = 0, Y: Float = 0, Flipped: Bool = false) {
        super();
        x = X;
        y = Y;

        for (i in 0...colors.length) {
            var square = new Bitmap(new BitmapData(20, 20, false, colors[i]));
            square.x = (i ^ (Flipped ? 0 : colors.length - 1)) * 20;
            addChild(square);
        }
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