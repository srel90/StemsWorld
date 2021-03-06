package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/data/room-001.oel", "assets/data/room-001.oel");
			type.set ("assets/data/room-001.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/Stem'sWorld.oep", "assets/data/Stem'sWorld.oep");
			type.set ("assets/data/Stem'sWorld.oep", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/images/bullet.png", "assets/images/bullet.png");
			type.set ("assets/images/bullet.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/coin.png", "assets/images/coin.png");
			type.set ("assets/images/coin.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/enemy-0.png", "assets/images/enemy-0.png");
			type.set ("assets/images/enemy-0.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/enemy-1.png", "assets/images/enemy-1.png");
			type.set ("assets/images/enemy-1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/forest.png", "assets/images/forest.png");
			type.set ("assets/images/forest.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/gibs.png", "assets/images/gibs.png");
			type.set ("assets/images/gibs.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/player.png", "assets/images/player.png");
			type.set ("assets/images/player.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sounds/beep.ogg", "assets/sounds/beep.ogg");
			type.set ("assets/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/flixel.ogg", "assets/sounds/flixel.ogg");
			type.set ("assets/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
