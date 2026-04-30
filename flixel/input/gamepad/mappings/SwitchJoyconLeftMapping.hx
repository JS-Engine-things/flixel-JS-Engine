package flixel.input.gamepad.mappings;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.id.SwitchJoyconLeftID;

/**
 * @since 4.8.0
 */
class SwitchJoyconLeftMapping extends FlxGamepadMapping
{
	override function initValues():Void
	{
		leftStick = SwitchJoyconLeftID.LEFT_ANALOG_STICK;
		supportsMotion = true;
		supportsPointer = false;
	}

	override public function getID(rawID:Int):FlxGamepadInputID
	{
		return switch (rawID)
		{
			case SwitchJoyconLeftID.DOWN: A;
			case SwitchJoyconLeftID.RIGHT: B;
			case SwitchJoyconLeftID.LEFT: X;
			case SwitchJoyconLeftID.UP: Y;
			case SwitchJoyconLeftID.MINUS: START;
			case SwitchJoyconLeftID.LEFT_STICK_CLICK: LEFT_STICK_CLICK;
			case SwitchJoyconLeftID.SL: LEFT_SHOULDER;
			case SwitchJoyconLeftID.SR: RIGHT_SHOULDER;
			case SwitchJoyconLeftID.L: EXTRA_0;
			case SwitchJoyconLeftID.ZL: LEFT_TRIGGER;
			case id if (id == leftStick.rawUp): LEFT_STICK_DIGITAL_UP;
			case id if (id == leftStick.rawDown): LEFT_STICK_DIGITAL_DOWN;
			case id if (id == leftStick.rawLeft): LEFT_STICK_DIGITAL_LEFT;
			case id if (id == leftStick.rawRight): LEFT_STICK_DIGITAL_RIGHT;
			case _: NONE;
		}
	}

	override public function getRawID(id:FlxGamepadInputID):Int
	{
		return switch (id)
		{
			case A: SwitchJoyconLeftID.DOWN;
			case B: SwitchJoyconLeftID.RIGHT;
			case X: SwitchJoyconLeftID.LEFT;
			case Y: SwitchJoyconLeftID.UP;
			case START: SwitchJoyconLeftID.MINUS;
			case LEFT_STICK_CLICK: SwitchJoyconLeftID.LEFT_STICK_CLICK;
			case LEFT_SHOULDER: SwitchJoyconLeftID.SL;
			case RIGHT_SHOULDER: SwitchJoyconLeftID.SR;
			case LEFT_TRIGGER: SwitchJoyconLeftID.ZL;
			case EXTRA_0: SwitchJoyconLeftID.L;
			case LEFT_STICK_DIGITAL_UP: SwitchJoyconLeftID.LEFT_ANALOG_STICK.rawUp;
			case LEFT_STICK_DIGITAL_DOWN: SwitchJoyconLeftID.LEFT_ANALOG_STICK.rawDown;
			case LEFT_STICK_DIGITAL_LEFT: SwitchJoyconLeftID.LEFT_ANALOG_STICK.rawLeft;
			case LEFT_STICK_DIGITAL_RIGHT: SwitchJoyconLeftID.LEFT_ANALOG_STICK.rawRight;
			case ACCEPT: SwitchJoyconLeftID.RIGHT;
			case CANCEL: SwitchJoyconLeftID.DOWN;
			default: super.getRawID(id);
		}
	}

	override function getInputLabel(id:FlxGamepadInputID)
	{
		return switch (id)
		{
			case A: "down";
			case B: "right";
			case X: "left";
			case Y: "up";
			case START: "minus";
			case EXTRA_0: "l";
			case LEFT_SHOULDER: "sl";
			case RIGHT_SHOULDER: "sr";
			case LEFT_TRIGGER: "zl";
			case _: super.getInputLabel(id);
		}
	}
}
