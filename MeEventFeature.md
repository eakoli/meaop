# Introduction #
An event system consists of 3 main entities: dispatchers, listeners, and event objects. Event dispatchers are objects that dispatch events to objects that are registered as listeners. An example UML of the distribution of event objects between dispatchers and listeners can be seen below.

![http://meaop.googlecode.com/svn/wiki/event_uml.jpg](http://meaop.googlecode.com/svn/wiki/event_uml.jpg)

Sample Event Object UML - The black diamond indicates that the Event Dispatcher creates event objects, which are then used (as indicated by the white diamonds) by three Listeners.

  * TMeCustomEventFeature: the abstract multicast event feature class.
  * TMeWindowMessageFeature: the windows message multi-cast event feature class.


# TMeWindowMessageFeature #

add the ability to multi-cast windows message.

## Usage ##

  1. first register the control and the message your wanna monitor to the event center.
    1. vEventInfo := GMeWindowMessageFeature.RegisterEvent(yourControl, WM\_CHAR);
  1. then add the listeners to the event info:
    1. vEventInfo.AddListener(aControl1);
    1. vEventInfo.AddListener(aControl2);

that's all, now the aControl1 and aControl2 will be triggered the WM\_CHAR message if the WM\_Char message occur on yourControl.

## Example ##
```
  TTestListener = class
  protected
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
  public
  end;

var
  aControl1, aControl2: TTestListener;
begin
  vEventInfo := GMeWindowMessageFeature.RegisterEvent(yourControl, WM_CHAR);
  vEventInfo.AddListener(aControl1);
  vEventInfo.AddListener(aControl2);
end;

```