package funkin.ui;

import flixel.addons.transition.FlxTransitionableSubState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import funkin.ui.mainmenu.MainMenuState;
import flixel.util.FlxColor;
import funkin.modding.events.ScriptEvent;
import funkin.modding.IScriptedClass.IEventHandler;
import funkin.modding.module.ModuleHandler;
import funkin.modding.PolymodHandler;
import funkin.util.SortUtil;
import flixel.util.FlxSort;
import funkin.input.Controls;

/**
 * MusicBeatSubState reincorporates the functionality of MusicBeatState into an FlxSubState.
 */
class MusicBeatSubState extends FlxSubState implements IEventHandler
{
  public var leftWatermarkText:FlxText = null;
  public var rightWatermarkText:FlxText = null;

  public function new(bgColor:FlxColor = FlxColor.TRANSPARENT)
  {
    super();
    this.bgColor = bgColor;
  }

  var controls(get, never):Controls;

  inline function get_controls():Controls
    return PlayerSettings.player1.controls;

  override function create():Void
  {
    super.create();

    createWatermarkText();

    Conductor.beatHit.add(this.beatHit);
    Conductor.stepHit.add(this.stepHit);
  }

  public override function destroy():Void
  {
    super.destroy();
    Conductor.beatHit.remove(this.beatHit);
    Conductor.stepHit.remove(this.stepHit);
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    // Rebindable volume keys.
    if (controls.VOLUME_MUTE) FlxG.sound.toggleMuted();
    else if (controls.VOLUME_UP) FlxG.sound.changeVolume(0.1);
    else if (controls.VOLUME_DOWN) FlxG.sound.changeVolume(-0.1);

    // Emergency exit button.
    if (FlxG.keys.justPressed.F4) FlxG.switchState(() -> new MainMenuState());

    // This can now be used in EVERY STATE YAY!
    if (FlxG.keys.justPressed.F5) debug_refreshModules();

    // Display Conductor info in the watch window.
    FlxG.watch.addQuick("musicTime", FlxG.sound.music?.time ?? 0.0);
    Conductor.watchQuick();

    dispatchEvent(new UpdateScriptEvent(elapsed));
  }

  function debug_refreshModules()
  {
    PolymodHandler.forceReloadAssets();

    // Restart the current state, so old data is cleared.
    FlxG.resetState();
  }

  /**
   * Refreshes the state, by redoing the render order of all sprites.
   * It does this based on the `zIndex` of each prop.
   */
  public function refresh()
  {
    sort(SortUtil.byZIndex, FlxSort.ASCENDING);
  }

  /**
   * Called when a step is hit in the current song.
   * Continues outside of PlayState, for things like animations in menus.
   * @return Whether the event should continue (not canceled).
   */
  public function stepHit():Bool
  {
    var event:ScriptEvent = new SongTimeScriptEvent(SONG_STEP_HIT, Conductor.instance.currentBeat, Conductor.instance.currentStep);

    dispatchEvent(event);

    if (event.eventCanceled) return false;

    return true;
  }

  /**
   * Called when a beat is hit in the current song.
   * Continues outside of PlayState, for things like animations in menus.
   * @return Whether the event should continue (not canceled).
   */
  public function beatHit():Bool
  {
    var event:ScriptEvent = new SongTimeScriptEvent(SONG_BEAT_HIT, Conductor.instance.currentBeat, Conductor.instance.currentStep);

    dispatchEvent(event);

    if (event.eventCanceled) return false;

    return true;
  }

  public function dispatchEvent(event:ScriptEvent)
  {
    ModuleHandler.callEvent(event);
  }

  function createWatermarkText():Void
  {
    // Both have an xPos of 0, but a width equal to the full screen.
    // The rightWatermarkText is right aligned, which puts the text in the correct spot.
    leftWatermarkText = new FlxText(0, FlxG.height - 18, FlxG.width, '', 12);
    rightWatermarkText = new FlxText(0, FlxG.height - 18, FlxG.width, '', 12);

    // 100,000 should be good enough.
    leftWatermarkText.zIndex = 100000;
    rightWatermarkText.zIndex = 100000;
    leftWatermarkText.scrollFactor.set(0, 0);
    rightWatermarkText.scrollFactor.set(0, 0);
    leftWatermarkText.setFormat('VCR OSD Mono', 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    rightWatermarkText.setFormat('VCR OSD Mono', 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

    add(leftWatermarkText);
    add(rightWatermarkText);
  }

  /**
   * Close this substate and replace it with a different one.
   */
  public function switchSubState(substate:FlxSubState):Void
  {
    this.close();
    this._parentState.openSubState(substate);
  }
}
