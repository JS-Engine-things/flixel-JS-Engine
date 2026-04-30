package flixel.input.gamepad.id;

import flixel.input.gamepad.FlxGamepadAnalogStick;

/**
	* IDs for PlayStation 4 controllers
	*
	*-------
	* NOTES
	*-------
	*
	* WINDOWS: seems to work fine without any special drivers on Windows 10 (and I seem to recall the same on Windows 7).
	* DS4Windows is the popular 3rd-party utility here, but it will make the PS4 controller look like a 360 controller, which
	* means that it will be indistinguishable from an XInput device to flixel (DS4Windows: http://ds4windows.com).
	*
	* LINUX: the PS4 controller will be detected as an XInput device when using xpad (see notes in XInputID.hx)
	*
	* MAC: the PS4 controller seemed to work perfectly without anything special installed, and was not detected in the 360Controller
	* control panel, so it might just work right out of the box!
 */
class PS4ID
{
	public static inline var SQUARE:Int = 0;
	public static inline var X:Int = 1;
	public static inline var CIRCLE:Int = 2;
	public static inline var TRIANGLE:Int = 3;
	public static inline var L1:Int = 4;
	public static inline var R1:Int = 5;

	public static inline var SHARE:Int = 8;
	public static inline var OPTIONS:Int = 9;
	public static inline var LEFT_STICK_CLICK:Int = 10;
	public static inline var RIGHT_STICK_CLICK:Int = 11;
	public static inline var PS:Int = 12;
	public static inline var TOUCHPAD_CLICK:Int = 13;

	public static inline var L2:Int = 3;
	public static inline var R2:Int = 4;

	public static var LEFT_ANALOG_STICK(default, null) = new FlxGamepadAnalogStick(0, 1, {
		up: 27,
		down: 28,
		left: 29,
		right: 30
	});
	public static var RIGHT_ANALOG_STICK(default, null) = new FlxGamepadAnalogStick(2, 5, {
		up: 31,
		down: 32,
		left: 33,
		right: 34
	});

	// "fake" IDs, we manually watch for hat axis changes and then send events using these otherwise unused joystick button codes
	public static inline var DPAD_LEFT:Int = 15;
	public static inline var DPAD_RIGHT:Int = 16;
	public static inline var DPAD_DOWN:Int = 17;
	public static inline var DPAD_UP:Int = 18;
}
