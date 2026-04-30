package flixel.input.mouse;

#if FLX_MOUSE
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.ui.Mouse;
import flixel.FlxG;
import flixel.input.IFlxInputManager;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.system.FlxAssets;
import flixel.util.FlxDestroyUtil;

@:bitmap("assets/images/ui/cursor.png")
private class GraphicCursor extends BitmapData {}

/**
 * This class helps contain and track the mouse pointer in your game.
 * Automatically accounts for parallax scrolling, etc.
 * Normally accessed via `FlxG.mouse`.
 */
class FlxMouse extends FlxPointer implements IFlxInputManager
{
	/**
	 * Whether or not mouse input is currently enabled.
	 * @since 4.1.0
	 */
	public var enabled:Bool = true;

	/**
	 * Current "delta" value of mouse wheel. If the wheel was just scrolled up,
	 * it will have a positive value and vice versa. Otherwise the value will be 0.
	 */
	public var wheel(default, null):Int = 0;

	/**
	 * A display container for the mouse cursor. It is a child of FlxGame and
	 * sits at the right "height". Not used on flash with the native cursor API.
	 */
	public var cursorContainer(default, null):Sprite;
	
	/**
	 * The current cursor bitmap, if there is one. To set, use the `load` function.
	 */
	public var cursor(default, null):Null<Bitmap>;

	/**
	 * Used to toggle the visiblity of the mouse cursor - works on both
	 * the flixel and the system cursor, depending on which one is active.
	 */
	public var visible(default, set):Bool = #if (mobile || switch) false #else true #end;

	/**
	 * Tells flixel to use the default system mouse cursor instead of custom Flixel mouse cursors.
	 */
	public var useSystemCursor(default, set):Bool = false;

	/**
	 * Check to see if the mouse has just been moved.
	 * @since 4.4.0
	 */
	public var justMoved(get, never):Bool;

	/**
	 * Distance in pixels the mouse has moved since the last frame in the X direction.
	 */
	public var deltaX(get, never):Int;

	/**
	 * Distance in pixels the mouse has moved since the last frame in the Y direction.
	 */
	public var deltaY(get, never):Int;

	/**
	 * Distance in pixels the mouse has moved in screen space since the last frame in the X direction.
	 */
	public var deltaScreenX(get, never):Int;

	/**
	 * Distance in pixels the mouse has moved in screen space since the last frame in the Y direction.
	 */
	public var deltaScreenY(get, never):Int;

	/**
	 * Check to see if the left mouse button is currently pressed.
	 */
	public var pressed(get, never):Bool;

	/**
	 * Check to see if the left mouse button has just been pressed.
	 */
	public var justPressed(get, never):Bool;

	/**
	 * Check to see if the left mouse button is currently not pressed.
	 * @since 5.0.0
	 */
	public var released(get, never):Bool;

	/**
	 * Check to see if the left mouse button has just been released.
	 */
	public var justReleased(get, never):Bool;

	/**
	 * Time in ticks of last left mouse button press.
	 * @since 4.3.0
	 */
	public var justPressedTimeInTicks(get, never):Float;

	#if FLX_MOUSE_ADVANCED
	/**
	 * Check to see if the right mouse button is currently pressed.
	 */
	public var pressedRight(get, never):Bool;

	/**
	 * Check to see if the right mouse button has just been pressed.
	 */
	public var justPressedRight(get, never):Bool;
	
	/**
	 * Check to see if the right mouse button is currently not pressed.
	 * @since 5.0.0
	 */
	public var releasedRight(get, never):Bool;

	/**
	 * Check to see if the right mouse button has just been released.
	 */
	public var justReleasedRight(get, never):Bool;

	/**
	 * Time in ticks of last right mouse button press.
	 * @since 4.3.0
	 */
	public var justPressedTimeInTicksRight(get, never):Float;

	/**
	 * Check to see if the middle mouse button is currently pressed.
	 */
	public var pressedMiddle(get, never):Bool;

