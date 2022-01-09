package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class Player extends FlxSprite {
    public var movable: Bool = true;
    public var dead: Bool = false;
    public var ending: Bool = false;

    public function new(X: Float, Y: Float) {
        super(X, Y);
        loadGraphic(AssetPaths.player__png);

        antialiasing = Game.Options.antialiasing;
    }

    public function killPlayer(callback: FlxTween -> Void) {
        dead = true;
        FlxTween.tween(this, { alpha: 0 }, 0.5, { onComplete: callback });
    }

    override public function update(elapsed: Float) {
        super.update(elapsed);

        velocity.set(0, 0);

        if (!dead && !ending && movable) {
            if (Game.Controls.LEFT)
                velocity.x -= 120;
            if (Game.Controls.RIGHT)
                velocity.x += 120;
            if (Game.Controls.UP)
                velocity.y -= 120;
            if (Game.Controls.DOWN)
                velocity.y += 120;
        }
    }
}