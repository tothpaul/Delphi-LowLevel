unit Execute.Android;

{
   (c)2018 Execute SARL

   Embarcadero made a lot of changes in Androidapi.*.pas
   the purpose of this unit is to be stable along Delphi versions

   created for Delphi Tokyo 10.2.3
   tested on Delphi Berlin 10.1

   http://www.execute.fr

}

{
  when exiting application there's a warning abur DetachCurrentThread not called...but don't know where AttachCurrentThread is called :)
}

interface

uses
  System.Types,
  System.SysUtils;

type
  GLint = Integer;
  GLsizei = Integer;
  GLfloat = Single; // khronos_float_t;
  PGLfloat = ^GLfloat;
  PGLvoid = Pointer;
  GLenum = UInt32;
  GLbitfield = UInt32;
  GLclampf = Single; // khronos_float_t;

  EGLDisplay = Pointer;
  EGLSurface = Pointer;
  EGLContext = Pointer;
  EGLConfig  = Pointer;
  EGLNativeDisplayType = Pointer;

  PEGLConfig = ^EGLConfig;

  EGLint = Integer;
  PEGLint = ^EGLint;
  EGLBoolean = UInt32;

const
  libEGL = '/usr/lib/libEGL.so';
  EGL_NO_DISPLAY = nil;
  EGL_NO_SURFACE = nil;
  EGL_NO_CONTEXT = nil;
  EGL_DEFAULT_DISPLAY = nil;

  EGL_FALSE = 0;
  EGL_TRUE = 1;

  EGL_BLUE_SIZE = $3022;
  EGL_GREEN_SIZE = $3023;
  EGL_RED_SIZE = $3024;
  EGL_DEPTH_SIZE = $3025;

  EGL_NATIVE_VISUAL_ID = $302E;

  EGL_NONE = $3038;

  EGL_HEIGHT = $3056;
  EGL_WIDTH = $3057;

function eglGetDisplay(DisplayId: EGLNativeDisplayType): EGLDisplay; cdecl;
  external libEGL;
function eglInitialize(Display: EGLDisplay; Major, Minor: PEGLint): EGLBoolean; cdecl;
  external libEGL;
function eglChooseConfig(Display: EGLDisplay; AttributeList: PEGLint; Configs: PEGLConfig; ConfigSize: EGLint; ConfigCount: PEGLint): EGLBoolean; cdecl;
  external libEGL;
function eglGetConfigAttrib(Display: EGLDisplay; Config: EGLConfig; Attribute: EGLint; Value: PEGLint): EGLBoolean; cdecl;
  external libEGL;
function eglDestroyContext(Display: EGLDisplay; Context: EGLContext): EGLBoolean; cdecl;
  external libEGL;
function eglDestroySurface(Display: EGLDisplay; Surface: EGLSurface): EGLBoolean; cdecl;
  external libEGL;
function eglTerminate(Display: EGLDisplay): EGLBoolean; cdecl;
  external libEGL;
function eglSwapBuffers(Display: EGLDisplay; Surface: EGLSurface): EGLBoolean; cdecl;
  external libEGL;

const
  APP_CMD_INPUT_CHANGED  = 0;
  APP_CMD_INIT_WINDOW    = 1;
  APP_CMD_TERM_WINDOW    = 2;
  APP_CMD_GAINED_FOCUS   = 6;
  APP_CMD_LOST_FOCUS     = 7;
  APP_CMD_CONFIG_CHANGED = 8;
  APP_CMD_LOW_MEMORY     = 9;
  APP_CMD_START          = 10;
  APP_CMD_RESUME         = 11;
  APP_CMD_SAVE_STATE     = 12;
  APP_CMD_PAUSE          = 13;
  APP_CMD_STOP           = 14;
  APP_CMD_DESTROY        = 15;

function LOGI(const Text: string): Integer;

const
  liblog = '/usr/lib/liblog.so';

