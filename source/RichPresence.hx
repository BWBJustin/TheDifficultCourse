#if desktop
import discord_rpc.DiscordRpc;
import sys.thread.Thread;
#end

class RichPresence {
    #if desktop
    public function new() {
        DiscordRpc.start({
            clientID: "929552327659118622",
            onReady: () -> changePresence("In the Menus")
        });

        while (true) {
            DiscordRpc.process();
            Sys.sleep(2);
        }

        shutdown();
    }

    public static function changePresence(?state: String, ?details: String) {
        DiscordRpc.presence({
            state: state,
            details: details,
            largeImageKey: "logo1024",
            largeImageText: "The Difficult Course"
        });
    }

    public static function initialize() {
        Thread.create(() -> new RichPresence());
    }

    public static function shutdown() {
        DiscordRpc.shutdown();
    }
    #end
}