unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,module,
  Vcl.Mask, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart,Math;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    aPole: TLabeledEdit;
    ePole: TLabeledEdit;
    iPole: TLabeledEdit;
    OmPole: TLabeledEdit;
    M0Pole: TLabeledEdit;
    wPole: TLabeledEdit;
    startBtn: TButton;
    Label4: TLabel;
    dateEdt: TMaskEdit;
    timeEdt: TMaskEdit;
    Label5: TLabel;
    Label6: TLabel;
    tObrPole: TLabeledEdit;
    Chart1: TChart;
    Series1: TFastLineSeries;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    NumOfTurnPole: TEdit;
    Label7: TLabel;
    procedure startBtnClick(Sender: TObject);
    procedure aPoleKeyPress(Sender: TObject; var Key: Char);
    procedure M0PoleKeyPress(Sender: TObject; var Key: Char);
    procedure aPoleExit(Sender: TObject);
    procedure M0PoleExit(Sender: TObject);
    //procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //geogrCoords: array[1..101,1..2] of extended;

implementation

{$R *.dfm}


procedure TForm1.aPoleExit(Sender: TObject);
begin
  if aPole.Text = '' then CheckBox1.Checked := False;
end;

procedure TForm1.aPoleKeyPress(Sender: TObject; var Key: Char);
begin
  CheckBox1.Checked := True;
end;

procedure TForm1.M0PoleExit(Sender: TObject);
begin
  if M0Pole.Text = '' then CheckBox2.Checked := False;
end;

procedure TForm1.M0PoleKeyPress(Sender: TObject; var Key: Char);
begin
  CheckBox2.Checked := True;
end;

procedure TForm1.startBtnClick(Sender: TObject);
var elems: ElementsOfOrbit;
    day,month,year,hour,minute,second,Ms: word;//��� ��� ��� ������ ���� ��������������
    M0,MEnd,JD,H,Tobr,
    EccAnomaly,lamd,fi,NumOfTurn  : extended;
    coords: DecartCoords;
    i: integer;
    MyDate, MyTime : TDateTime;
