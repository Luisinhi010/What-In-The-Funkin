package funkin.play.modchartSystem.modifiers;

import funkin.play.notes.Strumline;
import funkin.play.notes.StrumlineNote;
import funkin.play.modchartSystem.NoteData;
import funkin.play.modchartSystem.modifiers.BaseModifier;
import funkin.play.PlayState;
import flixel.math.FlxMath;
import lime.math.Vector4;

// Culling mods. 0 is no cull (normal), 1 for cull backside, -1 for cull frontside
class CullAllModifier extends Modifier
{
  public function new(name:String)
  {
    super(name, 0);
    unknown = false;
    strumsMod = true;
    modPriority = 0;
  }

  override function strumMath(data:NoteData, strumLine:Strumline):Void
  {
    if (currentValue > 2)
    {
      data.whichStrumNote.strumExtraModData.cullMode = "always_positive";
      data.whichStrumNote.strumExtraModData.cullModeSustain = "always_positive";
      data.whichStrumNote.strumExtraModData.cullModeNotes = "always_positive";
      return;
    }
    else if (currentValue < -2)
    {
      data.whichStrumNote.strumExtraModData.cullMode = "always_negative";
      data.whichStrumNote.strumExtraModData.cullModeSustain = "always_negative";
      data.whichStrumNote.strumExtraModData.cullModeNotes = "always_negative";
    }
    else if (currentValue > 0)
    {
      data.whichStrumNote.strumExtraModData.cullMode = "positive";
      data.whichStrumNote.strumExtraModData.cullModeSustain = "positive";
      data.whichStrumNote.strumExtraModData.cullModeNotes = "positive";
    }
    else if (currentValue < 0)
    {
      data.whichStrumNote.strumExtraModData.cullMode = "negative";
      data.whichStrumNote.strumExtraModData.cullModeSustain = "negative";
      data.whichStrumNote.strumExtraModData.cullModeNotes = "negative";
    }
    else
    {
      data.whichStrumNote.strumExtraModData.cullMode = "none";
      data.whichStrumNote.strumExtraModData.cullModeSustain = "none";
      data.whichStrumNote.strumExtraModData.cullModeNotes = "none";
    }
  }
}

class CullNotesModifier extends Modifier
{
  public function new(name:String)
  {
    super(name, 0);
    unknown = false;
    strumsMod = true;
    modPriority = -1;
  }

  override function strumMath(data:NoteData, strumLine:Strumline):Void
  {
    if (currentValue > 0)
    {
      data.whichStrumNote.strumExtraModData.cullModeNotes = "positive";
    }
    else if (currentValue < 0)
    {
      data.whichStrumNote.strumExtraModData.cullModeNotes = "negative";
    }
    else
    {
      data.whichStrumNote.strumExtraModData.cullModeNotes = "none";
    }
  }
}

class CullSustainModifier extends Modifier
{
  public function new(name:String)
  {
    super(name, 0);
    unknown = false;
    strumsMod = true;
    modPriority = -1;
  }

  override function strumMath(data:NoteData, strumLine:Strumline):Void
  {
    if (currentValue > 0)
    {
      data.whichStrumNote.strumExtraModData.cullModeSustain = "positive";
    }
    else if (currentValue < 0)
    {
      data.whichStrumNote.strumExtraModData.cullModeSustain = "negative";
    }
    else
    {
      data.whichStrumNote.strumExtraModData.cullModeSustain = "none";
    }
  }
}

class CullStrumModifier extends Modifier
{
  public function new(name:String)
  {
    super(name, 0);
    unknown = false;
    strumsMod = true;
    modPriority = -1;
  }

  override function strumMath(data:NoteData, strumLine:Strumline):Void
  {
    if (currentValue > 0)
    {
      data.whichStrumNote.strumExtraModData.cullMode = "positive";
    }
    else if (currentValue < 0)
    {
      data.whichStrumNote.strumExtraModData.cullMode = "negative";
    }
    else
    {
      data.whichStrumNote.strumExtraModData.cullMode = "none";
    }
  }
}
