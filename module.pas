unit module;

{ћодуль дл€ лаборатории специализации}

interface
uses math;

type
  {ƒекартовы координаты и скорости: X,Y,Z,Vx,Vy,Vz}
  DecartCoords = array[1..6] of extended;

  {Ёлементы орбиты: a,e,i,Om,w,M}
  ElementsOfOrbit = array[1..6] of extended;

const
  EARTH_ROT_SPEED = 2*PI/86400;
  STANDARD_ERA = 2451545.0;
  MU = 398600.4418;
  EPS = 10E-12;
  RAD = PI/180;
  EARTH_RAD = 6378.1363;

function sid2000(jd: extended): extended;

procedure reduce(A: extended; var B: extended);

{ѕереход от элементов орбиты к декартовым координатам}
function fromOrbitToDecart(elem: ElementsOfOrbit): DecartCoords;

{–ешение уравнени€  еплера методом ньютона}
function keplerSolution(e,M: extended): extended;

{ѕреобразует григорианскую дату в юлианскую}
function JDate(year,month,day,hour,minute,second: extended): extended;

{«вездное врем€ на среднюю гринвичскую полночь}
function siderealTime(year,month,day: extended): extended;

{перевод времени к дес€тичной дроби}
function timeToDotTime(hour,minute,second: extended): extended;

{¬озвращает уравнение  еплера}
function keplerEq(x,e,M: extended): extended;

{¬озвращает производную уравнени€  еплера}
function keplerDifEq(x,e: extended): extended;

{ѕолучаем среднюю аномалию}
function getM(t,t0,M0,a: extended): extended;

{ѕолучаем среднее движение}
function getN(a: extended): extended;

function toRadians(a: extended): extended;

function toDegrees(a: extended): extended;

function rotate(a: DecartCoords; angle: extended): DecartCoords;

procedure coordsToGeogr(coords: DecartCoords; var long,lat: extended);

Procedure orbit(a,e,koren1,i,omegamal,omegabol:extended; var x,y,z,xt,yt,zt:extended);

procedure kepindek(e,ext,a,i,mu,sigb,sigm:extended;
                   var x : array of extended);

function date_jd(year,month:integer;day:extended):extended;

function lookZones(fi,lam,jd: extended; coord: DecartCoords): extended;

procedure graphicsZones(fi,lam,Az,Hmin,jd,a: extended;var f,l: extended);

implementation

function sid2000(jd:extended):extended;
const jd2000=2451545;
      jdyear=36525;
var m,mm,d,t,s,sr:extended;
begin
m:=frac(jd)-0.5;
d:=jd-m-jd2000;
{writeln(jd2000);
writeln('jd-j2000',d);}
t:=(d+m)/jdyear;
mm:=m*86400;
s:=(24110.54841+mm+236.555367908*(d+m)+(0.093104*t+6.21E-6*sqr(t))*t)
   /86400*2*pi;
reduce(s,sr);
sid2000:=sr
end;