// Androidapi.Log
type
  android_LogPriority = (
    ANDROID_LOG_UNKNOWN,
    ANDROID_LOG_DEFAULT,
    ANDROID_LOG_VERBOSE,
    ANDROID_LOG_DEBUG,
    ANDROID_LOG_INFO,
    ANDROID_LOG_WARN,
    ANDROID_LOG_ERROR,
    ANDROID_LOG_FATAL,
    ANDROID_LOG_SILENT
 );

function __android_log_write(Priority: android_LogPriority; const Tag, Text: MarshaledAString): Integer; cdecl;
  external liblog;

// Androidapi.NativeActivity

type
  size_t = Cardinal;
  ssize_t = Integer;
  Psize_t = PCardinal; // ^size_t;

  PANativeWindow = Pointer;
  PAInputQueue = Pointer;

  ARect = TRect;
  PARect = ^ARect;

  PANativeActivity = ^ANativeActivity;
  PANativeActivityCallbacks = ^ANativeActivityCallbacks;

  TOnActivityCallback  = procedure(Activity: PANativeActivity); cdecl;
  TOnSaveInstanceStateCallback = function(Activity: PANativeActivity; OutSize: Psize_t): Pointer; cdecl;
  TOnWindowFocusChangedCallback = procedure(Activity: PANativeActivity; HasFocus: Integer); cdecl;
  TOnNativeWindowCallback = procedure(Activity: PANativeActivity; Window: PANativeWindow); cdecl;
  TOnInputQueueCallback = procedure(Activity: PANativeActivity; Queue: PAInputQueue); cdecl;
  TOnContentRectChangedCallback = procedure(Activity: PANativeActivity; Rect: PARect); cdecl;
  TOnConfigurationChangedCallback = procedure(Activity: PANativeActivity); cdecl;

  ANativeActivityCallbacks = record
    onStart                    : TOnActivityCallback;
    onResume                   : TOnActivityCallback;
    onSaveInstanceState        : TOnSaveInstanceStateCallback;
    onPause                    : TOnActivityCallback;
    onStop                     : TOnActivityCallback;
    onDestroy                  : TOnActivityCallback;
    onWindowFocusChanged       : TOnWindowFocusChangedCallback;
    onNativeWindowCreated      : TOnNativeWindowCallback;
    onNativeWindowResized      : TOnNativeWindowCallback;
    onNativeWindowRedrawNeeded : TOnNativeWindowCallback;
    onNativeWindowDestroyed    : TOnNativeWindowCallback;
    onInputQueueCreated        : TOnInputQueueCallback;
    onInputQueueDestroyed      : TOnInputQueueCallback;
    onContentRectChanged       : TOnContentRectChangedCallback;
    onConfigurationChanged     : TOnConfigurationChangedCallback;
    onLowMemory                : TOnActivityCallback;
  end;

  ANativeActivity = record
    callbacks        : PANativeActivityCallbacks;
    vm               : Pointer; // PJavaVM;
    env              : Pointer; // PJNIEnv;
    clazz            : Pointer; // JNIObject;
    internalDataPath : MarshaledAString;
    externalDataPath : MarshaledAString;
    sdkVersion       : Int32;
    instance         : Pointer;
    assetManager     : Pointer; // PAAssetManager;
  end;

const
  libc = '/system/lib/libc.so';

  __PTHREAD_ATTR_SIZE = 36;
  PTHREAD_CREATE_DETACHED = $2;

type
  pthread_t = LongWord;
  Ppthread_attr_t = ^pthread_attr_t;
  pthread_attr_t = record
    __sig: LongInt;
    opaque: array [0..__PTHREAD_ATTR_SIZE - 1] of Byte;
  end;
  TPThreadFunc = function(Parameter: Pointer): Pointer; cdecl;
  pthread_mutex_t = Pointer;
  Ppthread_mutexattr_t = Pointer;
  pthread_cond_t = Pointer;
  Ppthread_condattr_t = Pointer;

