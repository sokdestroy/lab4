unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,module,
  Vcl.Mask, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart,Math,addfunction;

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
    CheckBox2: TCheckBox;
    NumOfTurnPole: TEdit;
    Label7: TLabel;
    Series1: TPointSeries;
    procedure startBtnClick(Sender: TObject);
    procedure M0PoleKeyPress(Sender: TObject; var Key: Char);
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

uses Unit2;


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
    EccAnomaly,lamd,fi,NumOfTurn,tm,EccAn,r  : extended;
    coords: DecartCoords;
    i: integer;
    MyDate, MyTime : TDateTime;
    x : array[1..6] of Extended;
    y : array[1..3] of Extended;
begin
{=======================================
           ���� ����� ������
========================================}

      if (aPole.Text = '') and (tObrPole.Text = '')  then begin
        ShowMessage('�� �� ����� ������� �����c� ��� ������ ���������.');
        exit;
      end else begin
        if (aPole.Text <> '') and (tObrPole.Text = '') then begin
          try
            elems[1] := StrToFloat(aPole.Text);
            Tobr := 2*pi*sqrt(power(elems[1],3)/mu);
          except
            ShowMessage('������� ������ ���� ������������� ����.');
            aPole.Text := '';
            exit;
          end;
        end else if (aPole.Text = '') and (tObrPole.Text <> '') then begin
          try
            if StrToFloat(tObrPole.Text) > 0 then begin
              Tobr := StrToFloat(tObrPole.Text);
              elems[1] := power(sqr(Tobr)*mu/sqr(2*pi),1/3);
            end else begin
              ShowMessage('������ ��������� ������ ���� ������������� ���� � ������ ����.');
              TobrPole.Text := '';
              exit;
            end;
          except
            ShowMessage('������ ��������� ������ ���� ������������� ���� � ������ ����.');
            TobrPole.Text := '';
            exit;
          end;
        end else if (aPole.Text <> '') and (tObrPole.Text <> '') then begin
          try
            elems[1] := StrToFloat(aPole.Text);
          except
            ShowMessage('������� ������ ���� ������������� ����.');
            aPole.Text := '';
            exit;
          end;

          try
            if StrToFloat(tObrPole.Text) > 0 then begin
              Tobr := StrToFloat(tObrPole.Text);
            end else begin
              ShowMessage('������ ��������� ������ ���� ������ ����.');
              TobrPole.Text := '';
              exit;
            end;
          except
            ShowMessage('������ ��������� ������ ���� ������������� ���� � ������ ����.');
            TobrPole.Text := '';
            exit;
          end;

          if abs(Tobr - 2*pi*sqrt(power(elems[1],3)/mu)) > 1 then begin
            Form2.ShowModal;
            if Form2.ModalResult = 777 then begin
              Tobr := 2*pi*sqrt(power(elems[1],3)/mu);
              tObrPole.Text := FloatToStr(Tobr);
            end else if Form2.ModalResult = 999 then begin
              elems[1] := power(sqr(Tobr)*mu/sqr(2*pi),1/3);
              aPole.Text := FloatToStr(elems[1]);
            end else exit;
          end;
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

    if NumOfTurnPole.Text = ''  then begin
      ShowMessage('�� �� ����� ���������� ��������.');
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

    //���������� ��� ���� � ������ ��� TDateTime
    try
      MyDate := StrToDate(dateEdt.Text);
      DecodeDate(MyDate,year,month,day);
    except
      showMessage('������������ ����');
    end;

    try
      MyTime := StrToTime(timeEdt.Text);
      DecodeTime(MyTime,hour,minute,second,Ms);
    except
      showMessage('������������ �����');
    end;

    try
      NumOfTurn := StrToInt(NumOfTurnPole.Text);
    except
      ShowMessage('���������� �������� ������ ���� �����');
      NumOfTurnPole.Text := '';
      exit;
    end;

    M0 := elems[6];
    //MEnd := M0 + 2*PI*NumOfTurn;

{=======================================
      ����� ����� ����� ������
========================================}
    Series1.Clear;
    {i := 1;
    JD := JDate(year,month,day,hour,minute,second);
    while elems[6] <= MEnd do begin

      H := sid2000(JD);

      coords := fromOrbitToDecart(elems);
      coords := rotate(coords,H);

      coordsToGeogr(coords,lamd,fi);
      Series1.AddXY(toDegrees(lamd),toDegrees(Fi));

      JD := JD + TObr/100/86400;
      elems[6] := elems[6] + 2*PI*0.01;
      Inc(i);
    end;}

    JD := JDate(year,month,day,hour,minute,second);
    EccAn := 2*arctan2(tan(-elems[5]*rad/2),
                              sqrt((1 + elems[2])/(1 - elems[2])));
    tm := 0;
    while (tm <= Tobr*NumOfTurn) do begin
      SolutionOfKepEq(0,tm,elems[1],elems[2],mu,M0, EccAn);
      kepindek(EccAn,elems[2],elems[1],elems[3],mu,elems[4],elems[5],x);

      H := sid2000(JD);

      y[1] := cos(H)*x[1] + sin(H)*x[2];
      y[2] := -sin(H)*x[1] + cos(H)*x[2];
      y[3] := x[3];

      lamd := arctan2(y[2],y[1]);

      r := sqrt(sqr(y[1]) + sqr(y[2]) + sqr(y[3]));
      fi := arcsin(y[3]/r);

      Series1.AddXY(toDegrees(lamd),toDegrees(Fi));
      JD := JD + Tobr/100/86400;
      tm := tm + Tobr/100;
    end;
end;

end.
