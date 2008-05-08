unit uMeThreadTest;

{$I MeSetting.inc}

{.$DEFINE Debug_WriteToConsole_Support}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows, //QueryPerformanceCounter
  {$ENDIF}
  {$IFDEF DEBUG}
  DbugIntf,
  {$ENDIF}
  Classes,
  SysUtils,
  TypInfo,
  IniFiles,
  //Dialogs,
  TestFramework
  , uMeObject
  , uMeStrUtils
  , uMeThread
  ;

type
  PMeT = ^TMeT;
  TMeT = object(TMeAbstractThread)
  protected
    procedure Execute;virtual;//override;
  public
  end;

  TTest_MeCustomThread = class(TTestCase)
  protected
    FThread: PMeAbstractThread;

    procedure Setup;override;
    procedure TearDown;override;

  public
  published
    procedure Test_Run;
  end;

implementation


var
  AppPath: string;
  FCount: Integer = 0;


procedure TMeT.Execute;
var
  S: string;
begin
  while (InterlockedIncrement(FCount) > 0) and not Terminated do
    Sleep(100);
  S := 'Hallo, I''m executed in the main thread:';
  Assert(GetCurrentThreadId <> MainThreadId);
  EnterMainThread;
  try
    Assert(GetCurrentThreadId = MainThreadId);
    //Writeln(S, GetCurrentThreadId = MainThreadId);
  finally
    LeaveMainThread;
  end;
  Assert(GetCurrentThreadId <> MainThreadId);
end;

{ TTest_MeCustomThread }
procedure TTest_MeCustomThread.Setup;
begin
  FThread := New(PMeT, Create(True));
end;

procedure TTest_MeCustomThread.TearDown;
begin
  //FThread.Terminate;
  //wait for thread Terminated.
  //FThread.WaitFor;
  //Sleep(100); 
  MeFreeAndNil(FThread);
end;

procedure TTest_MeCustomThread.Test_Run();
var
  I: Integer;
begin
  FThread.Priority := tpTimeCritical;
  FThread.Resume;
  Sleep(50);
  I := -1;
  I := InterlockedExchange(FCount, I);
  //FThread.Terminate;
  CheckEquals(1, I, ' the count is error.');
end;

Initialization

  AppPath := ExtractFilePath(ParamStr(0));
  RegisterTests('MeThread suites',
                [
                 TTest_MeCustomThread.Suite
                 //, TTest_MeCustomThread.Suite
                ]);//}
finalization
end.