function malloc(size: size_t): Pointer; cdecl; external libc;
procedure _free(p: Pointer); cdecl; external libc name 'free';
procedure _exit(ExitCode: Integer); cdecl; external libc name 'exit';

function pthread_attr_init(var Attr: pthread_attr_t): Integer; cdecl external libc;
function pthread_attr_setdetachstate(var Attr: pthread_attr_t; State: Integer): Integer; cdecl external libc;
function pthread_create(var Thread: pthread_t; var Attr: pthread_attr_t;
  TFunc: TPThreadFunc; Arg: Pointer): Integer; cdecl;
  external libc;
function pthread_mutex_init(var Mutex: pthread_mutex_t;
  Attr: Ppthread_mutexattr_t): Integer; cdecl; overload;
  external libc;
function pthread_cond_init(var Cond: pthread_cond_t; CondAttr: Ppthread_condattr_t): Integer; cdecl; overload;
  external libc;
function pthread_mutex_lock(var Mutex: pthread_mutex_t): Integer; cdecl;
  external libc;
function pthread_cond_wait(var Cond: pthread_cond_t; var Mutex: pthread_mutex_t): Integer; cdecl;
  external libc;
function pthread_mutex_unlock(var Mutex: pthread_mutex_t): Integer; cdecl;
  external libc;
function pthread_cond_broadcast(var Cond: pthread_cond_t): Integer; cdecl;
  external libc;
function pthread_cond_destroy(var Cond: pthread_cond_t): Integer; cdecl;
  external libc;
function pthread_mutex_destroy(var Mutex: pthread_mutex_t): Integer; cdecl;
  external libc;

function pipe(var PipeDes): Integer; cdecl;
  external libc;
function write(Handle: Integer; Buffer: Pointer; Count: size_t): ssize_t; cdecl;
  external libc;
function read(Handle: Integer; Buffer: Pointer; Count: size_t): ssize_t; cdecl;
  external libc;
function _close(filedes: Integer): Integer; cdecl;
  external libc name 'close';

const
  libdl = '/system/lib/libdl.so';

  RTLD_LAZY   = 1;

type
  dl_info = record
     dli_fname: MarshaledAString;
     dli_fbase: Pointer;
     dli_sname: MarshaledAString;
     dli_saddr: Pointer;
  end;

function dladdr(Address: NativeUInt; var Info: dl_info): Integer; cdecl;
  external libdl;
function dlopen(Filename: MarshaledAString; Flag: Integer): NativeUInt; cdecl;
  external libdl;
function dlsym(Handle: NativeUInt; Symbol: MarshaledAString): Pointer; cdecl;
  external libdl;
function dlclose(Handle: NativeUInt): Integer; cdecl;
  external libdl;

const
  libandroid = '/usr/lib/libandroid.so';

  LOOPER_ID_MAIN  = 1;
  LOOPER_ID_INPUT = 2;

  ALOOPER_EVENT_INPUT = 1 shl 0;

  ALOOPER_PREPARE_ALLOW_NON_CALLBACKS = 1 shl 0;

  AINPUT_EVENT_TYPE_KEY = 1;

  AKEYCODE_BACK = 4;

type
  PAConfiguration = Pointer;
  PAAssetManager = Pointer;
  PALooper = Pointer;
  ALooper_callbackFunc = Pointer;
  PAinputEvent = Pointer;
  PPAInputEvent = ^PAInputEvent;
  EGLNativeWindowType  = PANativeWindow;

function AConfiguration_new: PAConfiguration; cdecl;
  external libandroid;
procedure AConfiguration_fromAssetManager(OutConfig: PAConfiguration;AssetManager: PAAssetManager); cdecl;
  external libandroid;
procedure AConfiguration_delete(Config: PAConfiguration); cdecl;
  external libandroid;