	/**
	 * Check to see if the middle mouse button has just been pressed.
	 */
	public var justPressedMiddle(get, never):Bool;

	/**
	 * Check to see if the middle mouse button is currently not pressed.
	 * @since 5.0.0
	 */
	public var releasedMiddle(get, never):Bool;

	/**
	 * Check to see if the middle mouse button has just been released.
	 */
	public var justReleasedMiddle(get, never):Bool;

	/**
	 * Time in ticks of last middle mouse button press.
	 * @since 4.3.0
	 */
	public var justPressedTimeInTicksMiddle(get, never):Float;
	#end

	/**
	 * The left mouse button.
	 */
	@:allow(flixel.input.mouse.FlxMouseButton)
	var _leftButton:FlxMouseButton;

	#if FLX_MOUSE_ADVANCED
	/**
	 * The middle mouse button.
	 */
	@:allow(flixel.input.mouse.FlxMouseButton)
	var _middleButton:FlxMouseButton;

	/**
	 * The right mouse button.
	 */
	@:allow(flixel.input.mouse.FlxMouseButton)
	var _rightButton:FlxMouseButton;
	#end

	@:deprecated("_cursor is deprecated, use the new, public cursor, instead")
    var _cursor(get, set):Bitmap;
	var _cursorBitmapData:BitmapData;
	var _wheelUsed:Bool = false;
	var _visibleWhenFocusLost:Bool = true;

	/**
	 * Helper variables to see if the mouse has moved since the last update, and by how much.
	 */
	var _prevX:Int = 0;
	var _prevY:Int = 0;
	var _prevScreenX:Int = 0;
	var _prevScreenY:Int = 0;

	// Helper variable for cleaning up memory
	var _stage:Stage;

	/**
	 * Load a new mouse cursor graphic - if you're using native cursors on flash,
	 * check registerNativeCursor() for more control.
	 *
	 * @param   Graphic   The image you want to use for the cursor.
	 * @param   Scale     Change the size of the cursor.
	 * @param   XOffset   The number of pixels between the mouse's screen position and the graphic's top left corner.
	 *                    Has to be positive when using native cursors.
	 * @param   YOffset   The number of pixels between the mouse's screen position and the graphic's top left corner.
	 *                    Has to be positive when using native cursors.
	 */
	public function load(?Graphic:Dynamic, Scale:Float = 1, XOffset:Int = 0, YOffset:Int = 0):Void
	{
		if (cursor != null)
		{
			FlxDestroyUtil.removeChild(cursorContainer, cursor);
		}

		if (Graphic == null)
		{
			Graphic = new GraphicCursor(0, 0);
		}

		if ((Graphic is Class))
		{
			cursor = Type.createInstance(Graphic, []);
		}
		else if ((Graphic is BitmapData))
		{
			cursor = new Bitmap(cast Graphic);
		}
		else if ((Graphic is String))
		{
			cursor = new Bitmap(FlxAssets.getBitmapData(Graphic));
		}
		else
		{
			cursor = new Bitmap(new GraphicCursor(0, 0));
		}

		cursor.x = XOffset;
		cursor.y = YOffset;
		cursor.scaleX = Scale;
		cursor.scaleY = Scale;

		cursorContainer.addChild(cursor);
	}

	/**
	 * Unload the current cursor graphic. If the current cursor is visible,
	 * then the default system cursor is loaded up to replace the old one.
	 */
	public function unload():Void
	{
		if (cursor != null)
		{
			if (cursorContainer.visible)
			{
				load();
			}
			else
			{
				cursor = FlxDestroyUtil.removeChild(cursorContainer, cursor);
			}
		}
	}

