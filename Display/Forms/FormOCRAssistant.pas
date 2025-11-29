Unit FormOCRAssistant;

{-------------------------------------------------------------------------------
  Project   : GPS Assistant
  Unit      : FormOCRAssistant (FormOCRAssistant.pas)
  Description
    Main Form and full functionality

  Source
    Copyright (c) 2025
    Inspector Mike 2.0 Pty Ltd
    Mike Thompson (mike.cornflake@gmail.com)

  History
    2022-10-04: Creation.  Project originally called OCRAssistant
    2022-10-08: Finished fleshing out basic app
    2025-11-07: Migrated from SourceForge (private) to Github (public)
                Renamed project to GSPAssistant
    2025-11-29: Fixes following offshore use (primary driver was adding WhiteList)

  License
    This file is part of GPSAssistant.

    It is free software: you can redistribute it and/or modify it under the
    terms of the GNU General Public License as published by the Free Software
    Foundation, either version 3 of the License, or (at your option) any
    later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program.  If not, see <https://www.gnu.org/licenses/>.

    SPDX-License-Identifier: GPL-3.0-or-later
-------------------------------------------------------------------------------}

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, EditBtn,
  fgl, FormMain, IniFiles, Windows, Clipbrd, ExtCtrls, Menus, Spin, LazSerial;

