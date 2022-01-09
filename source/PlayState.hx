package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxTimer;
import haxe.Json;
import haxe.Timer;
import lime.utils.Assets;

// gmfd i didn't know making a game was this hard
class PlayState extends FlxState {
    public static var challenge: Bool = false;
    public static var levelIndex: Int = #if LEVEL3 3 #else 1 #end;
    public static var started: Int #if (SKIP_GAME || SKIP_MENU) = Std.int(Timer.stamp()) #end;

    var bg: FlxSprite;
    var end: FlxSprite;
    var player: Player;
    // I made these ones sprite groups so I don't have to tween every single fucking one
    var blocks: FlxSpriteGroup;
    var obstacles: FlxSpriteGroup;
    var levelText: Grand9K;
    var bgCover: FlxSprite;
    var timmy: FlxSprite;
    var dialogue: DialogueBox;
    var powerBar: FlxBar;
    var textNotice: Grand9K;

    var level: {
        blocks: Array<{ x: Int, y: Int, w: Int, h: Int }>,
        circles: Array<{ x: Int, y: Int, w: Int }>,
        saws: Array<{ x: Int, y1: Int, y2: Int }>,
        dialogue: Array<{ speaking: String, text: String, event: Null<String> }>
    }
    var dialogueIndex = 0;
    public var power: Int = 0;

    override public function create() {
        super.create();

        bg = new FlxSprite(-1400).makeGraphic(1280, 720, 0xFF404040);
        add(bg);

        end = new FlxSprite(-280).loadGraphic(AssetPaths.end__png);
        end.antialiasing = Game.Options.antialiasing;
        add(end);

        player = new Player(-1200, 333);
        add(player);

        obstacles = new FlxSpriteGroup(levelIndex == 3 ? 1400 : -1400);
        add(obstacles);

        blocks = new FlxSpriteGroup(-1400);
        add(blocks);

        level = Json.parse(Assets.getText("assets/data/level" + levelIndex + ".json"));
        for (block in level.blocks) {
            var block = new FlxSprite(block.x, block.y).makeGraphic(block.w, block.h, 0xFF808080);
            block.immovable = true;
            blocks.add(block);
        }

        for (circle in level.circles) {
            var circleSprite = new FlxSprite(circle.x, circle.y).loadGraphic("assets/images/game/circles/circle" + circle.w + ".png");
            circleSprite.antialiasing = Game.Options.antialiasing;
            obstacles.add(circleSprite);
        }

        for (saw in level.saws) {
            var sawSprite = new FlxSprite(saw.x, saw.y1).loadGraphic(AssetPaths.saw__png);
            sawSprite.antialiasing = Game.Options.antialiasing;
            FlxTween.tween(sawSprite, { angle: 360 }, 1, { type: 2 });
            FlxTween.tween(sawSprite, { y: saw.y2 }, 1, { type: 4 });
            obstacles.add(sawSprite);
        }

        if (levelIndex == 3) {
            for (i in 0...5) {
                var lennySaw = new FlxSprite(0, i * 145).loadGraphic(AssetPaths.lenny_saw__png);
                lennySaw.antialiasing = Game.Options.antialiasing;
                obstacles.add(lennySaw);
            }
        }

        levelText = new Grand9K([990, 960, 970][levelIndex - 1], -100, "Level " + levelIndex);
        add(levelText);

        bgCover = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bgCover.alpha = 0;
        add(bgCover);

        timmy = new FlxSprite(600, 199).loadGraphic(AssetPaths.timmy__png);
        timmy.antialiasing = Game.Options.antialiasing;
        timmy.alpha = 0;
        add(timmy);

        powerBar = new FlxBar(0, 10, LEFT_TO_RIGHT, 200, 20, this, "power");
        powerBar.createFilledBar(0x00000000, 0xFF00FF00);
        powerBar.screenCenter(X);
        add(powerBar);

        textNotice = new Grand9K(0, 100, "Hold SPACE or ENTER to charge", 0.5);
        textNotice.visible = false;
        textNotice.screenCenter(X);
        add(textNotice);

        #if desktop
        RichPresence.changePresence(challenge ? "Challenge Mode" : "Normal Mode", "Level " + levelIndex);
        #end

        FlxTween.tween(bg, { x: 0 }, 0.5);
        FlxTween.tween(player, { x: 200 }, 0.5);
        FlxTween.tween(end, { x: 1120 }, 0.5);
        FlxTween.tween(levelText, { y: 10 }, 0.5);
        FlxTween.tween(blocks, { x: 0 }, 0.5);
        if (levelIndex != 3)
            FlxTween.tween(obstacles, { x: 0 }, 0.5);
    }

