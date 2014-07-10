package;

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.effects.particles.FlxEmitter;
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
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxVelocity;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mBg:FlxTilemap;
	private var _grpCoins:FlxTypedGroup<Coin>;
	public static var _mWalls:FlxTilemap;
	public static var _grpEnemies:FlxTypedGroup<Enemy>;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	private var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 1 };
	private var fillStyle:FillStyle = { color: FlxColor.TRANSPARENT};
	
	public static var _gibs:FlxEmitter;
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
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);
		
		_bullets = new FlxTypedGroup<Bullet>();
		_bullets.maxSize = 20;
		add(_bullets);
		
		_player = new Player();
		_player._bullets = _bullets;
		_map.loadEntities(placeEntities, "entities");
		add(_player);
		
		_gibs = new FlxEmitter();
		_gibs.setXSpeed( -150, 150);
		_gibs.setYSpeed( -500, 150);
		_gibs.setRotation( -720, -720);
		//_gibs.gravity = 350;
		_gibs.bounce = 0.5;
		_gibs.makeParticles(AssetPaths.gibs__png, 10, 10, true, 0.5);
		add(_gibs);
		
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
		else if (entityName == "enemy")
		{
			_grpEnemies.add(new Enemy(Std.parseInt(entityData.get("x")) + 4 , Std.parseInt(entityData.get("y")), Std.parseInt(entityData.get("etype"))));

		}
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		_player = null;
		_map = null;
		_mBg = null;
		_grpCoins = null;
		_mWalls = null;
		_grpEnemies = null;
		_bullets = null;
		lineStyle = null;
		fillStyle = null;
	}
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{

		super.update();
		
		FlxG.collide(_player, _mWalls);
		
		FlxG.collide(_grpEnemies, _mWalls);
		FlxG.collide(_bullets, _mWalls); 
		FlxG.collide(_gibs, _mWalls);
		
		FlxG.overlap(_player, _grpCoins, playerTouchCoin);
		FlxG.overlap(_bullets, _grpEnemies, overlapped);
		
		//_grpEnemies.forEachAlive(checkEnemyVision);	
	}
	
	
	private function overlapped(Sprite1:FlxObject, Sprite2:FlxObject):Void
	{
		Sprite2.hurt(1);
	}
	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			C.kill();
		}
	}
}