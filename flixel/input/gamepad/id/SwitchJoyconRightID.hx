package flixel.input.gamepad.id;

import flixel.input.gamepad.FlxGamepadAnalogStick;

/**
 * IDs for Switch's Right JoyCon controllers
 *
 *-------
 * NOTES
 *-------
 *
 * WINDOWS: untested.
 *
 * LINUX: untested.
 *
 * MAC: Worked on html out of box for me when connected via microUSB cable or Bluetooth.
 * Flash and neko couldn't detect the controller via bluetooth,
 * which is weird because The pro worked wirelessly.
 * 
 * @since 4.8.0
 */
class SwitchJoyconRightID
{
	public static inline var ZR:Int = 5;
	public static inline var A:Int = 6;
	public static inline var X:Int = 7;
	public static inline var B:Int = 8;
	public static inline var Y:Int = 9;
	public static inline var R:Int = 10;
	public static inline var HOME:Int = 11;
	public static inline var PLUS:Int = 12;
	public static inline var LEFT_STICK_CLICK:Int = 13;
	public static inline var SL:Int = 15;
	public static inline var SR:Int = 16;
	public static var LEFT_ANALOG_STICK(default, null) = new FlxGamepadAnalogStick(0, 1, {
		up: 22,
		down: 23,
		left: 24,
		right: 25
	});
}