function ALooper_prepare(Options: Integer): PALooper; cdecl;
  external libandroid;
function ALooper_addFd(Looper: PALooper; FileHandler, Ident, Events: Integer; Callback: ALooper_callbackFunc; Data: Pointer): Integer; cdecl;
  external libandroid;
procedure AInputQueue_attachLooper(const Queue: PAInputQueue; Looper: PALooper; Ident: Integer; Callback: ALooper_callbackFunc; Data: Pointer); cdecl;
  external libandroid;
procedure AInputQueue_detachLooper(const Queue: PAInputQueue); cdecl;
  external libandroid;
function AInputQueue_getEvent(const Queue: PAInputQueue; OutEvent: PPAInputEvent): Int32; cdecl;
  external libandroid;
function AInputEvent_getType(Event: PAinputEvent): Int32; cdecl;
  external libandroid;
function AKeyEvent_getKeyCode(KeyEvent: PAInputEvent): Int32; cdecl;
  external libandroid;
function AInputQueue_preDispatchEvent(const Queue: PAInputQueue; Event: PAinputEvent): Int32; cdecl;
  external libandroid;
procedure AInputQueue_finishEvent(const Queue: PAInputQueue; Event: PAinputEvent; Handled: Integer); cdecl;
  external libandroid;
function ALooper_pollAll(TimeOutMilliSeconds: Integer; OutFileDescriptor, OutEvents: PInteger; OutData: PPointer): Integer; cdecl;
  external libandroid;
function ANativeWindow_setBuffersGeometry(Window: PANativeWindow; Width, Height, Format: Int32): Int32; cdecl;
  external libandroid;
function eglCreateWindowSurface(Display: EGLDisplay; Config: EGLConfig; win: EGLNativeWindowType; AttributeList: PEGLint): EGLSurface; cdecl;
  external libandroid;
function eglCreateContext(Display: EGLDisplay; Config: EGLConfig; ShareContext: EGLContext; AttributeList: PEGLint): EGLContext; cdecl;
  external libandroid;
function eglMakeCurrent(Display: EGLDisplay; SurfaceToDraw, SurfaceToRead: EGLSurface; Context: EGLContext): EGLBoolean; cdecl;
  external libandroid;
function eglQuerySurface(Display: EGLDisplay; Surface: EGLSurface; Attribute: EGLint; Value: PEGLint): EGLBoolean; cdecl;
  external libandroid;

type
  TPipeDescriptors = record
    ReadDes : Integer;
    WriteDes: Integer;
  end;

  TApplicationStates = (
    Running,
    StateSaved,
    DestroyRequested,
    Destroyed,
    RedrawNeeded
  );

  TApplicationState = set of TApplicationStates;

  TAndroidApplication = class
    onAppCmd          : procedure(Cmd: ShortInt) of object;
    onInputEvent      : function(App: TAndroidApplication; Event: PAInputEvent): Int32; cdecl;

    Activity          : PANativeActivity;
    Config            : PAConfiguration;
    SavedState        : TBytes;
    Looper            : PALooper;

    Mutex             : pthread_mutex_t;
    Cond              : pthread_cond_t;
    Pipes             : TPipeDescriptors;
    Thread            : pthread_t;

    ActivityState     : Integer;
    State             : TApplicationState;

    InputQueue        : PAInputQueue;
    Window            : PANativeWindow;
    ContentRect       : ARect;

    PendingInputQueue : PAInputQueue;
    PendingWindow     : PANativeWindow;
    PendingContentRect: ARect;

    constructor Create(AActivity: PANativeActivity; ASavedState: Pointer; ASavedStateSize: size_t);
    destructor Destroy; override;
    function ThreadProc: Pointer; cdecl;
    procedure SetState(cmd: ShortInt);
    procedure WriteCmd(cmd: ShortInt);
    function ReadCmd: ShortInt;
    procedure FreeSavedState;
    procedure PreExecCmd(cmd: ShortInt);
    procedure PostExecCmd(cmd: ShortInt);
    procedure SetWindow(AWindow: PANativeWindow);
    procedure SetInput(AInputQueue: PAInputQueue);
    function SaveInstanceState(outLen: PCardinal): Pointer;
    procedure onDestroy;
    function ProcessMessages: Boolean;
    procedure ProcessCmd;
    procedure ProcessInput;
  end;