    override public function closeSubState() {
        if (PauseSubState.toOptions) {
            if (PauseSubState.fromOptions) {
                PauseSubState.toOptions = false;
                PauseSubState.fromOptions = false;
                openSubState(new PauseSubState());
            } else
                openSubState(new OptionsSubState());
        }

        super.closeSubState();
    }

    var level3Init: Bool = false;
    var bossfight: Bool = false;
    var currentlyFighting: Bool = false;
    override public function update(elapsed: Float) {
        super.update(elapsed);

        if (Game.Controls.BACK)
            openSubState(new PauseSubState());

        if (Game.Controls.FULLSCREEN)
            FlxG.fullscreen = !FlxG.fullscreen;
        
        if (levelIndex != 3) {
            #if !NOCLIP
            obstacles.forEach(obstacle -> {
                if (FlxCollision.pixelPerfectCheck(player, obstacle)) {
                    player.killPlayer(t -> {
                        remove(player);
                        if (challenge) { // if it is in challenge mode
                            FlxTween.tween(bgCover, { alpha: 1 }, 0.5, { onComplete: tween -> {
                                levelIndex = 1;
                                started = Std.int(Timer.stamp());
                                FlxG.switchState(new PlayState());
                            } });
                        } else {
                            player = new Player(200, 333);
                            add(player);
                        }
                    });
                }
            });
            #end
        } else { // epic bossfight
            if (!level3Init) {
                player.movable = false;
                FlxTween.tween(timmy, { alpha: 1 }, 0.5, { startDelay: 0.5 });
                new FlxTimer().start(1.5, timer -> {
                    dialogue = new DialogueBox(0, 0, level.dialogue[0]);
                    add(dialogue);
                });
                level3Init = true;
            } else {
                obstacles.forEach(obstacle -> {
                    if (FlxCollision.pixelPerfectCheck(player, obstacle) && obstacles.visible) {
                        #if !NOCLIP
                        player.killPlayer(tween -> {
                            remove(player);
                            
                            FlxTween.tween(bgCover, { alpha: 1 }, 0.5, { onComplete: tween -> {
                                if (challenge) {
                                    levelIndex = 1;
                                    started = Std.int(Timer.stamp());
                                }
                                FlxG.switchState(new PlayState());
                            } });
                        });
                        #else
                        obstacles.visible = false;
                        #end
                    }
                });

                if (Game.Controls.ENTER && currentlyFighting && power < 100) {
                    power += 1;
                    if (textNotice.visible)
                        textNotice.visible = false;
                    if (power == 100) {
                        obstacles.visible = false;
                        powerBar.visible = false;
                    }
                }

                if (Game.Controls.ENTER_P && !bossfight) {
                    dialogue.text.typingSound.destroy();
                    remove(dialogue);
                    if (dialogueIndex < level.dialogue.length - 1) {
                        dialogueIndex++;
                        dialogue = new DialogueBox(0, 0, level.dialogue[dialogueIndex]);
                        add(dialogue);
                    } else {
                        FlxTween.tween(timmy, { alpha: 0 }, 0.5, { onComplete: tween -> player.movable = true });
                    }

                    if (dialogue.event) {
                        bossfight = true;
                        FlxTween.tween(obstacles, { x: 400 }, 0.5)
                        .then(FlxTween.tween(obstacles, { x: 200 }, 10, { startDelay: 1, onStart: tween -> {
                            currentlyFighting = true;
                            textNotice.visible = true;
                        } }));
                    }
                }

                if (!obstacles.visible && currentlyFighting) {
                    currentlyFighting = false;
                    new FlxTimer().start(1.5, timer -> {
                        bossfight = false;
                        dialogueIndex++;
                        dialogue = new DialogueBox(0, 0, level.dialogue[dialogueIndex]);
                        add(dialogue);
                    });
                }
            }
        }

        if (!player.ending) {
            if (player.overlaps(end)) {
                player.ending = true;
                FlxTween.tween(player, { angle: 180, x: 1300 }, 0.5, { onComplete: tween -> {
                    FlxTween.tween(bg, { x: -1400 }, 0.5);
                    FlxTween.tween(end, { x: -280 }, 0.5);
                    FlxTween.tween(levelText, { y: -100 }, 0.5);
                    FlxTween.tween(blocks, { x: -1400 }, 0.5);
                    FlxTween.tween(obstacles, { x: -1400 }, 0.5);
                    new FlxTimer().start(1, timer -> {
                        if (levelIndex == 3)
                            FlxG.switchState(new WinState());
                        else {
                            levelIndex++;
                            FlxG.switchState(new PlayState());
                        }
                    });
                } });
            } else // I cannot believe it was this fucking simple
                FlxG.collide(player, blocks.group);
        }
    }
}