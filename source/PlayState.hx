package;

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	public static var _mWalls:FlxTilemap;
	private var _mBg:FlxTilemap;
	private var _grpCoins:FlxTypedGroup<Coin>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xff250137;
		_map = new FlxOgmoLoader("assets/data/room-001.oel");
		_mWalls = _map.loadTilemap("assets/images/forest.png", 10, 10, "wall");
		_mBg = _map.loadTilemap("assets/images/forest.png", 10, 10, "bg");

		add(_mBg);
		add(_mWalls);
		
		
		_grpCoins = new FlxTypedGroup<Coin>();
		add(_grpCoins);
		
		
		_player = new Player();
		
		_map.loadEntities(placeEntities, "entities");
		
		add(_player);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, null, 1);
		
		super.create();	
		
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		if (entityName == "player")
		{
			_player.x = Std.parseInt(entityData.get("x"));
			_player.y = Std.parseInt(entityData.get("y"));
		}
		else if (entityName == "coin")
		{
			_grpCoins.add(new Coin(Std.parseInt(entityData.get("x")) + 4, Std.parseInt(entityData.get("y")) + 4));
			
		}
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{

		super.update();
		
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpCoins, playerTouchCoin);
		for (i in 0..._grpCoins.length) 
		{
			if (FlxCollision.pixelPerfectCheck(_player.circle, _grpCoins.members[i], 1)) {
				trace("Hit");
			}
		}
	}	
	
	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			C.kill();
		}
	}
}