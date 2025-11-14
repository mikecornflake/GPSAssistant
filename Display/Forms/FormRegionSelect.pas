Unit FormRegionSelect;

// Code for the form movement borrowed from
// https://enrique.latorres.org/2017/10/14/how-to-drag-a-captionless-form-in-free-pascal-lazarus-typhon/

{$mode ObjFPC}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

Type

  { TfrmSelectRegion }

  TfrmSelectRegion = Class(TForm)
    Procedure FormCreate(Sender: TObject);
    Procedure FormDblClick(Sender: TObject);
    Procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    Procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    Procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
  Private
    FMoving: Boolean;
    FOld: TRect;
  Public
  End;

Const
  EDGEDETECT = 7; // adjust

Implementation

{$R *.lfm}

{ TfrmSelectRegion }

Procedure TfrmSelectRegion.FormCreate(Sender: TObject);
Begin
  FMoving := False;
End;

Procedure TfrmSelectRegion.FormDblClick(Sender: TObject);
Begin
  Screen.Cursor := crDefault;
  Close;
End;

Procedure TfrmSelectRegion.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  If (Sender Is TForm) Then
  Begin
    //we are now repositioning the form
    FMoving := True;

    //Remember the original mouse position, and the original form width/height
    FOld.Left := X;
    FOld.Top := Y;
    FOld.Width := Width;
    FOld.Height := Height;

    //Change cursor to appropriate resizer
    If (X > BoundsRect.Width - EDGEDETECT) Then
      Screen.Cursor := crSizeWE
    Else If (Y > BoundsRect.Height - EDGEDETECT) Then
      Screen.Cursor := crSizeNS
    Else
      Screen.Cursor := crSize;
  End;
End;

Procedure TfrmSelectRegion.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Var
  pNew: TPoint;
  iLeft, itop, iWidth, iHeight: Integer;
Begin
  //Adjust new form position relative to first position
  If FMoving Then
  Begin
    // Get actual position from mouse for this event
    pNew.X := X;
    pNew.Y := Y;

    // Define defaults
    iLeft := Left;
    iTop := Top;
    iWidth := Width;
    iHeight := Height;

    // Change the appropriate dimension
    If Screen.Cursor = crSize Then
    Begin
      iLeft := Left + (pNew.X - FOld.Left);
      iTop := Top + (pNew.Y - FOld.Top);
    End
    Else If Screen.Cursor = crSizeNS Then
      iHeight := FOld.Height + (pNew.Y - FOld.Top)
    Else If Screen.Cursor = crSizeWE Then
      iWidth := FOld.Width + (pNew.X - FOld.Left);

    // Apply the changes
    TForm(Sender).SetBounds(iLeft, iTop, iWidth, iHeight);
  End
  Else
    //Change cursor to appropriate resizer
    If (X > BoundsRect.Width - EDGEDETECT) Then
      Cursor := crSizeWE
    Else If (Y > BoundsRect.Height - EDGEDETECT) Then
      Cursor := crSizeNS
    Else
      Cursor := crDefault;

End;

Procedure TfrmSelectRegion.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  FMoving := False;
  Screen.Cursor := crDefault;
End;

End.