PROCEDURE REDUCE(A:EXTENDED;VAR B:EXTENDED);
{CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
 C  ПPИBEДEHИE YГЛA B ПPEДEЛЫ OT 0 ДO 2*PI.
 C  BEЛИЧИHA YГЛA, BЫPAЖEHHAЯ B PAДИAHHOЙ MEPE, ПPИBOДИTCЯ B
 C  ПPEДEЛЫ  0 - 2*PI ПYTEM CБPOCA ЦEЛOГO ЧИCЛA OБOPOTOB.
 C     A - ЧИCЛ0,BЫPAЖEHHOE B PAДИAHHOЙ MEPE.
 C     B - PEЗYЛЬTAT.
 C  B MOЖET COBПAДATЬ C A.
 C  ЯЗЫK PASCAL.
 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
      CONST PI2=PI*2;
      BEGIN
      B:=A-trunc(A/PI2)*PI2;
      IF A<0 THEN B:=B+PI2;
      END;


{ѕереход от элементов орбиты к декартовым координатам}
function fromOrbitToDecart(elem: ElementsOfOrbit): DecartCoords;
var
  p,v,u,r: extended;
  EAnomaly: extended;
  Vn,Vr: extended;
  coords: DecartCoords;
begin
  p := elem[1]*(1 - sqr(elem[2]));
  EAnomaly := keplerSolution(elem[2],elem[6]);
  v := arctan2(sqrt(1 + elem[2])*tan(EAnomaly/2),sqrt(1 - elem[2]))*2;
  r := elem[1]*(1 - sqr(elem[2]))/(1 + elem[2]*cos(v));
  u := v + elem[5];

  Vr := sqrt(MU/p)*elem[2]*sin(v);
  Vn := sqrt(MU/p)*(1 + elem[2]*cos(v));

  coords[1] := r*(cos(u)*cos(elem[4]) - sin(u)*sin(elem[4])*cos(elem[3]));
  coords[2] := r*(cos(u)*sin(elem[4]) + sin(u)*cos(elem[4])*cos(elem[3]));
  coords[3] := r*sin(u)*sin(elem[3]);

  coords[4] := coords[1]/r*Vr + (-sin(u)*cos(elem[4]) - cos(u)*sin(elem[4])*cos(elem[3]))*Vn;
  coords[5] := coords[2]/r*Vr + (-sin(u)*sin(elem[4]) + cos(u)*cos(elem[4])*cos(elem[3]))*Vn;
  coords[6] := coords[3]/r*Vr + cos(u)*sin(elem[3])*Vn;

  result := coords;
end;


{–ешение уравнени€  еплера методом ньютона}
function keplerSolution(e,M: extended): extended;
var x1,x2: extended;
begin
  x2 := M;
  x1 := 0;
  while (abs(x2-x1) > EPS) do
    begin
     x1 := x2;
     x2 := x1 - keplerEq(x1,e,M)/keplerDifEq(x1,e);
    end; {while}
  result := x2;
end;


{ѕреобразует григорианскую дату в юлианскую}
function JDate(year,month,day,hour,minute,second: extended): extended;
var JDN,a,y,m,y1,m1,d1: integer;
begin
  y1 := trunc(year);
  m1 := trunc(month);
  d1 := trunc(day);

  a := (14 - m1) div 12;
  y := y1 + 4800 - a;
  m := m1 + 12*a -3;

  JDN := d1 + ((153*m + 2) div 5) + 365*y + (y div 4)- (y div 100) + (y div 400) - 32045;
  JDate := JDN + (hour - 12)/24 + minute/1440 + second/86400;
end;


{«вездное врем€ на среднюю гринвичскую полночь}
function siderealTime(year,month,day: extended): extended;
var teta,Tu,T,JD,sidTime: extended;
begin
  JD := JDate(year,month,day,0,0,0);
  Tu := JD - STANDARD_ERA;
  T := Tu/36525;
  teta := 360*(0.7790572732640 + 1.00273781191135448*Tu);
  sidTime := teta + (0.014506 + 4612.15739966*T + 1.39667721*sqr(T) +
  0.00009344*sqr(T)*T + 0.00001882*sqr(sqr(T)))/3600;

  while sidTime > 360 do
    sidTime := sidTime - 360;

  result := sidTime;
end;


{перевод времени к дес€тичной дроби}
function timeToDotTime(hour,minute,second: extended): extended;
begin
  result := hour + (minute + second/60)/60;
end;


{¬озвращает уравнение  еплера}
function keplerEq(x,e,M: extended): extended;
begin
  result := x - M - e*sin(x);
end;


{¬озвращает производную уравнени€  еплера}
function keplerDifEq(x,e: extended): extended;
begin
  result := 1 - e*cos(x);
end;


{ѕолучаем среднюю аномалию}
function getM(t,t0,M0,a: extended): extended;
begin
 result := M0 + getN(a)*(t - t0);
end;


{ѕолучаем среднее движение}
function getN(a: extended): extended;
begin
  result := sqrt(MU/(a*a*a));
end;

function toRadians(a: extended): extended;
begin
 result := a*RAD;
end;

function toDegrees(a: extended): extended;
begin
  result := a/RAD;
end;


function rotate(a: DecartCoords; angle: extended): DecartCoords;
var b: DecartCoords;
begin
  b[1] := cos(angle)*a[1] + sin(angle)*a[2];
  b[2] := -sin(angle)*a[1] + cos(angle)*a[2];
  b[3] := a[3];

  b[4] := cos(angle)*a[4] + sin(angle)*a[5];
  b[5] := -sin(angle)*a[4] + cos(angle)*a[5];
  b[6] := a[6];

  result := b;
end;


procedure coordsToGeogr(coords: DecartCoords; var long,lat: extended);
begin
  long := arctan2(coords[2],coords[1]);
  lat := arctan2(coords[3],sqrt(sqr(coords[1]) + sqr(coords[2])));

  if (long>pi) then long:=long-2*pi;
end;

Procedure orbit(a,e,koren1,i,omegamal,omegabol:extended; var x,y,z,xt,yt,zt:extended);
var
r,ksi,eta,px,py,pz,qx,qy,qz,p,u,v,vr,vn:extended;

begin
r:=a*(1-e*cos((koren1)));
ksi:=a*(cos(koren1)-e);
eta:=a*sqrt(1-Power(e,2))*sin(koren1);
Px:=cos(OmegaMal)*cos(OmegaBol)-sin(OmegaMal)*sin(OmegaBol)*cos(i);
Py:=cos(OmegaMal)*sin(OmegaBol)+sin(OmegaMal)*cos(OmegaBol)*cos(i);
Pz:=sin(OmegaMal)*sin(i);
Qx:=-sin(OmegaMal)*cos(OmegaBol)-cos(OmegaMal)*sin(OmegaBol)*cos(i);
Qy:=-sin(OmegaMal)*sin(OmegaBol)+cos(OmegaMal)*cos(OmegaBol)*cos(i);
Qz:=cos(OmegaMal)*sin(i);
x:=Px*ksi+Qx*eta;
y:=Py*ksi+Qy*eta;
z:=Pz*ksi+Qz*eta;
p:=a*(1-Power(e,2));
v:=ArcCos((cos(koren1)-e)/(1-e*cos(koren1)));
u:=ArcCos(cos(v)*cos(OmegaMal)-sin(v)*sin(OmegaMal));
Vr:=sqrt(mu/p)*e*sin(v);
Vn:=sqrt(mu/p)*(1+e*cos(v));
xt:=x/r*Vr+(-sin(u)*cos(OmegaBol)-cos(u)*sin(OmegaBol)*cos(i))*Vn;
yt:=y/r*Vr+(-sin(u)*sin(OmegaBol)+cos(u)*cos(OmegaBol)*cos(i))*Vn;
zt:=z/r*Vr+cos(u)*sin(i)*Vn;
end;

procedure kepindek(e,ext,a,i,mu,sigb,sigm:extended;
                   var x : array of extended);
var
  p,px,py,pz,qx,qy,qz,vr,vn,sinv,cosv,sinu,cosu,r,ksi,eta,v,v1:extended;
begin
  px:=cos(sigm)*cos(sigb)-sin(sigm)*sin(sigb)*cos(i);
  py:=cos(sigm)*sin(sigb)+sin(sigm)*cos(sigb)*cos(i);
  pz:=sin(sigm)*sin(i);
  qx:=-sin(sigm)*cos(sigb)-cos(sigm)*sin(sigb)*cos(i);
  qy:=-sin(sigm)*sin(sigb)+cos(sigm)*cos(sigb)*cos(i);
  qz:=cos(sigm)*sin(i);

  r:=a*(1-ext*cos(e));
  ksi:=a*(cos(e)-ext);
  eta:=a*sqrt(1-sqr(ext))*sin(e);

  x[0] :=px*ksi+qx*eta;
  x[1] :=py*ksi+qy*eta;
  x[2] :=pz*ksi+qz*eta;

  v:=sqrt(mu*((2/r)-(1/a)));
  sinv:=(sqrt(1-sqr(ext))*sin(e))/(1-ext*cos(e));
  cosv:=(cos(e)-ext)/(1-ext*cos(e));

  p := a*(1 - sqr(ext));
  vr:=sqrt(mu/p)*ext*sinv;
  vn:=sqrt(mu/p)*(1+ext*cosv);

  sinu:=sinv*cos(sigm)+cosv*sin(sigm);
  cosu:=cosv*cos(sigm)-sinv*sin(sigm);

  x[3] :=(x[0]/r)*vr+(-sinu*cos(sigb)-cosu*sin(sigb)*cos(i))*vn;
  x[4] :=(x[1]/r)*vr+(-sinu*sin(sigb)+cosu*cos(sigb)*cos(i))*vn;
  x[5] :=(x[2]/r)*vr+cosu*sin(i)*vn;
  v1:=sqrt(sqr(x[3])+sqr(x[4])+sqr(x[5]));
end;//kepindek


function date_jd(year,month:integer;day:extended):extended;
  label 1;
  const han=100;
  var m1,d,date,jd:extended;        {ѓ•а•еЃ§ Ѓв ™ Ђ•≠§ а≠Ѓ© § вл ™ JD}
      i,me,ja,jb:integer;
  begin
  date:=year+month/100+day/1e4;
  i:=trunc(date);
  m1:=(date-i)*han;
  me:=trunc(m1);
  d:=(m1-me)*han;
  if me>2 then goto 1;
  i:=i-1;
  me:=me+12;
1:jd:=trunc(365.25*i)+trunc(30.6001*(me+1))+d+1720994.5;
  if date<1582.1015 then
    begin
    date_jd:=jd;
    exit;
    end;
  ja:=trunc(i/100);
  jb:=2-ja+trunc(ja/4);
  jd:=jd+jb;
  date_jd:=jd;
  end;


function lookZones(fi,lam,jd: extended; coord: DecartCoords): extended;
var CRS_r, HTS_r,R: array[1..3] of extended;
    H,HTS_rad: extended;
begin
  H := sid2000(jd) + lam;

  CRS_r[3] := EARTH_RAD*sin(fi);
  CRS_r[1] := EARTH_RAD*cos(fi)*cos(H);
  CRS_r[2] := EARTH_RAD*cos(fi)*sin(H);

  HTS_r[1] := cos(H)*(coord[1] - CRS_r[1]) + sin(H)*(coord[2] - CRS_r[2]);
  HTS_r[2] := -sin(H)*(coord[1] - CRS_r[1]) + cos(H)*(coord[2] - CRS_r[2]);
  HTS_r[3] := coord[3] - CRS_r[3];

  R[1] := sin(fi)*HTS_r[1] - cos(fi)*HTS_r[3];
  R[2] := HTS_r[2];
  R[3] := cos(fi)*HTS_r[1] + sin(fi)*HTS_r[3];

  HTS_rad := sqrt(sqr(R[1]) + sqr(R[2]) + sqr(R[3]));
  result := arcsin(R[3]/HTS_rad);
end;


procedure graphicsZones(fi,lam,Az,Hmin,jd,a: extended;var f,l: extended);
var beta,R_c,H,R,sidTime: extended;
    R_sez,CRS_Rad,CRS_r,CRS_X1,CRS_X,y: array[1..3] of extended;
begin
  CRS_X[3] := EARTH_RAD*sin(Fi);
  H := sid2000(jd) + Lam;
  sidTime := sid2000(jd);
  CRS_X[1] := EARTH_RAD*cos(Fi)*cos(H);
  CRS_X[2] := EARTH_RAD*cos(Fi)*sin(H);

  Beta := arccos(EARTH_RAD*cos(Hmin)/a) - Hmin;
  R_c := sqrt(sqr(EARTH_RAD) + sqr(a) - 2*EARTH_RAD*a*cos(Beta));

  R_sez[1] := R_c*cos(Az)*cos(Hmin);
  R_sez[2] := -R_c*cos(Hmin)*sin(Az);
  R_sez[3] := R_c*sin(Hmin);

  CRS_Rad[1] := sin(Fi)*R_sez[1] + cos(Fi)*R_sez[3];
  CRS_Rad[2] := R_sez[2];
  CRS_Rad[3] := -cos(Fi)*R_sez[1] + sin(Fi)*R_sez[3];

  CRS_X1[1] := CRS_X[1] + (cos(H)*CRS_Rad[1] -
  sin(H)*CRS_Rad[2]);
  CRS_X1[2] := CRS_X[2] + (sin(H)*CRS_Rad[1] +
  cos(H)*CRS_Rad[2]);
  CRS_X1[3] := CRS_X[3] + CRS_Rad[3];

  y[1] := cos(SidTime)*CRS_X1[1] + sin(SidTime)*CRS_X1[2];
  y[2] := -sin(SidTime)*CRS_X1[1] + cos(SidTime)*CRS_X1[2];
  y[3] := CRS_X1[3];

  l := arctan2(y[2],y[1]);

  r := sqrt(sqr(y[1]) + sqr(y[2]) + sqr(y[3]));
  f := arcsin(y[3]/r);
end;

end.
