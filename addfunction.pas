unit addfunction;

interface
  uses
    math;
  const
    eps = 2.22e-16;

  PROCEDURE REDUCE(A:EXTENDED;VAR B:EXTENDED);
  function sign(x:extended):integer;
  function ArcTg(x,y: extended): extended;
  function arcsin(x:extended):extended;
  function date_jd(year,month:integer;day:extended):extended;
  function sid2000(jd:extended):extended;
  function ArcCos(x: Extended):Extended;
  procedure SolutionOfKepEq(StartTime,EndTime,A_sml,ext,mu,m0 : extended;
                          var EccAnomaly : extended );
  procedure kepindek(e,ext,a,i,mu,sigb,sigm:extended;
                   var x: array of extended);

implementation
PROCEDURE REDUCE(A:EXTENDED;VAR B:EXTENDED);
{CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
 C  ÏPÈBEÄEHÈE YÃËA B ÏPEÄEËÛ OT 0 ÄO 2*PI.
 C  BEËÈ×ÈHA YÃËA, BÛPAÆEHHAß B PAÄÈAHHOÉ MEPE, ÏPÈBOÄÈTCß B
 C  ÏPEÄEËÛ  0 - 2*PI ÏYTEM CÁPOCA ÖEËOÃO ×ÈCËA OÁOPOTOB.
 C     A - ×ÈCË0,BÛPAÆEHHOE B PAÄÈAHHOÉ MEPE.
 C     B - PEÇYËÜTAT.
 C  B MOÆET COBÏAÄATÜ C A.
 C  ßÇÛK PASCAL.
 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
      CONST PI2=PI*2;
      BEGIN
      B:=A-trunc(A/PI2)*PI2;
      IF A<0 THEN B:=B+PI2;
      END;

function sign(x:extended):integer;
begin
if x>=0 then sign:=1
  else
if x<0 then sign:=-1;
end;


function ArcTg(x,y: extended): extended;
var a: extended;
begin
  if abs(y)<1e-18 then ArcTg:=sign(x)*0.5*Pi
  else
    begin
      a:=arctan(x/y);
      if y<0 then a:=a+pi;
      if a<0 then a:=a+2*pi;
      arctg:=a;
    end;
end;{arctg}

function arcsin(x:extended):extended;
    begin if abs(x)>1 then
            begin write('íåäîïóñòèìûé  àãóìåíò äëÿ arccos');
            halt end;
         if x=1  then begin arcsin:= 2*pi; exit end;
         if x=-1 then begin arcsin:=-2*pi; exit end;
       arcsin:=arctan(x/sqrt(1-sqr(x)))
   end;


function date_jd(year,month:integer;day:extended):extended;
  label 1;
  const han=100;
  var m1,d,date,jd:extended;        {¯¥à¥å®¤ ®â ª «¥­¤ à­®© ¤ âë ª JD}
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


function ArcCos(x: Extended):Extended;
{ arccos in [0,Pi] }
begin
 if x>0 then ArcCos:=ArcTan(sqrt(1-sqr(x))/x)
 else ArcCos:=Pi+ArcTan(sqrt(1-sqr(x))/x);
end; {ArcCos}

procedure SolutionOfKepEq(StartTime,EndTime,A_sml,ext,mu,m0 : extended;
                          var EccAnomaly : extended );
var
  n,m,EccAnomaly0 : extended;
begin
  n := sqrt(mu/power(A_sml,3));
  m := m0 + n*(EndTime - StartTime);
  EccAnomaly0 := m;
  EccAnomaly := m + ext*sin(EccAnomaly0);
  while abs(EccAnomaly - EccAnomaly0) > eps do begin
    EccAnomaly0 := EccAnomaly;
    EccAnomaly := m + ext*sin(EccAnomaly0);
  end;
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

end.
