package flixel.input.gamepad.id;

import flixel.input.gamepad.FlxGamepadAnalogStick;

/**
	* IDs for generic XInput controllers
	*
	* Compatible with the Xbox 360 controller, the Xbox One controller, and anything that masquerades as either of those.
	*
	*-------
	* NOTES
	*-------
	*
	* WINDOWS: we assume the user is using the default drivers that ship with windows.
	*
	* LINUX: we assume the user is using the xpad driver, specifically Valve's version, steamos-xpad-dkms
	* (we got weird errors when using xboxdrv). For full instructions on installation, see:
	* http://askubuntu.com/questions/165210/how-do-i-get-an-xbox-360-controller-working/441548#441548
	*
	* MAC: we assume the user is using the 360 Controller driver, specifically this one:
	* https://github.com/360Controller/360Controller/releases
 */
class XInputID
{
	#if FLX_GAMEINPUT_API
	public static inline var A:Int = 6;
	public static inline var B:Int = 7;
	public static inline var X:Int = 8;
	public static inline var Y:Int = 9;

	public static inline var BACK:Int = 10;
	public static inline var GUIDE:Int = #if mac 11 #else - 1 #end;
	public static inline var START:Int = 12;

	public static inline var LEFT_STICK_CLICK:Int = 13;
	public static inline var RIGHT_STICK_CLICK:Int = 14;

	public static inline var LB:Int = 15;
	public static inline var RB:Int = 16;

	public static inline var DPAD_UP:Int = 17;
	public static inline var DPAD_DOWN:Int = 18;
	public static inline var DPAD_LEFT:Int = 19;
	public static inline var DPAD_RIGHT:Int = 20;

	public static var LEFT_ANALOG_STICK(default, null) = new FlxGamepadAnalogStick(0, 1, {
		up: 21,
		down: 22,
		left: 23,
		right: 24
	});
	public static var RIGHT_ANALOG_STICK(default, null) = new FlxGamepadAnalogStick(2, 3, {
		up: 25,
		down: 26,
		left: 27,
		right: 28
	});

	public static inline var LEFT_TRIGGER:Int = 4;
	public static inline var RIGHT_TRIGGER:Int = 5;
	#end
}