implementation

type
  AnsiString = TBytes;

function StrToAnsiString(const Str: string): AnsiString;
var
  len: Integer;
begin
  len := LocaleCharsFromUnicode(DefaultSystemCodePage, 0, PWideChar(Str), Length(Str) + 1, nil, 0, nil, nil);
  if len > 0 then
  begin
    SetLength(Result, Len);
    LocaleCharsFromUnicode(DefaultSystemCodePage, 0, PWideChar(Str), Length(Str) + 1, Pointer(Result),
      len, nil, nil);
  end else begin
    Result := nil;
  end;
end;

function LOGI(const Text: string): Integer;
var
  S: AnsiString;
begin
  S := StrToAnsiString(Text);
  Result := __android_log_write(android_LogPriority.ANDROID_LOG_INFO, 'info', Pointer(S));
end;

function LOGW(const Text: MarshaledAString): Integer;
begin
  Result := __android_log_write(android_LogPriority.ANDROID_LOG_WARN, 'warning', Text);
end;

procedure TAndroidApplication.FreeSavedState;
begin
  pthread_mutex_lock(mutex);
  SavedState := nil;
  pthread_mutex_unlock(mutex);
end;

function TAndroidApplication.ReadCmd: ShortInt;
var
  cmd: ShortInt;
begin
  if read(pipes.ReadDes, @cmd, SizeOf(cmd)) = SizeOf(cmd) then
  begin
    case cmd of
      APP_CMD_SAVE_STATE:
        FreeSavedState();
    end;
    Result := cmd;
  end else begin
    LOGW('Error reading command pipe');
    Result := -1;
  end;
end;

procedure TAndroidApplication.PreExecCmd(cmd: ShortInt);
begin
  case cmd of
    APP_CMD_INPUT_CHANGED:
      begin
        pthread_mutex_lock(mutex);
        if inputQueue <> nil then
          AInputQueue_detachLooper(inputQueue);
        inputQueue := pendingInputQueue;
        if inputQueue <> nil then
          AInputQueue_attachLooper(inputQueue, looper, LOOPER_ID_INPUT, nil, nil);
        pthread_cond_broadcast(cond);
        pthread_mutex_unlock(mutex);
      end;

    APP_CMD_INIT_WINDOW:
      begin
        pthread_mutex_lock(mutex);
        window := pendingWindow;
        pthread_cond_broadcast(cond);
        pthread_mutex_unlock(mutex);
      end;

    APP_CMD_TERM_WINDOW:
      pthread_cond_broadcast(cond);

    APP_CMD_RESUME, APP_CMD_START, APP_CMD_PAUSE, APP_CMD_STOP:
      begin
        pthread_mutex_lock(mutex);
        activityState := cmd;
        pthread_cond_broadcast(cond);
        pthread_mutex_unlock(mutex);
      end;

    APP_CMD_CONFIG_CHANGED:
      AConfiguration_fromAssetManager(config, activity^.assetManager);

    APP_CMD_DESTROY:
      Include(State, DestroyRequested);
  end;
end;

