package ;

import flixel.addons.display.shapes.FlxShape;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import openfl.display.Graphics;
import openfl.filters.GlowFilter;
/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
	public var speed:Float = 50;
	private var path:FlxPath;
	
	private var _shootCounter:Float = 0;
	public  var _bullets:FlxTypedGroup<Bullet>;
	private static var SHOOT_RATE:Float = 1 /3; 
	private var _aim:Int;

	
	public var circle:FlxShapeCircle;
	private var _target:FlxShapeCircle;
	private var _targetRadius:Int = 0;
	public var lineStyle:LineStyle = { color: FlxColor.WHITE, thickness: 1 };
	public var fillStyle:FillStyle = { color: FlxColor.WHITE, alpha: 0.3 };
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		drag.x = drag.y = 1600;
		setSize(8, 14);
		offset.set(4, 2);
		path = new FlxPath();	
		circle = new FlxShapeCircle(x, y, 25, lineStyle, fillStyle );
		circle.alpha = 0.3;	
		_target = new FlxShapeCircle(0, 0, 20, lineStyle, fillStyle );
		facing = FlxObject.DOWN;
	}
	override public function draw():Void 
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			switch(facing)
			{
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");

				case FlxObject.UP:
					animation.play("u");

				case FlxObject.DOWN:
					animation.play("d");
			}
		}
		if ((path != null) && !path.finished)
		{
			path.drawDebug();
		}
		
		circle.x = x + width / 2-circle.width/2;
		circle.y = y + height / 2 - circle.height / 2;
		circle.draw();
		
		if (Reg.battleCommand && Reg.battleTarget!=null) {
		if (_targetRadius < 20) { _targetRadius++; } else { _targetRadius = 0; }
		_target.radius = _targetRadius;
		_target.lineStyle = { color:FlxColor.RED,thickness:1 };
		_target.fillStyle = { color:FlxColor.TRANSPARENT };			
		_target.x = Reg.battleTarget.x-_target.width/2;
		_target.y = Reg.battleTarget.y - _target.height / 2;
		_target.draw();
		}
		
		super.draw();
	}
	private function updateMovement():Void
	{
		if (Math.abs(velocity.x) > Math.abs(velocity.y))
		{
			if (velocity.x < 0)
				facing = FlxObject.LEFT;
			else
				facing = FlxObject.RIGHT;
		}else{
			if (velocity.y < 0)
				facing = FlxObject.UP;
			else if(!path.finished)
				facing = FlxObject.DOWN;
		}		
		_aim = facing;
		if (FlxG.mouse.justPressed) {	
			Reg.battleCommand = false;
			var pathStart:FlxPoint = new FlxPoint(x + width / 2, y + height / 2);
			var pathEnd:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			var pathPoints:Array<FlxPoint> = PlayState._mWalls.findPath(pathStart, pathEnd);
				if (pathPoints != null) 
				{
					path.start(this, pathPoints, speed);
					
				}
		}
		if (FlxG.mouse.justPressedRight) {
			Reg.battleCommand = true;
			Reg.battleTarget = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			var pathStart:FlxPoint = new FlxPoint(x + width / 2, y + height / 2);
			var pathEnd:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			var pathPoints:Array<FlxPoint> = PlayState._mWalls.findPath(pathStart, pathEnd);
				if (pathPoints != null) 
				{
					path.start(this, pathPoints, speed);
					
				}
		}
		
		if(_shootCounter > 0){
			_shootCounter -= FlxG.elapsed;
		}

				
	}
	override public function update():Void 
	{
		
		updateMovement();
		checkCircleColid();
		super.update();
	}
	private function checkCircleColid():Void
	{
		for (i in 0...PlayState._grpEnemies.length) 
		{
			if (PlayState._grpEnemies.members[i].alive) {
				if (FlxCollision.pixelPerfectCheck(PlayState._grpEnemies.members[i], circle, 1)){	
					if (Reg.battleCommand){
						if (PlayState._mWalls.ray(PlayState._grpEnemies.members[i].getMidpoint(), getMidpoint())){
							shoot(PlayState._grpEnemies.members[i]);
						}
					}
				}
				
			}
		}
	}
	public function shoot(monsterTarget:FlxSprite):Void
	{
		if (_shootCounter > 0)
		{
			return;
		}
		_shootCounter = SHOOT_RATE;
		getMidpoint(_point);
		_bullets.recycle(Bullet).shoot(_point, _aim,monsterTarget);
	}
}