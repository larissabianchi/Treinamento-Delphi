unit UnitFuncoes;

interface

  uses
  Vcl.Forms, System.SysUtils, System.Classes, Data.DB, Data.SqlExpr,
  Vcl.DBGrids, Vcl.Grids, System.Types, System.Generics.Collections;

  //As veze � necess�rio declarar a fun��o dentro da 'uses' tamb�m.
  function GetId (Campo, Tabela : String) : Integer;
  function GetLoginCadastrado (Login : String) : Boolean;
  procedure EditarDBGrid (DataSourse : TDataSource; Sender : TDBGrid; State: TGridDrawState; Rect : TRect; Column : TColumn);
  function StringToFloat(s : string) : Extended;

implementation

uses ModConexao, ufrmCadastroUsuarios;

  function GetId (Campo, Tabela : String) : Integer;
  begin
  with

  TSQLQuery.Create(nil) do
  try

    SQLConnection := DataModuleDados.SQLConnection;
    sql.Add('SELECT '+Campo+' FROM '+Tabela+' ORDER BY '+Campo+' DESC LIMIT 1');
    open;
    Result := Fields[0].AsInteger + 1;

  finally
    close;
    free;

  end;
  end;

  function GetLoginCadastrado (Login : String) : Boolean;
  begin
  result := false;

  with

  TSQLQuery.Create(nil) do
  try

    SQLConnection := DataModuleDados.SQLConnection;
    sql.Add(' SELECT ID FROM USUARIOS WHERE LOGIN = :LOGIN');
    Params[0].AsString := Login;
    Open;

  if not IsEmpty then
    result := true;

  finally
  close;
  free;

  end;
  end;

  procedure EditarDBGrid (DataSourse : TDataSource; Sender : TDBGrid; State: TGridDrawState; Rect : TRect; Column : TColumn);
    begin
      if not odd(DataSourse.DataSet.RecNo) then
    begin
      if not (gdSelected in state) then
      begin
        Sender.Canvas.Brush.Create.Color := $00FFEFDF;
        Sender.Canvas.FillRect(Rect);
        Sender.DefaultDrawDataCell(Rect,Column.Field, State);
      end;
    end;
  end;

  function StringToFloat(s : string) : Extended;
{ Filtra uma string qualquer, convertendo as suas partes
  num�ricas para sua representa��o decimal, por exemplo:
  'R$ 1.200,00' para 1200,00 '1AB34TZ' para 134}
var
  i :Integer;
  t : string;
  SeenDecimal,SeenSgn : Boolean;
begin
   t := '';
   SeenDecimal := False;
   SeenSgn := False;
   {Percorre os caracteres da string:}
   for i := Length(s) downto 0 do
  {Filtra a string, aceitando somente n�meros e separador decimal:}

     if (s[i] in ['0'..'9', '-','+',',']) then
     begin
        if (s[i] = ',') and (not SeenDecimal) then
        begin
           t := s[i] + t;
           SeenDecimal := True;
        end
        else if (s[i] in ['+','-']) and (not SeenSgn) and (i = 1) then
        begin
           t := s[i] + t;
           SeenSgn := True;
        end
        else if s[i] in ['0'..'9'] then
        begin
           t := s[i] + t;
        end;
     end;
   Result := StrToFloat(t);
end;

end.