procedure TAndroidApplication.PostExecCmd(cmd: ShortInt);
begin
  case cmd of
    APP_CMD_TERM_WINDOW:
      begin
        pthread_mutex_lock(mutex);
        window := nil;
        pthread_cond_broadcast(cond);
        pthread_mutex_unlock(mutex);
      end;

    APP_CMD_SAVE_STATE:
      begin
        pthread_mutex_lock(mutex);
        Include(State, stateSaved);
        pthread_cond_broadcast(cond);
        pthread_mutex_unlock(mutex);
      end;

    APP_CMD_RESUME:
      { Delphi: It is unclear why this line is necessary in original AppGlue, but it prevents FireMonkey applications
        from recovering saved state. FireMonkey recovers saved state usually after APP_CMD_INIT_WINDOW, which happens
        much later after CMD_RESUME. }
      { free_saved_state(android_app) };
  end;
end;

function TAndroidApplication.ProcessMessages: Boolean;
begin
  if DestroyRequested in State then
    Result := False
  else begin
    case ALooper_pollAll(0, nil, nil, nil) of
      LOOPER_ID_MAIN  : ProcessCmd;
      LOOPER_ID_INPUT : ProcessInput;
    end;
    Result := True;
  end;
end;

procedure TAndroidApplication.ProcessCmd;
var
  cmd: ShortInt;
begin
  cmd := ReadCmd;
  PreExecCmd(cmd);
  if Assigned(onAppCmd) then
    onAppCmd(cmd);
  PostExecCmd(cmd);
end;

procedure TAndroidApplication.ProcessInput;
var
  event: PAInputEvent;
  handled: Int32;
  evType: Int32;
begin
  event := nil;
  while AInputQueue_getEvent(inputQueue, @event) >= 0 do
  begin
    { Delphi: when you press "Back" button to hide virtual keyboard, the keyboard does not disappear but we stop
      receiving events unless the following workaround is placed here.

      This seems to affect Android versions 4.1 and 4.2. }
    evType := AInputEvent_getType(event);
    if ((evType <> AINPUT_EVENT_TYPE_KEY) or (AKeyEvent_getKeyCode(event) <> AKEYCODE_BACK)) then
      if AInputQueue_preDispatchEvent(inputQueue, event) <> 0 then
        Continue;
    handled := 0;
    if Assigned(onInputEvent) then
      handled := onInputEvent(Self, event);
    AInputQueue_finishEvent(inputQueue, event, handled);
  end;
end;

// Delphi: init system unit and RTL.
procedure SystemEntry;
var
  Info: dl_info;
  Lib: NativeUInt;
  EntryPoint: procedure;
begin
  if dladdr(NativeUInt(@SystemEntry), Info) <> 0 then
  begin
    Lib := dlopen(Info.dli_fname, RTLD_LAZY);
    if Lib <> 0 then
    begin
      @EntryPoint := dlsym(Lib, '_NativeMain');
      dlclose(Lib);
      if @EntryPoint <> nil then
      begin
        EntryPoint();
      end;
    end;
  end;
end;

function TAndroidApplication.ThreadProc: Pointer;
begin
  config := AConfiguration_new;
  AConfiguration_fromAssetManager(config, activity^.assetManager);

  looper := ALooper_prepare(ALOOPER_PREPARE_ALLOW_NON_CALLBACKS);
  ALooper_addFd(looper, pipes.ReadDes, LOOPER_ID_MAIN, ALOOPER_EVENT_INPUT, nil, nil);

  pthread_mutex_lock(mutex);
  Include(State, Running);
  pthread_cond_broadcast(cond);
  pthread_mutex_unlock(mutex);

  { Delphi: this will initialize System and any RTL related functions, call unit initialization sections and then
    project main code, which will enter application main loop. This call will block until the loop ends, which is
    typically signalled by android_app^.destroyRequested. }
  SystemEntry;

  { This place would be ideal to call unit finalization, class destructors and so on. }
//  Halt;

  Result := nil;
end;

constructor TAndroidApplication.Create(AActivity: PANativeActivity; ASavedState: Pointer; ASavedStateSize: size_t);
var
  attr: pthread_attr_t;
  thread: pthread_t;
