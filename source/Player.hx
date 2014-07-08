package ;

import flixel.addons.display.shapes.FlxShape;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
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
	public var circle:FlxShapeCircle;
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
		super.draw();
	}
	private function updateMovement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		var _mousePress:Bool = false;
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		if (_up && _down)
			 _up = _down = false;
		if (_left && _right)
			 _left = _right = false;
		if ( _up || _down || _left || _right){
			var mA:Float = 0;
			path.cancel();
			immovable = false;
			if (_up){
				mA = -90;
				if (_left){
					mA -= 45;
				}else if (_right){
					mA += 45;
				}
				facing = FlxObject.UP;
			}else if (_down){
				mA = 90;
				if (_left){
					mA += 45;
				}else if (_right){
					mA -= 45;	
				}
				facing = FlxObject.DOWN;
			}else if (_left){
				mA = 180;
				facing = FlxObject.LEFT;
			}else if (_right){
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
		}else {
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}
		}
		
		if (FlxG.mouse.justReleased) {				
			var pathStart:FlxPoint = new FlxPoint(x + width / 2, y + height / 2);
			var pathEnd:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			var pathPoints:Array<FlxPoint> = PlayState._mWalls.findPath(pathStart, pathEnd);
				if (pathPoints != null) 
				{
					path.start(this, pathPoints,speed);
				}
		}
				
	}
	override public function update():Void 
	{
		updateMovement();
		super.update();
	}
}