	/**
	 * Clean up memory. Internal use only.
	 */
	@:noCompletion
	public function destroy():Void
	{
		if (_stage != null)
		{
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, _leftButton.onDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _leftButton.onUp);

			#if FLX_MOUSE_ADVANCED
			_stage.removeEventListener(untyped MouseEvent.MIDDLE_MOUSE_DOWN, _middleButton.onDown);
			_stage.removeEventListener(untyped MouseEvent.MIDDLE_MOUSE_UP, _middleButton.onUp);
			_stage.removeEventListener(untyped MouseEvent.RIGHT_MOUSE_DOWN, _rightButton.onDown);
			_stage.removeEventListener(untyped MouseEvent.RIGHT_MOUSE_UP, _rightButton.onUp);

			_stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			#end

			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		cursorContainer = null;
		cursor = null;

		_leftButton = FlxDestroyUtil.destroy(_leftButton);
		#if FLX_MOUSE_ADVANCED
		_middleButton = FlxDestroyUtil.destroy(_middleButton);
		_rightButton = FlxDestroyUtil.destroy(_rightButton);
		#end

		_cursorBitmapData = FlxDestroyUtil.dispose(_cursorBitmapData);
		FlxG.signals.postGameStart.remove(onGameStart);
	}

	/**
	 * Resets the just pressed/just released flags and sets mouse to not pressed.
	 */
	public function reset():Void
	{
		_leftButton.reset();

		#if FLX_MOUSE_ADVANCED
		_middleButton.reset();
		_rightButton.reset();
		#end
	}

	/**
	 * @param   cursorContainer   The cursor container sprite passed by FlxGame
	 */
	@:allow(flixel.FlxG)
	function new(cursorContainer:Sprite)
	{
		super();
		this.cursorContainer = cursorContainer;
		this.cursorContainer.mouseChildren = false;
		this.cursorContainer.mouseEnabled = false;

		_leftButton = new FlxMouseButton(FlxMouseButtonID.LEFT);

		_stage = Lib.current.stage;
		_stage.addEventListener(MouseEvent.MOUSE_DOWN, _leftButton.onDown);
		_stage.addEventListener(MouseEvent.MOUSE_UP, _leftButton.onUp);

		#if FLX_MOUSE_ADVANCED
		_middleButton = new FlxMouseButton(FlxMouseButtonID.MIDDLE);
		_rightButton = new FlxMouseButton(FlxMouseButtonID.RIGHT);

		_stage.addEventListener(untyped MouseEvent.MIDDLE_MOUSE_DOWN, _middleButton.onDown);
		_stage.addEventListener(untyped MouseEvent.MIDDLE_MOUSE_UP, _middleButton.onUp);
		_stage.addEventListener(untyped MouseEvent.RIGHT_MOUSE_DOWN, _rightButton.onDown);
		_stage.addEventListener(untyped MouseEvent.RIGHT_MOUSE_UP, _rightButton.onUp);

		_stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		#end

		_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

		FlxG.signals.postGameStart.add(onGameStart);
		Mouse.hide();
	}

	/**
	 * Called by the internal game loop to update the mouse pointer's position in the game world.
	 * Also updates the just pressed/just released flags.
	 */
	function update():Void
	{
		_prevX = x;
		_prevY = y;
		_prevScreenX = screenX;
		_prevScreenY = screenY;

		#if !FLX_UNIT_TEST // Travis segfaults when game.mouseX / Y is accessed
		setGlobalScreenPositionUnsafe(FlxG.game.mouseX, FlxG.game.mouseY);

		// actually position the flixel mouse cursor graphic
		if (visible)
		{
			cursorContainer.x = FlxG.game.mouseX;
			cursorContainer.y = FlxG.game.mouseY;
		}
		#end

		// Update the buttons
		_leftButton.update();
		#if FLX_MOUSE_ADVANCED
		_middleButton.update();
		_rightButton.update();
		#end

		// Update the wheel
		if (!_wheelUsed)
		{
			wheel = 0;
		}
		_wheelUsed = false;
	}