begin
  activity := AActivity;

  pthread_mutex_init(mutex, nil);
  pthread_cond_init(cond, nil);
  if ASavedState <> nil then
  begin
    SetLength(SavedState, ASavedStateSize);
    Move(PByte(ASavedState)^, SavedState[0], ASavedStateSize);
  end;

  pipe(pipes);

  pthread_attr_init(attr);
  pthread_attr_setdetachstate(attr, PTHREAD_CREATE_DETACHED);
  pthread_create(thread, attr, @TAndroidApplication.ThreadProc, Self);

  pthread_mutex_lock(mutex);
  while not (Running in State) do
    pthread_cond_wait(cond, mutex);
  pthread_mutex_unlock(mutex);
end;

destructor TAndroidApplication.Destroy;
begin
  LOGI('TAndroidApplication.Destroy');
  FreeSavedState();
  pthread_mutex_lock(mutex);
  if inputQueue <> nil then
    AInputQueue_detachLooper(inputQueue);
  AConfiguration_delete(config);
  Include(State, Destroyed);
  pthread_cond_broadcast(cond);
  pthread_mutex_unlock(mutex);
  inherited;
end;

procedure TAndroidApplication.WriteCmd(cmd: ShortInt);
begin
  if write(pipes.WriteDes, @cmd, SizeOf(cmd)) <> SizeOf(cmd) then
    LOGW('Failure writing android_app cmd!');
end;

procedure TAndroidApplication.SetInput(AInputQueue: PAInputQueue);
begin
  pthread_mutex_lock(mutex);
  pendingInputQueue := AInputQueue;
  WriteCmd(APP_CMD_INPUT_CHANGED);
  while inputQueue <> pendingInputQueue do
    pthread_cond_wait(cond, mutex);
  pthread_mutex_unlock(mutex);
end;

procedure TAndroidApplication.SetWindow(AWindow: PANativeWindow);
begin
  pthread_mutex_lock(mutex);
  if pendingWindow <> nil then
    WriteCmd(APP_CMD_TERM_WINDOW);
  pendingWindow := AWindow;
  if AWindow <> nil then
    WriteCmd(APP_CMD_INIT_WINDOW);
  while window <> pendingWindow do
    pthread_cond_wait(cond, mutex);
  pthread_mutex_unlock(mutex);
end;

procedure TAndroidApplication.SetState(cmd: ShortInt);
begin
  pthread_mutex_lock(mutex);
  WriteCmd(cmd);
  while activityState <> cmd do
    pthread_cond_wait(cond, mutex);
  pthread_mutex_unlock(mutex);
end;

function TAndroidApplication.SaveInstanceState(outLen: PCardinal): Pointer;
var
  Len: Integer;
begin
  Result := nil;
  pthread_mutex_lock(mutex);
  Exclude(State, StateSaved);
  WriteCmd(APP_CMD_SAVE_STATE);
  while not (stateSaved in State) do
    pthread_cond_wait(cond, mutex);
  Len := Length(SavedState);
  if Len > 0 then
  begin
    Result := malloc(Len);
    Move(SavedState[0], Result^, Len);
    outLen^ := Len;
    SavedState := nil;
  end;
  pthread_mutex_unlock(mutex);
end;

procedure TAndroidApplication.onDestroy;
begin
  pthread_mutex_lock(mutex);
  WriteCmd(APP_CMD_DESTROY);
  while not (destroyed in State) do
    pthread_cond_wait(cond, mutex);
  pthread_mutex_unlock(mutex);
  _close(pipes.ReadDes);
  _close(pipes.WriteDes);
  pthread_cond_destroy(cond);
  pthread_mutex_destroy(mutex);
  //android_app.Free; raise an error ?
  System.DelphiActivity := nil;
end;

procedure onDestroy(activity: PANativeActivity); cdecl;
begin
  TAndroidApplication(activity^.instance).onDestroy;
end;

procedure onStart(activity: PANativeActivity); cdecl;
begin
  TAndroidApplication(activity^.instance).setState(APP_CMD_START);
