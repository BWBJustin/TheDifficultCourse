package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import haxe.Timer;

class WinState extends FlxState {
    var winText: Grand9K;
    var prizeText: Grand9K;
    var timeText: Grand9K;
    var prize: FlxSprite;

    override public function create() {
        super.create();

        winText = new Grand9K(0, -200, "You win!");
        winText.screenCenter(X);
        add(winText);

        prizeText = new Grand9K(0, 200, PlayState.challenge ? "Press SPACE or ENTER to claim prize" : "Complete on challenge mode to claim prize", 0.5);
        prizeText.visible = false;
        prizeText.screenCenter(X);
        add(prizeText);

        timeText = new Grand9K(0, 250, "Time: " + (Std.int(Timer.stamp()) - PlayState.started) + "s");
        timeText.visible = false;
        timeText.screenCenter(X);
        add(timeText);

        prize = new FlxSprite(0, 350).loadGraphic(AssetPaths.gift__png);
        prize.antialiasing = Game.Options.antialiasing;
        prize.visible = false;
        prize.screenCenter(X);
        add(prize);

        #if desktop
        RichPresence.changePresence(PlayState.challenge ? "Challenge Mode" : "Normal Mode", "Game Complete");
        #end

        #if desktop
        FlxG.sound.playMusic(AssetPaths.end__ogg, Game.Options.music / 100);
        #else
        FlxG.sound.playMusic(AssetPaths.end__mp3, Game.Options.music / 100);
        #end

        FlxTween.tween(winText, { y: 100 }, 0.8, { onComplete: tween -> {
            prizeText.visible = true;
            timeText.visible = true;
            prize.visible = PlayState.challenge;
        }, startDelay: 0.4 });
    }

    override public function update(elapsed: Float) {
        super.update(elapsed);

        if (Game.Controls.BACK) {
            #if desktop
            FlxG.sound.playMusic(AssetPaths.menuTheme__ogg, Game.Options.music / 100);
            #else
            FlxG.sound.playMusic(AssetPaths.menuTheme__mp3, Game.Options.music / 100);
            #end
            Main.resetWorms();
            Main.worm1.visible = true;
            Main.worm2.visible = true;
            FlxG.switchState(new MainMenuState());
        }

        if (Game.Controls.ENTER && PlayState.challenge)
            Game.openURL("https://bit.ly/3ukOuDi");

        if (Game.Controls.FULLSCREEN)
            FlxG.fullscreen = !FlxG.fullscreen;
    }
}