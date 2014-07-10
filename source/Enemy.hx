package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxVelocity;
import flixel.plugin.MouseEventManager;

class Enemy extends FlxSprite
{
	public var speed:Float = 50;
	public var etype(default, null):Int;
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;
	public var flickering:Bool = false;
	
	public function new(X:Float=0, Y:Float=0, EType:Int) 
	{
		super(X, Y);
		etype = EType;
		loadGraphic("assets/images/enemy-" + Std.string(etype) + ".png", true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		drag.x = drag.y = 10;
		width = 8;
		height = 14;
		offset.x = 4;
		offset.y = 2;
		if (etype == 0) {
			health = 5;
		}else {
			health = 10;
		}
		
		_brain = new FSM(idle);
		_idleTmr = 0;
		playerPos = FlxPoint.get();
		MouseEventManager.add(this, onDown, null, onOver, onOut);
	}
	
	override public function update():Void 
	{
		_brain.update();
		super.update();
	}
	
	public function idle():Void
	{
		if (seesPlayer)
		{
			_brain.activeState = chase;
		}
		else if (_idleTmr <= 0)
		{
			if (FlxRandom.chanceRoll(1))
			{
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			}else{
				_moveDir = FlxRandom.intRanged(0, 4) * 45;
				FlxAngle.rotatePoint(speed * .5, 0, 0, 0, _moveDir, velocity);
				
			}
			_idleTmr = FlxRandom.intRanged(1, 4);			
		}
		else
			_idleTmr -= FlxG.elapsed;
		
	}
	
	public function chase():Void
	{
		if (!seesPlayer)
		{
			_brain.activeState = idle;
		}
		else
		{
			FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
		}
	}
	
	
	override public function draw():Void 
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			
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
			
		super.draw();
	}
	override public function hurt(Damage:Float):Void
	{
		if (flickering)
		{
			return;
		}
		flicker(1.3);

		super.hurt(Damage);
	}
	override public function kill():Void
	{
		if (!alive)
		{
			return;
		}
		super.kill();
		FlxSpriteUtil.flicker(this, 0, 0.02, true);
		PlayState._gibs.at(this);
		PlayState._gibs.start(true, 3, 0, 10);
	}

	private function flicker(Duration:Float):Void
	{
		FlxSpriteUtil.flicker(this, Duration, 0.02, true, true, function(_) {
			flickering = false;
		});
		flickering = true;
	}
	private function onDown(Sprite:FlxSprite) 
	{
		
		
	}
	private function onOver(Sprite:FlxSprite) 
	{
		color = 0x00FF00;
	}

	private function onOut(Sprite:FlxSprite)
	{
		color = FlxColor.WHITE;
	}
	
}