program GPSAssistant;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LazSerialPort, FormOCRAssistant;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='GPS Assistant';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmOCRAssistant, frmOCRAssistant);
  Application.Run;
end.