begin
{=======================================
           ���� ����� ������
========================================}
    if CheckBox1.Checked then begin//���� ������� ��� �� ��������� �������� �� ���� ��� �����
      if aPole.Text = ''  then begin
        ShowMessage('�� �� ����� �������.');
        exit;
      end;
    end;

     if ePole.Text = ''  then begin
      ShowMessage('�� �� ����� ��������������.');
      exit;
    end;

     if iPole.Text = ''  then begin
      ShowMessage('�� �� ����� ����������.');
      exit;
    end;

     if OmPole.Text = ''  then begin
      ShowMessage('�� �� ����� ������� ����������� ����.');
      exit;
    end;

     if wPole.Text = ''  then begin
      ShowMessage('�� �� ����� �������� �������.');
      exit;
    end;

    if CheckBox2.Checked then begin
      if M0Pole.Text = ''  then begin
        ShowMessage('�� �� ����� ��������� ������� ��������.');
        exit;
      end;
    end;

    if tObrPole.Text = ''  then begin
      ShowMessage('�� �� ����� ������ ���������.');
      exit;
    end;

    try
      elems[2] := StrToFloat(ePole.Text);
    except
      ShowMessage('������������� ������ ���� ������������� ����.');
      ePole.Text := '';
      exit;
    end;

    try
      elems[3] := StrToFloat(iPole.Text);
      elems[3] := toRadians(elems[3]);
    except
      ShowMessage('���������� ������ ���� ������������� ����.');
      iPole.Text := '';
      exit;
    end;

    try
      elems[4] := StrToFloat(OmPole.Text);
      elems[4] := toRadians(elems[4]);
    except
      ShowMessage('������� ����������� ���� ������ ���� ������������� ����.');
      OmPole.Text := '';
      exit;
    end;

    try
      elems[5] := StrToFloat(wPole.Text);
      elems[5] := toRadians(elems[5]);
    except
      ShowMessage('�������� ������� ������ ���� ������������� ����.');
      wPole.Text := '';
      exit;
    end;

    if CheckBox2.Checked then begin
      try
        elems[6] := StrToFloat(M0Pole.Text);
        elems[6] := toRadians(elems[6]);
      except
        ShowMessage('��������� ������� �������� ������ ���� ������������� ����.');
        M0Pole.Text := '';
        exit;
      end;
    end else begin
      EccAnomaly := 2*arctan2(tan(-elems[5]*rad/2),
                              sqrt((1 + elems[2])/(1 - elems[2])));

      elems[6] := EccAnomaly - elems[2]*sin(EccAnomaly);
    end;

    //����� ��������� �����, �� � �����
    try
      if StrToFloat(tObrPole.Text) > 0 then begin
        Tobr := StrToFloat(tObrPole.Text);
      end else begin
        ShowMessage('������ ��������� ������ ���� ������������� ���� � ������ ����.');
        TobrPole.Text := '';
        exit;
      end;
    except
      ShowMessage('������ ��������� ������ ���� ������������� ���� � ������ ����.');//������ ������� ���� ������ ����
      TobrPole.Text := '';
      exit;
    end;//ps ������������ ��� word �� �� ����� ��� ��� ��� �������� �� str � word

    if CheckBox1.Checked then begin
      try
        elems[1] := StrToFloat(aPole.Text);
      except
        ShowMessage('������� ������ ���� ������������� ����.');
        aPole.Text := '';
        exit;
      end;
    end else elems[1] := power(sqr(Tobr)*mu/sqr(2*pi),1/3);

    {try
      day := StrToFloat(dateEdt.Text[1] + dateEdt.Text[2]);
      month := StrToFloat(dateEdt.Text[4] + dateEdt.Text[5]);
      year := StrToFloat(dateEdt.Text[7] + dateEdt.Text[8] + dateEdt.Text[9] +
      dateEdt.Text[10]);
    except
      showMessage('������������ ����');
    end;}

    //���������� ��� ���� � ������ ��� TDateTime
    try
      MyDate := StrToDate(dateEdt.Text);
      DecodeDate(MyDate,year,month,day);
    except
      showMessage('������������ ����');
    end;

    {try
      hour := StrToFloat(timeEdt.Text[1] + timeEdt.Text[2]);
      minute := StrToFloat(timeEdt.Text[4] + timeEdt.Text[5]);
      second := StrToFloat(timeEdt.Text[7] + timeEdt.Text[8]);
    except
      showMessage('������������ �����');
    end;}

    try
      MyTime := StrToTime(timeEdt.Text);
      DecodeTime(MyTime,hour,minute,second,Ms);
    except
      showMessage('������������ �����');
    end;

    try
      if StrToInt(NumOfTurnPole.Text) > 0 then begin
        NumOfTurn := StrToInt(NumOfTurnPole.Text);
      end else begin
        ShowMessage('����� �������� ������ ���� ����� ������ � ������ ����');
        NumOfTurnPole.Text := '';
        exit;
      end;
    except
      ShowMessage('����� �������� ������ ���� ����� ������ � ������ ����');
      NumOfTurnPole.Text := '';
      exit;
    end;

    M0 := elems[6];
    MEnd := M0 + 2*PI*NumOfTurn;

{=======================================
      ����� ����� ����� ������
========================================}
    Series1.Clear;
    i := 1;
    while elems[6] <= MEnd do begin
      JD := JDate(year,month,day,hour,minute,second);
      H := sid2000(JD);

      coords := fromOrbitToDecart(elems);
      coords := rotate(coords,H);

      coordsToGeogr(coords,lamd,fi);
      Series1.AddXY(toDegrees(lamd),toDegrees(Fi));

      JD := JD + TObr/100/86400;
      elems[6] := elems[6] + 2*PI*0.01;
      Inc(i);
    end;
end;

end.
