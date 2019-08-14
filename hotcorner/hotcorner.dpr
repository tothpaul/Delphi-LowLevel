program hotcorner;

// Delphi Version by Paul TOTH <contact@execute.fr>
// based on https://github.com/taviso/hotcorner

// This is a **very** minimal hotcorner app, written in C. Maybe its not the
// optimal way to do this, but it works for me.
//
// Zero state is stored anywhere, no registry keys or configuration files.
//
// - If you want to configure something, edit the code.
// - If you want to uninstall it, just delete it.
//
// Tavis Ormandy <taviso@cmpxchg8b.com> December, 2016
//
// https://github.com/taviso/hotcorner
//

// If the mouse enters this rectangle, activate the hot corner function.
// There are some hints about changing corners here
//      https://github.com/taviso/hotcorner/issues/7#issuecomment-269367351

uses
  System.Types,
  Winapi.Windows,
  Winapi.Messages;

const
// If the mouse enters this rectangle, activate the hot corner function.
// There are some hints about changing corners here
//      https://github.com/taviso/hotcorner/issues/7#issuecomment-269367351
  kHotCorner: TRect = (
    Left  : -20;
    Top   : -20;
    Right : +20;
    Bottom: +20
  );

var
// Input to inject when corner activated (Win+Tab by default).
  kCornerInput: array[0..3] of TInput = (
    (IType: INPUT_KEYBOARD; ki: (wVk: VK_LWIN; dwFlags: 0)),
    (IType: INPUT_KEYBOARD; ki: (wVk: VK_TAB;  dwFlags: 0)),
    (IType: INPUT_KEYBOARD; ki: (wVk: VK_TAB;  dwFlags: KEYEVENTF_KEYUP)),
    (IType: INPUT_KEYBOARD; ki: (wVk: VK_LWIN; dwFlags: KEYEVENTF_KEYUP))
  );

const
// How long cursor has to linger in the kHotCorner RECT to trigger input.
  kHotDelay = 300;

// You can exit the application using the hot key CTRL+ALT+C by default, if it
// interferes with some application you're using (e.g. a full screen game).
  kHotKeyModifiers = MOD_CONTROL or MOD_ALT;
  kHotKey          = Ord('C');

var
  CornerThread: THandle = INVALID_HANDLE_VALUE;

function KEYDOWN(Key: Byte): Boolean; inline;
begin
  Result := Key and $80 > 0;
end;

// This thread runs when the cursor enters the hot corner, and waits to see if the cursor stays in the corner.
// If the mouse leaves while we're waiting, the thread is just terminated.
function CornerHotFunc(lpParameter: Pointer): WORD; stdcall;
var
  KeyState: TKeyboardState;
  Point   : TPoint;
begin
  Sleep(kHotDelay);

  // Check if a mouse putton is pressed, maybe a drag operation?
  if (GetKeyState(VK_LBUTTON) < 0) or (GetKeyState(VK_RBUTTON) < 0) then
  begin
    Exit(0);
  end;

  // Check if any modifier keys are pressed.
  if (GetKeyboardState(KeyState)) then
  begin
    if (KEYDOWN(KeyState[VK_SHIFT]) or KEYDOWN(KeyState[VK_CONTROL])
      or KEYDOWN(KeyState[VK_MENU]) or KEYDOWN(KeyState[VK_LWIN])
      or KEYDOWN(KeyState[VK_RWIN])) then
        Exit(0);
  end;

  // Verify the corner is still hot
  if (GetCursorPos(Point) = FALSE) then
  begin
    Exit(1);
  end;

  // Check co-ordinates.
  if (PtInRect(&kHotCorner, Point)) then
  begin
    if (SendInput(Length(kCornerInput), kCornerInput[0], SizeOf(TInput)) <> Length(kCornerInput)) then
    begin
      Exit(1);
    end;
  end;

  Result := 0;
end;

function MouseHookCallback(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  evt: PMouseHookStruct;
  id : DWORD;
begin
  evt := PMouseHookStruct(lParam);

  // If the mouse hasn't moved, we're done.
  if (wParam = WM_MOUSEMOVE) then
  begin

    // Check if the cursor is hot or cold.
    if (not PtInRect(kHotCorner, evt.pt)) then
    begin

        // The corner is cold, and was cold before.
        if (CornerThread <> INVALID_HANDLE_VALUE) then
        begin

          // The corner is cold, but was previously hot.
          TerminateThread(CornerThread, 0);

          CloseHandle(CornerThread);

          // Reset state.
          CornerThread := INVALID_HANDLE_VALUE;

        end;

    end else begin

      // The corner is hot, check if it was already hot.
      if (CornerThread = INVALID_HANDLE_VALUE) then
      begin

        // Check if a mouse putton is pressed, maybe a drag operation?
        if (GetKeyState(VK_LBUTTON) > 0) or (GetKeyState(VK_RBUTTON) > 0) then
        begin
          // The corner is hot, and was previously cold. Here we start a thread to
          // monitor if the mouse lingers.
          IsMultiThread := True;
          CornerThread := CreateThread(nil, 0, @CornerHotFunc, nil, 0, id);
        end;

      end;

    end;

  end;

  Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

var
  MouseHook: HHOOK;
  Msg: TMsg;
begin
  MouseHook := SetWindowsHookEx(WH_MOUSE_LL, MouseHookCallback, 0, 0);
  if MouseHook = 0 then
    Halt(1);

  RegisterHotKey(0, 1, kHotKeyModifiers, kHotKey);

  while GetMessage(Msg, 0, 0, 0) do
  begin
    if Msg.message = WM_HOTKEY then
      Break;
    DispatchMessage(Msg);
  end;

  UnhookWindowsHookEx(MouseHook);
end.
