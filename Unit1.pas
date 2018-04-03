unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,module,
  Vcl.Mask;

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
    procedure startBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  geogrCoords: array[1..101,1..2] of extended;

implementation

{$R *.dfm}


procedure TForm1.startBtnClick(Sender: TObject);
var elems: ElementsOfOrbit;
    day,month,year,hour,minute,second: extended;
    M0,MEnd,JD,H,Tobr: extended;
    coords: DecartCoords;
    i: integer;
begin
{=======================================
           ���� ����� ������
========================================}
    if aPole.Text = ''  then begin
      ShowMessage('�� �� ����� �������.');
      exit;
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

     if M0Pole.Text = ''  then begin
      ShowMessage('�� �� ����� ��������� ������� ��������.');
      exit;
    end;

    if tObrPole.Text = ''  then begin
      ShowMessage('�� �� ����� ������ ���������.');
      exit;
    end;

    try
      elems[1] := StrToFloat(aPole.Text);
    except
      ShowMessage('������� ������ ���� ������������� ����.');
      aPole.Text := '';
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

    try
      elems[6] := StrToFloat(M0Pole.Text);
      elems[6] := toRadians(elems[6]);
    except
      ShowMessage('��������� ������� �������� ������ ���� ������������� ����.');
      M0Pole.Text := '';
      exit;
    end;

    try
      Tobr := StrToFloat(tObrPole.Text);
    except
      ShowMessage('������ ��������� ������ ���� ������������� ����.');
      TobrPole.Text := '';
      exit;
    end;

    try
      day := StrToFloat(dateEdt.Text[1] + dateEdt.Text[2]);
      month := StrToFloat(dateEdt.Text[4] + dateEdt.Text[5]);
      year := StrToFloat(dateEdt.Text[7] + dateEdt.Text[8] + dateEdt.Text[9] +
      dateEdt.Text[10]);
    except
      showMessage('������������ ����');
    end;

    try
      hour := StrToFloat(timeEdt.Text[1] + timeEdt.Text[2]);
      minute := StrToFloat(timeEdt.Text[4] + timeEdt.Text[5]);
      second := StrToFloat(timeEdt.Text[7] + timeEdt.Text[8]);
    except
      showMessage('������������ �����');
    end;

    M0 := elems[6];
    MEnd := M0 + 2*PI;

{=======================================
      ����� ����� ����� ������
========================================}

    i := 1;
    while elems[6] <= MEnd do begin
    JD := JDate(year,month,day,hour,minute,second);
    H := sid2000(JD);

    coords := fromOrbitToDecart(elems);
    coords := rotate(coords,H);

    coordsToGeogr(coords,geogrCoords[i,1],geogrCoords[i,2]);

    JD := JD + TObr/100/86400;
    elems[6] := elems[6] + 2*PI*0.01;
    Inc(i);
    end;
end;

end.