Type
  { TRegion }

  TRegion = Class(TObject)
  Private
    FHeight: Integer;
    FLeft: Integer;
    FName: String;
    FTop: Integer;
    FWidth: Integer;
    Function GetAsText: String;
    Procedure SetAsText(AValue: String);
  Public
    Function Bounds: TRect;
    Procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
    Property Top: Integer Read FTop Write FTop;
    Property Left: Integer Read FLeft Write FLeft;
    Property Width: Integer Read FWidth Write FWidth;
    Property Height: Integer Read FHeight Write FHeight;

    Property Name: String Read FName Write FName;

    Property AsText: String Read GetAsText Write SetAsText;
  End;

  TRegionList = Specialize TFPGObjectList<TRegion>;

  { TRegionsHelper }

  TRegionsHelper = Class helper For TRegionList
    Function Find(AName: String): TRegion;

    Procedure ReadInifile(AInifile: TInifile; ASection: String);
    Procedure WriteInifile(AInifile: TInifile; ASection: String);
  End;

  { TfrmOCRAssistant }

  TfrmOCRAssistant = Class(TfrmMain)
    ApplicationProperties1: TApplicationProperties;
    btnAddRegion: TToolButton;
    btnDefineRegion: TToolButton;
    btnDeleteRegion: TToolButton;
    btngOCRDefaults: TButton;
    btnConfigureRS232_2: TButton;
    btnOCRAll: TToolButton;
    btnPasteToClipboard: TButton;
    btnTestRS232String: TButton;
    btnRenameRegion: TToolButton;
    btnTesseractDefaults: TButton;
    btnTimerStart: TButton;
    btnTimerStop: TButton;
    btnTestGPS: TButton;
    btnConfigureRS232_1: TButton;
    Button1: TButton;
    cboOCREngine: TComboBox;
    edtRS232String: TEdit;
    edtRS232Test: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    memFields2: TMemo;
    rgGPSStrings: TCheckGroup;
    edtClipboardString: TEdit;
    edtClipboardTest: TEdit;
    edtInterval: TSpinEdit;
    edtOCRFolder: TDirectoryEdit;
    edtTesseractFolder: TDirectoryEdit;
    edtLatitude: TFloatSpinEdit;
    edtLongitude: TFloatSpinEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LazSerial: TLazSerial;
    lvRegions: TListView;
    memFields: TMemo;
    memLog: TMemo;
    memGPS: TMemo;
    pcMain: TPageControl;
    pmnuAbout: TMenuItem;
    pmnuClipboard: TMenuItem;
    pmnuExit: TMenuItem;
    pmnuTimer: TMenuItem;
    pmnuTimerStart: TMenuItem;
    pmnuTimerStop: TMenuItem;
    pmTrayIcon: TPopupMenu;
    rgTimer: TRadioGroup;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    tsRS232String: TTabSheet;
    tsGPS: TTabSheet;
    tbRegions: TToolBar;
    tmrMain: TTimer;
    ToolButton1: TToolButton;
    trayMain: TTrayIcon;
    tsClipboard: TTabSheet;
    tsLog: TTabSheet;
    tsOCREngine: TTabSheet;
    tsRegions: TTabSheet;
    tsTimer: TTabSheet;
    Procedure ApplicationProperties1Minimize(Sender: TObject);
    Procedure btnAddRegionClick(Sender: TObject);
    Procedure btnDeleteRegionClick(Sender: TObject);
    Procedure btnConfigureRS232_1Click(Sender: TObject);
    Procedure btnOCRClick(Sender: TObject);
    Procedure btnPasteToClipboardClick(Sender: TObject);
    Procedure btnRenameRegionClick(Sender: TObject);
    Procedure btnSelectRegionClick(Sender: TObject);
    Procedure btnTesseractDefaultsClick(Sender: TObject);
    Procedure btnTestRS232StringClick(Sender: TObject);
    Procedure btnTimerStartClick(Sender: TObject);
    Procedure btnTimerStopClick(Sender: TObject);
    Procedure btnTestGPSClick(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure FormActivate(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure LazSerialRxData(Sender: TObject);
    Procedure lvRegionsDblClick(Sender: TObject);
    Procedure lvRegionsEdited(Sender: TObject; Item: TListItem; Var AValue: String);
    Procedure lvRegionsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    Procedure pcMainChange(Sender: TObject);
    Procedure pmnuAboutClick(Sender: TObject);
    Procedure pmnuClipboardClick(Sender: TObject);
    Procedure pmnuExitClick(Sender: TObject);
    Procedure tmrMainTimer(Sender: TObject);
    Procedure trayMainClick(Sender: TObject);
    Procedure trayMainDblClick(Sender: TObject);
  Private
    //FHotKeyCaptureID: Integer;
    //FHotKeyTimerID: Integer;
    FRegions: TRegionList;
    FTesseractOptions: String;
    FInTimer: Boolean;

    Procedure CloseSerial;
    Function OCRRegion(ARegion: TRegion): String;
    Procedure OpenSerial;
    Procedure OutputGPS;
    Procedure OutputRS232;
    Function ParseFormat(AValue: String): String;
    Function Process(AValue: String): String;
    Procedure GrabDesktop(ABitmap: Graphics.TBitmap; ALeft, ATop, AWidth, AHeight: Integer;
      ABorder: Integer = 0);
    Procedure HideMe;
    Procedure Log(AValue: String; AIndent: String = '');
    Procedure SetListViewValue(ARegion: Tregion; AValue: String; ASubStringIndex: Integer);
    Procedure ShowMe;
    Procedure WMHotKey(Var Msg: TMessage); Message WM_HOTKEY;
  Protected
    Procedure RefreshUI; Override;
    Procedure RefreshList;
  Public
    Procedure LoadGlobalSettings(oInifile: TIniFile); Override;
    Procedure SaveGlobalSettings(oInifile: TIniFile); Override;
  End;


Const
  BASE_HINT = 'OCR chosen regions of the main screen. Outputs as GPS or to Clipboard';

Var
  frmOCRAssistant: TfrmOCRAssistant;

Implementation

Uses
  FormRegionSelect, TesseractSupport, FileUtil, FileSupport, StringSupport,
  GPSSupport, LazSerialSupport;

Function TRegionsHelper.Find(AName: String): TRegion;
Var
  oRegion: TRegion;
Begin
  Result := nil;

  For oRegion In self Do
    If Uppercase(AName) = Uppercase(oRegion.Name) Then
    Begin
      Result := oRegion;
      Break;
    End;
End;

Procedure TRegionsHelper.ReadInifile(AInifile: TInifile; ASection: String);
Var
  iRegionCount, iTemp: Integer;
  sSection: String;
  oRegion: TRegion;
Begin
  Clear;
  iRegionCount := AInifile.ReadInteger(ASection, 'Count', 0);
  For iTemp := 0 To iRegionCount - 1 Do
  Begin
    sSection := Format('Region %d', [iTemp]);

    oRegion := TRegion.Create;
    oRegion.AsText := AInifile.ReadString(ASection, sSection, '');

    Add(oRegion);
  End;
End;

Procedure TRegionsHelper.WriteInifile(AInifile: TInifile; ASection: String);
Var
  iTemp: Integer;
  sSection: String;
Begin
  AInifile.WriteInteger(ASection, 'Count', Count);

  For iTemp := 0 To Count - 1 Do
  Begin
    sSection := Format('Region %d', [iTemp]);
    AInifile.WriteString(ASection, sSection, self[iTemp].AsText);
  End;
End;

{$R *.lfm}

{ TRegion }

Function TRegion.GetAsText: String;
Var
  oTemp: TStringList;
Begin
  oTemp := TStringList.Create;
  Try
    oTemp.NameValueSeparator := '=';
    oTemp.Delimiter := ',';

    oTemp.Add(Format('%s=%s', ['Name', Name]));
    oTemp.Add(Format('%s=%d', ['Left', Left]));
    oTemp.Add(Format('%s=%d', ['Top', Top]));
    oTemp.Add(Format('%s=%d', ['Width', Width]));
    oTemp.Add(Format('%s=%d', ['Height', Height]));

    Result := oTemp.DelimitedText;
  Finally
    oTemp.Free;
  End;
End;

Procedure TRegion.SetAsText(AValue: String);
Var
  oTemp: TStringList;
Begin
  oTemp := TStringList.Create;
  Try
    oTemp.NameValueSeparator := '=';
    oTemp.StrictDelimiter := True;
    oTemp.Delimiter := ',';

    oTemp.DelimitedText := AValue;

    Name := oTemp.Values['Name'];
    If Name = '' Then
      Name := 'Test';

    Left := StrToIntDef(oTemp.Values['Left'], 10);
    Top := StrToIntDef(oTemp.Values['Top'], 10);
    Width := StrToIntDef(oTemp.Values['Width'], 100);
    Height := StrToIntDef(oTemp.Values['Height'], 30);
  Finally
    oTemp.Free;
  End;
End;

Function TRegion.Bounds: TRect;
Begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Width := Width;
  Result.Height := Height;
End;

Procedure TRegion.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
Begin
  Left := ALeft;
  Top := ATop;
  Width := AWidth;
  Height := AHeight;
End;

{ TfrmOCRAssistant }

Procedure TfrmOCRAssistant.FormCreate(Sender: TObject);
Begin
  FInTimer := False;

  ilImages.GetIcon(9, trayMain.Icon);  // Red

  // The below code predated exporting the GPS string on RS232.
  // That automation removed the need for keyboard shortcuts
  // However, leaving the code commented in case I need it elsewhere...

  //FHotKeyCaptureID := GlobalAddAtom('GPSAssistant.Capture');
  //RegisterHotKey(Handle, FHotKeyCaptureID, MOD_CONTROL, VK_F1);

  //FHotKeyTimerID := GlobalAddAtom('GPSAssistant.Timer');
  //RegisterHotKey(Handle, FHotKeyTimerID, MOD_CONTROL, VK_F2);

  edtTesseractFolder.Text := TesseractPath;

  FAlwaysSaveSettings := True;
  FRegions := TRegionList.Create(True);

  pcMain.ActivePage := tsRegions;

  memLog.Lines.Clear;

  RefreshUI;
End;

Procedure TfrmOCRAssistant.FormDestroy(Sender: TObject);
Begin
  CloseSerial;

  //UnRegisterHotKey(Handle, FHotKeyCaptureID);
  //GlobalDeleteAtom(FHotKeyCaptureID);

  //UnRegisterHotKey(Handle, FHotKeyTimerID);
  //GlobalDeleteAtom(FHotKeyTimerID);

  FreeAndNil(FRegions);
End;

Procedure TfrmOCRAssistant.LazSerialRxData(Sender: TObject);
Begin

End;

Procedure TfrmOCRAssistant.lvRegionsDblClick(Sender: TObject);
Begin
  If lvRegions.ItemIndex >= 0 Then
    btnDefineRegion.Click;
End;

Procedure TfrmOCRAssistant.lvRegionsEdited(Sender: TObject; Item: TListItem; Var AValue: String);
Var
  oRegion: TRegion;
  sOriginal: String;
Begin
  If Assigned(lvRegions.Selected) And (lvRegions.Selected.Index < FRegions.Count) Then
  Begin
    oRegion := FRegions[lvRegions.Selected.Index];
    sOriginal := oRegion.Name;
    oRegion.Name := AValue;
    Log(Format('Renamed %s to %s', [sOriginal, AValue]));
  End;
End;

Procedure TfrmOCRAssistant.lvRegionsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
Begin
  RefreshUI;
End;

Procedure TfrmOCRAssistant.pmnuClipboardClick(Sender: TObject);
Begin
  btnPasteToClipboard.Click;
  If tmrMain.Enabled Then
    trayMain.Hint := BASE_HINT + CRLF + 'Timer Started:  ' + Clipboard.AsText
  Else
    trayMain.Hint := BASE_HINT + CRLF + Clipboard.AsText;
  Log(Clipboard.AsText);
End;

Procedure TfrmOCRAssistant.pmnuAboutClick(Sender: TObject);
Begin
  mnuAbout.Click;
End;

Procedure TfrmOCRAssistant.pcMainChange(Sender: TObject);
Var
  oRegion: TRegion;
Begin
  If pcMain.ActivePage = tsClipboard Then
  Begin
    memFields.Lines.Clear;

    For oRegion In FRegions Do
      memFields.Lines.Add('%%%s%%     '#9'%%%s_raw%%'#9'%%%s_processed%%',
        [oRegion.Name, oRegion.Name, oRegion.Name]);
  End
  Else If pcMain.ActivePage = tsRS232String Then
  Begin
    memFields2.Lines.Clear;

    For oRegion In FRegions Do
      memFields2.Lines.Add('%%%s%%     '#9'%%%s_raw%%'#9'%%%s_processed%%',
        [oRegion.Name, oRegion.Name, oRegion.Name]);
  End;
End;

Procedure TfrmOCRAssistant.pmnuExitClick(Sender: TObject);
Begin
  Close;
End;

Procedure TfrmOCRAssistant.tmrMainTimer(Sender: TObject);
Begin
  If FInTimer Then
    Exit;

  FInTimer := True;
  Try
    If fRegions.Count > 0 Then
      Case (rgTimer.ItemIndex) Of
        0: btnPasteToClipboard.Click;
        1: OutputGPS;
        2: OutputRS232;
      End
    Else
    Begin
      btnTimerStop.Click;

      RefreshUI;

      Log('Stopping timer.  No regions enabled');
    End;
  Finally
    FInTimer := False;
  End;
End;

Procedure TfrmOCRAssistant.OpenSerial;
Begin
  If Not LazSerial.Active Then
  Begin
    LazSerial.Open;
    If Not LazSerial.Active Then
    Begin
      ShowMessage('Error opening com port');
      Log('Error opening com port');
      btnTimerStop.Click;
    End
    Else
      Log('Opened ' + LazSerial.Device);
  End;
End;

Procedure TfrmOCRAssistant.CloseSerial;
Begin
  If LazSerial.Active Then
  Begin
    LazSerial.Close;
    Log('Closed ' + LazSerial.Device);
  End;
End;

Procedure TfrmOCRAssistant.OutputGPS;

  Procedure GetEN(Var dEast, dNorth: Double);
  Begin
    dEast := StrToFloatDef(ParseFormat('%Eastings_processed%'), 0);
    dNorth := StrToFloatDef(ParseFormat('%Northings_processed%'), 0);
  End;

Var
  sOutput: String;
  dEast: Double = 0;
  dNorth: Double = 0;
Begin
  OpenSerial;

  sOutput := '';

  GetEN(dEast, dNorth);

  If (dEast <> 0) And (dNorth <> 0) Then
  Begin
    If rgGPSStrings.Checked[0] Then
    Begin
      sOutput := NMEA_GPGGAbyEN(dEast, dNorth, 0);
      LazSerial.WriteLn(sOutput);

      Log('Output: ' + sOutput);
    End;

    If rgGPSStrings.Checked[1] Then
    Begin
      sOutput := NMEA_GPGLLbyEN(dEast, dNorth);
      LazSerial.WriteLn(sOutput);

      Log('Output: ' + sOutput);
    End;

    If rgGPSStrings.Checked[2] Then
    Begin
      sOutput := NMEA_GPRMCbyEN(dEast, dNorth);
      LazSerial.WriteLn(sOutput);

      Log('Output: ' + sOutput);
    End;
  End;
End;

Procedure TfrmOCRAssistant.OutputRS232;
Var
  sOutput: String;
Begin
  sOutput := ParseFormat(edtRS232String.Text);

  OpenSerial;
  LazSerial.WriteLn(sOutput);

  Log('Output RS232: ' + sOutput);
End;

Procedure TfrmOCRAssistant.trayMainClick(Sender: TObject);
Begin
  trayMain.PopupMenu.PopUp;
End;

Procedure TfrmOCRAssistant.trayMainDblClick(Sender: TObject);
Begin
  ShowMe;
End;

Procedure TfrmOCRAssistant.btnSelectRegionClick(Sender: TObject);
Var
  oForm: TfrmSelectRegion;
  oRegion: TRegion;
Begin
  If lvRegions.ItemIndex >= 0 Then
  Begin
    oForm := TfrmSelectRegion.Create(self);
    Try
      oRegion := FRegions[lvRegions.ItemIndex];
      Log(Format('Defining %s', [oRegion.Name]));

      oForm.SetBounds(oRegion.Left, oRegion.Top, oRegion.Width, oRegion.Height);
      oForm.ShowModal;

      oRegion.SetBounds(oForm.Left, oForm.Top, oForm.Width, oForm.Height);
      RefreshList;
      Log(Format('Updated %s', [oRegion.Name]));
    Finally
      oForm.Free;
    End;
  End;
End;

Procedure TfrmOCRAssistant.btnAddRegionClick(Sender: TObject);
Var
  oRegion: TRegion;
Begin
  oRegion := TRegion.Create;
  oRegion.Name := 'Test';
  oRegion.SetBounds(10, 10, 100, 30);
  FRegions.Add(oRegion);
  RefreshList;
  Log(Format('Added new Region %d', [FRegions.Count]));
End;

Procedure TfrmOCRAssistant.ApplicationProperties1Minimize(Sender: TObject);
Begin
  HideMe;
End;

Procedure TfrmOCRAssistant.btnDeleteRegionClick(Sender: TObject);
Var
  sRegion: String;
Begin
  If (lvRegions.ItemIndex >= 0) And (lvRegions.ItemIndex < FRegions.Count) Then
  Begin
    sRegion := FRegions[lvRegions.ItemIndex].Name;

    If MessageDlg('Confirm Delete', 'Are you sure you wish to delete ' +
      sRegion + '?', mtConfirmation, mbYesNo, 0) = mrYes Then
    Begin
      FRegions.Delete(lvRegions.ItemIndex);

      RefreshList;
      Log(Format('Added new Region %d', [FRegions.Count]));
    End;
  End;
End;

Procedure TfrmOCRAssistant.btnConfigureRS232_1Click(Sender: TObject);
Begin
  LazSerial.ShowSetupDialog;
End;

Procedure TfrmOCRAssistant.btnRenameRegionClick(Sender: TObject);
Var
  sNew: String;
Begin
  If (FRegions.Count > 0) And (lvRegions.ItemIndex < FRegions.Count) Then
  Begin
    sNew := InputBox('Name', 'Please enter the new name of the selected region:',
      lvRegions.Selected.Caption);
    If sNew <> '' Then
    Begin
      lvRegions.Selected.Caption := sNew;
      FRegions[lvRegions.ItemIndex].Name := sNew;
    End;
  End;
End;

Procedure TfrmOCRAssistant.RefreshUI;
Begin
  Inherited;

  tsRegions.Enabled := TesseractAvailable;

  btnDefineRegion.Enabled := lvRegions.ItemIndex >= 0;
  btnRenameRegion.Enabled := lvRegions.ItemIndex >= 0;
  btnDeleteRegion.Enabled := lvRegions.ItemIndex >= 0;

  btnOCRAll.Enabled := FRegions.Count > 0;

  btnTimerStart.Enabled := Not tmrMain.Enabled;
  btnTimerStop.Enabled := tmrMain.Enabled;
  pmnuTimerStart.Enabled := Not tmrMain.Enabled;
  pmnuTimerStop.Enabled := tmrMain.Enabled;
End;

Procedure TfrmOCRAssistant.RefreshList;
Var
  oRegion: TRegion;
  oItem: TListItem;
  iPrev: Integer;
Begin
  If Assigned(lvRegions.Selected) Then
    iPrev := lvRegions.Selected.Index
  Else
    iPrev := -1;

  lvRegions.BeginUpdate;
  Try
    lvRegions.Items.Clear;

    For oRegion In FRegions Do
    Begin
      oItem := lvRegions.Items.Add;
      oItem.Caption := oRegion.Name;
      oItem.SubItems.Add('%d', [oRegion.Left]);
      oItem.SubItems.Add('%d', [oRegion.Top]);
      oItem.SubItems.Add('%d', [oRegion.Width]);
      oItem.SubItems.Add('%d', [oRegion.Height]);
    End;

    If (iPrev >= 0) And (iPrev < lvRegions.Items.Count) Then
      lvRegions.Selected := lvRegions.Items[iPrev]
    Else If lvRegions.Items.Count > 0 Then
      lvRegions.Selected := lvRegions.Items[0];
  Finally
    lvRegions.EndUpdate;
  End;

  RefreshUI;
End;

Procedure TfrmOCRAssistant.btnOCRClick(Sender: TObject);
Var
  oRegion: TRegion;
Begin
  Log('Processing all regions');
  For oRegion In FRegions Do
    OCRRegion(oRegion);
  Log('Finished');
End;

Procedure TfrmOCRAssistant.btnTesseractDefaultsClick(Sender: TObject);
Var
  sTemp: TCaption;
Begin
  sTemp := edtTesseractFolder.Text;
  SetTesseractPath('');
  InitializeTesseract;
  If Not TesseractAvailable Then
  Begin
    SetTesseractPath(sTemp);

    ShowMessage('tesseract.exe not found in %PATH%, adjacent to or within <EXEDIR>');
  End
  Else
    edtTesseractFolder.Text := TesseractPath;
End;

Procedure TfrmOCRAssistant.btnTestRS232StringClick(Sender: TObject);
Var
  sOutput: String;
Begin
  sOutput := ParseFormat(edtRS232String.Text);

  edtRS232Test.Text := sOutput;

  Log('Test RS232: ' + sOutput);
End;

Procedure TfrmOCRAssistant.btnPasteToClipboardClick(Sender: TObject);
Var
  sClipboard: String;
Begin
  sClipboard := ParseFormat(edtClipboardString.Text);

  If sClipboard <> Clipboard.AsText Then
  Begin
    edtClipboardTest.Text := sClipboard;

    Clipboard.Clear;
    Clipboard.AsText := sClipboard;

    Log('Clipboard: ' + Clipboard.AsText);
  End;
End;

Procedure TfrmOCRAssistant.btnTimerStartClick(Sender: TObject);
Begin
  Log('Timer starting');
  tmrMain.Interval := edtInterval.Value * 1000;
  tmrMain.Enabled := True;

  ilImages.GetIcon(8, trayMain.Icon);
  trayMain.Hint := BASE_HINT + CRLF + 'Timer Started';

  // Set the correct UTM Zone for this project
  InitialiseGPS(edtLatitude.Value, edtLongitude.Value);

  RefreshUI;
End;

Procedure TfrmOCRAssistant.btnTimerStopClick(Sender: TObject);
Begin
  tmrMain.Enabled := False;

  ilImages.GetIcon(9, trayMain.Icon);
  trayMain.Hint := BASE_HINT;

  RefreshUI;

  CloseSerial;

  Log('Timer stopped');
End;

Procedure TfrmOCRAssistant.btnTestGPSClick(Sender: TObject);
Var
  dEast, dNorth: Double;
  dLat, dLon: Double;
Begin
  memGPS.Lines.Clear;

  memGPS.Lines.Add('Original Lat:%.6f, Long:%.6f', [edtLatitude.Value, edtLongitude.Value]);

  InitialiseGPS(edtLatitude.Value, edtLongitude.Value);

  memGPS.Lines.Add('UTM Zone: %d %s', [Fuseau, Hemisphere]);
  memGPS.Lines.Add('');

  LatLonToEN(edtLatitude.Value, edtLongitude.Value, dEast{%H-}, dNorth{%H-});

  memGPS.Lines.Add('E:%.2f, N:%.2f', [dEast, dNorth]);
  memGPS.Lines.Add('UTM Zone: %d %s', [Fuseau, Hemisphere]);
  memGPS.Lines.Add('');

  ENToLatLon(dEast, dNorth, dLat{%H-}, dLon{%H-});

  memGPS.Lines.Add('Converted Lat:%.6f, Long:%.6f', [dLat, dLon]);
  memGPS.Lines.Add('');

  memGPS.Lines.Add('GPS Strings');
  memGPS.Lines.Add('-----------');

  memGPS.Lines.Add(NMEA_GPGGA(dLat, dLon, 0));
  memGPS.Lines.Add(NMEA_GPGGAbyEN(dEast, dNorth, 0));
  memGPS.Lines.Add(NMEA_GPGLL(dLat, dLon));
  memGPS.Lines.Add(NMEA_GPGLLbyEN(dEast, dNorth));
  memGPS.Lines.Add(NMEA_GPRMC(dLat, dLon));
  memGPS.Lines.Add(NMEA_GPRMCbyEN(dEast, dNorth));

  memGPS.SelStart := 0;
  memGPS.SelLength := 0;
  //memGPS.Perform(EM_SCROLLCARET, 0, 0);
End;

Procedure TfrmOCRAssistant.Button1Click(Sender: TObject);
Begin
  ShowMessage(LazSerial.SettingsAsCommaSep);
  ShowMessage(LazSerial.SettingsAsXML);
  ShowMessage(LazSerial.ToString);
End;

Procedure TfrmOCRAssistant.FormActivate(Sender: TObject);
Begin
  Inherited;
  ShowInTaskBar := stAlways;
End;

Function TfrmOCRAssistant.ParseFormat(AValue: String): String;
Var
  iTemp: Integer;
  sFullField, sField, sValue: String;
  bIsRaw: Boolean;
  oRegion: TRegion;
Begin
  Result := AValue;

  iTemp := Count('%', AValue);
  If ((iTemp Mod 2) = 0) Then
    While Pos('%', Result) > 0 Do
    Begin
      sFullField := TextBetween(Result, '%', '%');
      bIsRaw := False;

      If Pos('_', sFullField) > 0 Then
      Begin
        sField := TextBetween(sFullField, '', '_');
        bIsRaw := Uppercase(TextBetween(sFullField, '_', '')) = 'RAW';
      End
      Else
        sField := sFullField;

      sValue := '';

      oRegion := FRegions.Find(sField);
      If Assigned(oRegion) Then
      Begin
        sValue := OCRRegion(oRegion);

        If Not bIsRaw Then
          sValue := Process(sValue);
      End
      Else
        Result := 'Invalid field (' + sFullField + ')';

      Result := FindReplace(Result, '%' + sFullField + '%', sValue);
    End
  Else
    Result := 'Invalid string format (too many %)';
End;

Function TfrmOCRAssistant.OCRRegion(ARegion: TRegion): String;
Var
  oBitmap: Graphics.TBitmap;
  sTempDir: String;
  sTempFile: String;
Begin
  sTempDir := IncludeTrailingBackslash(SysUtils.GetTempDir(False)) +
    ChangeFileExt(ExtractFileName(Application.ExeName), '');

  ForceDirectories(sTempDir);

  oBitmap := Graphics.TBitmap.Create;
  Busy := True;
  Try
    GrabDesktop(oBitmap, ARegion.Left, ARegion.Top, ARegion.Width, ARegion.Height, 5);

    sTempFile := UniqueFilename(sTempDir, 'OCR', '.bmp', False);
    oBitmap.SaveToFile(sTempFile);

    Result := Trim(OCR(sTempFile, FTesseractOptions));

    // Cleanup after ourselves
    SysUtils.DeleteFile(sTempFile);

    SetListViewValue(ARegion, Result, 4);
    SetListViewValue(ARegion, Process(Result), 5);
  Finally
    oBitmap.FreeImage;
    oBitmap.Free;
    Busy := False;
  End;
End;

Procedure TfrmOCRAssistant.SetListViewValue(ARegion: Tregion; AValue: String;
  ASubStringIndex: Integer);
Var
  iRegion, i: Integer;
  oItem: TListItem;
Begin
  iRegion := FRegions.IndexOf(ARegion);
  If (iRegion >= 0) And (iRegion < lvRegions.Items.Count) Then
  Begin
    oItem := lvRegions.Items[iRegion];

    For i := oItem.SubItems.Count To ASubStringIndex Do
      oItem.SubItems.Add('');

    oItem.SubItems[ASubStringIndex] := AValue;
  End;
End;

Function TfrmOCRAssistant.Process(AValue: String): String;
Begin
  // TODO: Make this a user defined lookup
  // TODO: This code is now probably deprecated by inlcude Whitelist...
  Result := StringReplace(AValue, 'O', '0', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, 'l', '1', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, 'I', '1', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '€', '8', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '°', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll, rfIgnoreCase]);
End;

Procedure TfrmOCRAssistant.GrabDesktop(ABitmap: Graphics.TBitmap;
  ALeft, ATop, AWidth, AHeight: Integer; ABorder: Integer);
Var
  DC: HDC;
  hWin: HWND;
  bmpTemp: Graphics.TBitmap;
  clBorder: TColor;
Begin
  If ABorder < 0 Then
    ABorder := 0;

  hWin := GetDesktopWindow;
  DC := GetDC(hWin);
  bmpTemp := Graphics.TBitmap.Create;
  Try
    // First: grab just the requested region into a temp bitmap
    bmpTemp.PixelFormat := pf24bit;
    bmpTemp.Width := AWidth;
    bmpTemp.Height := AHeight;

    BitBlt(bmpTemp.Canvas.Handle, 0, 0, AWidth, AHeight,
      DC, ALeft, ATop, SRCCOPY);

    // Get border colour from bottom-left pixel of the *original* capture
    If (AWidth > 0) And (AHeight > 0) Then
      clBorder := bmpTemp.Canvas.Pixels[0, AHeight - 1]
    Else
      clBorder := clWhite; // fallback

    // Now prepare the destination bitmap: original size + border on all sides
    ABitmap.PixelFormat := pf24bit;
    ABitmap.Width := AWidth + (ABorder * 2);
    ABitmap.Height := AHeight + (ABorder * 2);

    // Fill entire bitmap with the border colour
    ABitmap.Canvas.Brush.Color := clBorder;
    ABitmap.Canvas.FillRect(0, 0, ABitmap.Width, ABitmap.Height);

    // Draw original capture into the centre (offset by ABorder)
    ABitmap.Canvas.Draw(ABorder, ABorder, bmpTemp);
  Finally
    bmpTemp.Free;
    ReleaseDC(hWin, DC);
  End;
End;

Procedure TfrmOCRAssistant.Log(AValue: String; AIndent: String);
Begin
  If AValue = 'Finished' Then
    sbMain.SimpleText := ''
  Else
    sbMain.SimpleText := AValue;

  memLog.Lines.Add('%s: %S%s', [FormatDateTime('HH:mm:ss.zzz', Now), AIndent, AValue]);

  If memLog.Lines.Count > 50 Then
    memLog.Lines.Delete(0);

  memLog.SelStart := Length(memLog.Lines.Text) - 1;
  memLog.SelLength := 0;
End;

// https://forum.lazarus.freepascal.org/index.php?topic=22706.0
Procedure TfrmOCRAssistant.HideMe;
Begin
  //Because a minimized window can't be hidden
  //or removed from the taskbar
  WindowState := wsNormal;

  Hide;
  ShowInTaskBar := stNever;
  trayMain.Show;
End;

Procedure TfrmOCRAssistant.ShowMe;
Begin
  Show; //We don't need to set ws to normal, because HideMe() already did
  ShowInTaskBar := stAlways;
End;

Procedure TfrmOCRAssistant.WMHotKey(Var Msg: TMessage);
Begin
  //  If Msg.wParam = FHotKeyCaptureID Then
  //    pmnuClipboard.Click
  //  Else If Msg.wParam = FHotKeyTimerID Then
  //    If tmrMain.Enabled Then
  //      btnTimerStop.Click
  //    Else
  //      btnTimerStart.Click;
End;

Procedure TfrmOCRAssistant.LoadGlobalSettings(oInifile: TIniFile);
Begin
  Inherited LoadGlobalSettings(oInifile);

  InitializeTesseract;

  If Not TesseractAvailable Then
  Begin
    ShowMessage('No OCR Engine Found');
    // TODO Renable tsRegions after user loads a valid folder...
    tsRegions.Enabled := False;
  End
  Else
    edtTesseractFolder.Text := TesseractPath;

  // For now, allow reading numerics only
  // TODO This obviously needs to be made field specific (ie read Date, Time etc);
  // 3 = Default Engine
  // 8 = OCR is interpreting a single word
  // The whitelist means we're enforcing numeric only
  FTesseractOptions := TesseractSupport.BuildOptionsString(3, 8, '0123456789.');

  edtInterval.Value := oIniFile.ReadInteger('Timer', 'Interval', 1);
  rgTimer.ItemIndex := oIniFile.ReadInteger('Timer', 'Output', 1);

  edtClipboardString.Text := oInifile.ReadString('Clipboard', 'String',
    '%Northings_processed%, %Eastings_processed%');

  edtLatitude.Value := oInifile.ReadFloat('GPS', 'Latitude', -19.809287);
  edtLongitude.Value := oInifile.ReadFloat('GPS', 'Longitude', 114.608388);

  rgGPSStrings.Checked[0] := oInifile.ReadBool('GPS', 'Include GPGGA', True);
  rgGPSStrings.Checked[1] := oInifile.ReadBool('GPS', 'Include GPGLL', True);
  rgGPSStrings.Checked[2] := oInifile.ReadBool('GPS', 'Include GPRMC', False);

  edtRS232String.Text := oInifile.ReadString('RS232', 'String',
    'N:%Northings_processed%, E:%Eastings_processed%');

  LazSerial.ReadInifile(oInifile, 'RS232');
  FRegions.ReadInifile(oInifile, 'Regions');

  RefreshList;
End;

Procedure TfrmOCRAssistant.SaveGlobalSettings(oInifile: TIniFile);
Begin
  Inherited SaveGlobalSettings(oInifile);

  oInifile.WriteString('Tesseract', 'Folder', ShrinkFolder(TesseractPath));

  oIniFile.WriteInteger('Timer', 'Interval', edtInterval.Value);
  oIniFile.WriteInteger('Timer', 'Output', rgTimer.ItemIndex);

  oInifile.WriteString('Clipboard', 'String', edtClipboardString.Text);

  oInifile.WriteFloat('GPS', 'Latitude', edtLatitude.Value);
  oInifile.WriteFloat('GPS', 'Longitude', edtLongitude.Value);

  oInifile.WriteBool('GPS', 'Include GPGGA', rgGPSStrings.Checked[0]);
  oInifile.WriteBool('GPS', 'Include GPGLL', rgGPSStrings.Checked[1]);
  oInifile.WriteBool('GPS', 'Include GPRMC', rgGPSStrings.Checked[2]);

  oInifile.WriteString('RS232', 'String', edtRS232String.Text);

  LazSerial.WriteInifile(oInifile, 'RS232');
  FRegions.WriteInifile(oInifile, 'Regions');
End;

End.