end;

procedure onResume(activity: PANativeActivity); cdecl;
begin
  TAndroidApplication(activity^.instance).setState(APP_CMD_RESUME);
end;

function onSaveInstanceState(activity: PANativeActivity; outLen: psize_t): Pointer; cdecl;
begin
  Result := TAndroidApplication(activity^.instance).SaveInstanceState(outLen);
end;

procedure onPause(activity: PANativeActivity); cdecl;
begin
  TAndroidApplication(activity^.instance).SetState(APP_CMD_PAUSE);
end;

procedure onStop(activity: PANativeActivity); cdecl;
begin
  TAndroidApplication(activity^.instance).SetState(APP_CMD_STOP);
end;

procedure onConfigurationChanged(activity: PANativeActivity); cdecl;
begin
  TAndroidApplication(activity^.instance).WriteCmd(APP_CMD_CONFIG_CHANGED);
end;

procedure onLowMemory(activity: PANativeActivity); cdecl;
begin
  TAndroidApplication(activity^.instance).WriteCmd(APP_CMD_LOW_MEMORY);
end;

procedure onWindowFocusChanged(activity: PANativeActivity; focused: Integer); cdecl;
begin
  if focused <> 0 then
    TAndroidApplication(activity^.instance).WriteCmd(APP_CMD_GAINED_FOCUS)
  else
    TAndroidApplication(activity^.instance).WriteCmd(APP_CMD_LOST_FOCUS);
end;

procedure onNativeWindowCreated(activity: PANativeActivity; window: PANativeWindow); cdecl;
begin
  TAndroidApplication(activity^.instance).SetWindow(window);
end;

procedure onNativeWindowDestroyed(activity: PANativeActivity; window: PANativeWindow); cdecl;
begin
  TAndroidApplication(activity^.instance).SetWindow(nil);
end;

procedure onInputQueueCreated(activity: PANativeActivity; queue: PAInputQueue); cdecl;
begin
  TAndroidApplication(activity^.instance).SetInput(queue);
end;

procedure onInputQueueDestroyed(activity: PANativeActivity; queue: PAInputQueue); cdecl;
begin
  TAndroidApplication(activity^.instance).SetInput(nil);
end;

procedure ANativeActivity_onCreate(activity: PANativeActivity; savedState: Pointer; savedStateSize: size_t); cdecl;
begin
  __android_log_write(android_LogPriority.ANDROID_LOG_INFO, 'info', 'ANativeActivity_onCreate');
  if System.DelphiActivity = nil then
  begin
    __android_log_write(android_LogPriority.ANDROID_LOG_INFO, 'info', 'Create TAndroidApplication');

    System.DelphiActivity := activity;
    System.JavaMachine := activity^.vm;
    System.JavaContext := activity^.clazz;

    activity^.callbacks^.onDestroy := @onDestroy;
    activity^.callbacks^.onStart := @onStart;
    activity^.callbacks^.onResume := @onResume;
    activity^.callbacks^.onSaveInstanceState := @onSaveInstanceState;
    activity^.callbacks^.onPause := @onPause;
    activity^.callbacks^.onStop := @onStop;
    activity^.callbacks^.onConfigurationChanged := @onConfigurationChanged;
    activity^.callbacks^.onLowMemory := @onLowMemory;
    activity^.callbacks^.onWindowFocusChanged := @onWindowFocusChanged;
    activity^.callbacks^.onNativeWindowCreated := @onNativeWindowCreated;
    activity^.callbacks^.onNativeWindowDestroyed := @onNativeWindowDestroyed;
    activity^.callbacks^.onInputQueueCreated := @onInputQueueCreated;
    activity^.callbacks^.onInputQueueDestroyed := @onInputQueueDestroyed;

    activity^.instance := TAndroidApplication.Create(activity, savedState, savedStateSize);
  end;
end;

exports
  ANativeActivity_onCreate;
end.
