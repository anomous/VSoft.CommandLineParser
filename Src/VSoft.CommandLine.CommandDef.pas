unit VSoft.CommandLine.CommandDef;

interface

uses
  Generics.Collections,
  VSoft.CommandLine.Options;

type
  TCommandDefImpl = class(TInterfacedObject, ICommandDefinition)
  private
    FName         : string;
    FAlias        : string;
    FDescription  : string;
    FUsage        : string;
    FVisible      : boolean;
    FOptionsLookup      : TDictionary<string,IOptionDefintion>;
    //can't put unnamed options in dictionary, so we keep a list
    FUnnamedOptions     : TList<IOptionDefintion>;
    //all registered options.
    FRegisteredOptions  : TList<IOptionDefintion>;
  protected
    procedure AddOption(const value: IOptionDefintion);
    function HasOption(const name : string) : boolean;
    function GetRegisteredOptions : TList<IOptionDefintion>;
    function GetUnNamedOptions  : TList<IOptionDefintion>;
    function GetName : string;
    function GetAlias : string;
    function GetDescription : string;
    function GetUsage : string;
    function GetVisible : boolean;
    function TryGetOption(const name : string; var option : IOptionDefintion) : boolean;
    procedure Clear;
    procedure GetAllRegisteredOptions(const list : TList<IOptionDefintion>);

  public
    constructor Create(const name : string; const alias : string; const usage : string; const description : string; const visible : boolean);
    destructor Destroy;override;

  end;

implementation

uses
  System.SysUtils;

{ TCommandDef }

procedure TCommandDefImpl.AddOption(const value: IOptionDefintion);
begin
  if value.IsUnnamed then
    FUnNamedOptions.Add(value)
  else
  begin
    FRegisteredOptions.Add(value);
    FOptionsLookup.AddOrSetValue(LowerCase(value.LongName),value);
    if value.ShortName <> '' then
      FOptionsLookup.AddOrSetValue(LowerCase(value.ShortName),value);
  end;

end;

procedure TCommandDefImpl.Clear;
begin
  FOptionsLookup.Clear;
  FRegisteredOptions.Clear;
  FUnnamedOptions.Clear;
end;

constructor TCommandDefImpl.Create(const name: string; const alias : string;  const usage : string; const description : string; const visible : boolean);
begin
  FName               := name;
  FUsage              := usage;
  FDescription        := description;
  FAlias              := alias;
  FVisible            := visible;

  FOptionsLookup      := TDictionary<string,IOptionDefintion>.Create;
  FUnnamedOptions     := TList<IOptionDefintion>.Create;
  FRegisteredOptions  := TList<IOptionDefintion>.Create;
end;

destructor TCommandDefImpl.Destroy;
begin
  FOptionsLookup.Free;
  FUnnamedOptions.Free;
  FRegisteredOptions.Free;
  inherited;
end;

function TCommandDefImpl.GetAlias: string;
begin
  result := FAlias;
end;

procedure TCommandDefImpl.GetAllRegisteredOptions(const list: TList<IOptionDefintion>);
begin
  list.AddRange(FUnnamedOptions);
  list.AddRange(FRegisteredOptions);
end;

function TCommandDefImpl.GetDescription: string;
begin
  result := FDescription;
end;

function TCommandDefImpl.GetName: string;
begin
  result := FName;
end;

function TCommandDefImpl.GetRegisteredOptions: TList<IOptionDefintion>;
begin
  result := FRegisteredOptions;
end;

function TCommandDefImpl.GetUnNamedOptions: TList<IOptionDefintion>;
begin
  result := FUnNamedOptions;
end;

function TCommandDefImpl.GetUsage: string;
begin
  result := FUsage;
end;

function TCommandDefImpl.GetVisible: boolean;
begin
  result := FVisible;
end;

function TCommandDefImpl.HasOption(const name: string): boolean;
begin
  result := FOptionsLookup.ContainsKey(LowerCase(name));
end;

function TCommandDefImpl.TryGetOption(const name: string; var option: IOptionDefintion): boolean;
begin
  result := FOptionsLookup.TryGetValue(LowerCase(name),option);
end;

end.
