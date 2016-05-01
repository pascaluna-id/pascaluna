unit unitmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, lNetComponents, Forms, Controls, Graphics,
  Dialogs, StdCtrls, lNet;

type

  { TFormMain }

  TFormMain = class(TForm)
    LTCPComponentServerSocket: TLTCPComponent;
    MemoLogs: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure LTCPComponentServerSocketAccept(aSocket: TLSocket);
    procedure LTCPComponentServerSocketDisconnect(aSocket: TLSocket);
    procedure LTCPComponentServerSocketReceive(aSocket: TLSocket);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.LTCPComponentServerSocketAccept(aSocket: TLSocket);
begin
  MemoLogs.Lines.Add('Client connected.');
end;

procedure TFormMain.LTCPComponentServerSocketDisconnect(aSocket: TLSocket);
begin
  MemoLogs.Lines.Add('Client disconnected.');
end;

procedure TFormMain.LTCPComponentServerSocketReceive(aSocket: TLSocket);
var
	 buf : array[1..5] of Char;
   recvSize : Integer;
begin
     repeat
         recvSize := aSocket.Get (buf, SizeOf(buf));
         if recvSize > 0 then
         begin
              MemoLogs.Lines.Add(Format ('Client recv: %d bytes.', [recvSize]));
         end;
   until recvSize = 0;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  MemoLogs.Lines.Add ('Listening on port 7000.');
  LTCPComponentServerSocket.Listen (7000);
end;

end.

