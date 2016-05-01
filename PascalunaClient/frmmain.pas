unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, lNetComponents, Forms, Controls, Graphics,
  Dialogs, StdCtrls;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonConnect: TButton;
    ButtonDisconnect: TButton;
    ButtonSend: TButton;
    LTCPComponentClientSocket: TLTCPComponent;
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
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

procedure TFormMain.ButtonConnectClick(Sender: TObject);
begin
  LTCPComponentClientSocket.Connect('localhost', 7000);
end;

procedure TFormMain.ButtonDisconnectClick(Sender: TObject);
begin
  LTCPComponentClientSocket.Disconnect;
end;

procedure TFormMain.ButtonSendClick(Sender: TObject);
begin
  LTCPComponentClientSocket.SendMessage('Hello world!');
end;

end.

