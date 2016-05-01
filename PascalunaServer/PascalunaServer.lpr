{$mode objfpc}{$H+}

uses
  { 1 }
  {$ifdef unix}cthreads,{$endif}
  Classes,SysUtils,Sockets,fpAsync,fpSock;

type
  { 2 }
  TClientHandlerThread = class(TThread)
  private
    FClientStream: TSocketStream;
  public
    constructor Create(AClientStream: TSocketStream);
    procedure Execute; override;
  end;
  { 3 }
  TTestServer = class(TTCPServer)
  private
    procedure TestOnConnect(Sender: TConnectionBasedSocket; AStream: TSocketStream);
  public
    constructor Create(AOwner: TComponent); override;
  end;
{ 4 }
function AddrToString(Addr: TSockAddr): String;
begin
  Result := NetAddrToStr(Addr.sin_addr) + ':' + IntToStr(Addr.sin_port);
end;

{ TClientHandlerThread }
{ 5 }
constructor TClientHandlerThread.Create(AClientStream: TSocketStream);
begin
  inherited Create(false);
  FreeOnTerminate := true;
  FClientStream := AClientStream;
end;
{ 6 }
procedure TClientHandlerThread.Execute;
var
  Msg : String;
  Done: Boolean;
begin
  Done := false;
  repeat
    try
      Msg := FClientStream.ReadAnsiString;
      WriteLn(AddrToString(FClientStream.PeerAddress) + ': ' + Msg);
    except
      on e: EStreamError do begin
        Done := true;
      end;
    end;
  until Done;
  WriteLn(AddrToString(FClientStream.PeerAddress) + ' disconnected');
end;

{ TTestServer }
{ 7 }
procedure TTestServer.TestOnConnect(Sender: TConnectionBasedSocket; AStream: TSocketStream);
begin
  WriteLn('Incoming connection from ' + AddrToString(AStream.PeerAddress));
  TClientHandlerThread.Create(AStream);
end;
{ 8 }
constructor TTestServer.Create(AOwner: TComponent);
begin
  inherited;
  OnConnect := @TestOnConnect;
end;

{ main }
{ 9 }
var
  ServerEventLoop: TEventLoop;
begin
  ServerEventLoop := TEventLoop.Create;
  with TTestServer.Create(nil) do begin
    EventLoop := ServerEventLoop;
    Port := 12000;
    WriteLn('Serving...');
    Active := true;
    EventLoop.Run;
  end;
  ServerEventLoop.Free;
end.