	/**
	 * Called from the main Event.ACTIVATE that is dispatched in FlxGame
	 */
	function onFocus():Void
	{
		reset();

		set_useSystemCursor(useSystemCursor);

		visible = _visibleWhenFocusLost;
	}

	/**
	 * Called from the main Event.DEACTIVATE that is dispatched in FlxGame
	 */
	function onFocusLost():Void
	{
		_visibleWhenFocusLost = visible;

		if (visible)
		{
			visible = false;
		}

		Mouse.show();
	}

	function onGameStart():Void
	{
		// Call set_visible with the value visible has been initialized with
		// (unless set in create() of the initial state)
		set_visible(visible);
	}

	/**
	 * Internal event handler for input and focus.
	 */
	function onMouseWheel(flashEvent:MouseEvent):Void
	{
		if (enabled)
		{
			_wheelUsed = true;
			wheel = flashEvent.delta;
		}
	}

	#if FLX_MOUSE_ADVANCED
	/**
	 * We're detecting the mouse leave event to prevent a bug where `pressed` remains true
	 * for the middle and right mouse button when pressed and dragged outside the window.
	 */
	inline function onMouseLeave(_):Void
	{
		_rightButton.onUp();
		_middleButton.onUp();
	}
	#end

	inline function get_justMoved():Bool
		return _prevX != x || _prevY != y;

	inline function get_deltaX():Int
		return x - _prevX;

	inline function get_deltaY():Int
		return y - _prevY;

	inline function get_deltaScreenX():Int
		return screenX - _prevScreenX;

	inline function get_deltaScreenY():Int
		return screenY - _prevScreenY;

	inline function get_pressed():Bool
		return _leftButton.pressed;

	inline function get_justPressed():Bool
		return _leftButton.justPressed;

	inline function get_released():Bool
		return _leftButton.released;

	inline function get_justReleased():Bool
		return _leftButton.justReleased;

	inline function get_justPressedTimeInTicks():Float
		return _leftButton.justPressedTimeInTicks;

	#if FLX_MOUSE_ADVANCED
	inline function get_pressedRight():Bool
		return _rightButton.pressed;

	inline function get_justPressedRight():Bool
		return _rightButton.justPressed;

	inline function get_releasedRight():Bool
		return _rightButton.released;

	inline function get_justReleasedRight():Bool
		return _rightButton.justReleased;

	inline function get_justPressedTimeInTicksRight():Float
		return _rightButton.justPressedTimeInTicks;

	inline function get_pressedMiddle():Bool
		return _middleButton.pressed;

	inline function get_justPressedMiddle():Bool
		return _middleButton.justPressed;

	inline function get_releasedMiddle():Bool
		return _middleButton.released;

	inline function get_justReleasedMiddle():Bool
		return _middleButton.justReleased;

	inline function get_justPressedTimeInTicksMiddle():Float
		return _middleButton.justPressedTimeInTicks;
	#end

	function showSystemCursor():Void
	{
		cursorContainer.visible = false;

		Mouse.show();
	}

	function hideSystemCursor():Void
	{
		Mouse.hide();

		if (visible)
		{
			cursorContainer.visible = true;
		}
	}

	function set_useSystemCursor(value:Bool):Bool
	{
		if (value)
		{
			showSystemCursor();
		}
		else
		{
			hideSystemCursor();
		}
		return useSystemCursor = value;
	}

	function showCursor():Void
	{
		if (useSystemCursor)
		{
			Mouse.show();
		}
		else
		{
			if (cursor == null)
				load();

			cursorContainer.visible = true;
			Mouse.hide();
		}
	}

	function hideCursor():Void
	{
		cursorContainer.visible = false;
		Mouse.hide();
	}

	function set_visible(value:Bool):Bool
	{
		if (value)
			showCursor();
		else
			hideCursor();

		return visible = value;
	}

	inline function get__cursor()
	{
	    return cursor;
	}
	
	inline function set__cursor(value:Bitmap)
	{
	    return cursor = value;
	}
}
#end
