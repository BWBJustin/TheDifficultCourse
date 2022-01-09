package;

import flixel.FlxG;

class Game {
    public static var version: String = "v1.0.0";
    public static var outdated: Bool = false;

    public static function initSave() {
        FlxG.save.bind("TheDifficultCourse", "BWBJustin");
        Options.fpsCounter = defaultTo("fpsCounter", false);
        Options.antialiasing = defaultTo("antialiasing", true);
        Options.music = defaultTo("music", 100);
        Options.sounds = defaultTo("sounds", 100);
        #if desktop
        Options.fpsCap = defaultTo("fpsCap", 60);
        #end
    }

    public static function openURL(url: String) {
        #if linux
        Sys.command("/usr/bin/xdg-open", [url, "&"])
        #else
        FlxG.openURL(url);
        #end
    }

    static function defaultTo(name: String, value: Dynamic): Dynamic {
        var option = Reflect.getProperty(FlxG.save.data, name);
        return option != null ? option : value;
    }
}

class Controls {
    public static var LEFT(get, never): Bool;
    static function get_LEFT() {
        return FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A;
    }

    public static var LEFT_P(get, never): Bool;
    static function get_LEFT_P() {
        return FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A;
    }

    public static var LEFT_R(get, never): Bool;
    static function get_LEFT_R() {
        return FlxG.keys.justReleased.LEFT || FlxG.keys.justReleased.A;
    }

    public static var RIGHT(get, never): Bool;
    static function get_RIGHT() {
        return FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D;
    }

    public static var RIGHT_P(get, never): Bool;
    static function get_RIGHT_P() {
        return FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D;
    }

    public static var RIGHT_R(get, never): Bool;
    static function get_RIGHT_R() {
        return FlxG.keys.justReleased.RIGHT || FlxG.keys.justReleased.D;
    }

    public static var UP(get, never): Bool;
    static function get_UP() {
        return FlxG.keys.pressed.UP || FlxG.keys.pressed.W;
    }

    public static var UP_P(get, never): Bool;
    static function get_UP_P() {
        return FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W;
    }

    public static var UP_R(get, never): Bool;
    static function get_UP_R() {
        return FlxG.keys.justReleased.UP || FlxG.keys.justReleased.W;
    }

    public static var DOWN(get, never): Bool;
    static function get_DOWN() {
        return FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S;
    }

    public static var DOWN_P(get, never): Bool;
    static function get_DOWN_P() {
        return FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S;
    }

    public static var DOWN_R(get, never): Bool;
    static function get_DOWN_R() {
        return FlxG.keys.justReleased.DOWN || FlxG.keys.justReleased.S;
    }

    public static var ENTER(get, never): Bool;
    static function get_ENTER() {
        return FlxG.keys.pressed.ENTER || FlxG.keys.pressed.SPACE;
    }

    public static var ENTER_P(get, never): Bool;
    static function get_ENTER_P() {
        return FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE;
    }

    public static var BACK(get, never): Bool;
    static function get_BACK() {
        return FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE;
    }

    public static var FULLSCREEN(get, never): Bool;
    static function get_FULLSCREEN() {
        return #if desktop FlxG.keys.justPressed.F11 || #end FlxG.keys.justPressed.F;
    }
}

class Options {
    public static var fpsCounter(get, set): Bool;

	static function get_fpsCounter() {
        return FlxG.save.data.fpsCounter;
	}

	static function set_fpsCounter(value: Bool) {
        FlxG.save.data.fpsCounter = value;
        if (Main.fpsCounter != null)
        Main.fpsCounter.visible = value;
        FlxG.save.flush();
        return value;
	}

    public static var antialiasing(get, set): Bool;

	static function get_antialiasing() {
        return FlxG.save.data.antialiasing;
	}

	static function set_antialiasing(value: Bool) {
        FlxG.save.data.antialiasing = value;
        FlxG.save.flush();
        return value;
	}

    public static var music(get, set): Int;

	static function get_music() {
        return FlxG.save.data.music;
	}

	static function set_music(value: Int) {
        FlxG.save.data.music = value;
        if (FlxG.sound.music != null)
            FlxG.sound.music.volume = value / 100;
        FlxG.save.flush();
        return value;
	}

    public static var sounds(get, set): Int;

	static function get_sounds() {
        return FlxG.save.data.sounds;
	}

	static function set_sounds(value: Int) {
        FlxG.save.data.sounds = value;
        FlxG.save.flush();
        return value;
	}

    #if desktop
    public static var fpsCap(get, set): Int;

	static function get_fpsCap() {
        return FlxG.save.data.fpsCap;
	}

	static function set_fpsCap(value: Int) {
        var lessThan = value < FlxG.save.data.fpsCap;
        FlxG.save.data.fpsCap = value;
        if (lessThan) {
            FlxG.drawFramerate = value;
            FlxG.updateFramerate = value;
        } else {
            FlxG.updateFramerate = value;
            FlxG.drawFramerate = value;
        }
        FlxG.save.flush();
        return value;
	}
    #end
}