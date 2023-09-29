{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2023 CnPack 开发组                       }
{                   ------------------------------------                       }
{                                                                              }
{            本开发包是开源的自由软件，您可以遵照 CnPack 的发布协议来修        }
{        改和重新发布这一程序。                                                }
{                                                                              }
{            发布这一开发包的目的是希望它有用，但没有任何担保。甚至没有        }
{        适合特定目的而隐含的担保。更详细的情况请参阅 CnPack 发布协议。        }
{                                                                              }
{            您应该已经和开发包一起收到一份 CnPack 发布协议的副本。如果        }
{        还没有，可访问我们的网站：                                            }
{                                                                              }
{            网站地址：http://www.cnpack.org                                   }
{            电子邮件：master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnEditorExtractString;
{* |<PRE>
================================================================================
* 软件名称：CnPack IDE 专家包
* 单元名称：从源码中抽取字符串单元
* 单元作者：刘啸 (liuxiao@cnpack.org)
* 备    注：
* 开发平台：PWin2000Pro + Delphi 5.01
* 兼容测试：PWin9X/2000/XP + Delphi 5/6/7
* 本 地 化：该窗体中的字符串均符合本地化处理方式
* 修改记录：2023.02.10 V1.0
*               创建单元，实现功能
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNCODINGTOOLSETWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ToolsAPI,
  TypInfo, StdCtrls, ExtCtrls, ComCtrls, IniFiles, Clipbrd, Buttons, ActnList,
  CnConsts, CnCommon, CnHashMap, CnWizConsts, CnWizUtils, CnCodingToolsetWizard,
  CnWizMultiLang, CnEditControlWrapper, mPasLex, CnPasCodeParser, CnWidePasParser,
  Menus;

type
  TCnStringHeadType = (htVar, htConst, htResourcestring);

  TCnStringAreaType = (atInterface, atImplementation);

  TCnEditorExtractString = class(TCnBaseCodingToolset)
  private
    FUseUnderLine: Boolean;
    FIgnoreSingleChar: Boolean;
    FMaxWords: Integer;
    FMaxPinYinWords: Integer;
    FPrefix: string;
    FIdentWordStyle: TCnIdentWordStyle;
    FUseFullPinYin: Boolean;
    FShowPreview: Boolean;
    FIgnoreSimpleFormat: Boolean;
    FEditStream: TMemoryStream;
    FPasParser: TCnGeneralPasStructParser;
    FTokenListRef: TCnIdeStringList;
    FBeforeImpl: Boolean;
    FToArea: Integer;
    FMakeType: Integer;
    function CanExtract(const S: PCnIdeTokenChar): Boolean;
  protected
    function GetPasTokenStr(Token: TCnGeneralPasToken): TCnIdeTokenString;
  public
    constructor Create(AOwner: TCnCodingToolsetWizard); override;
    destructor Destroy; override;

    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    function GetState: TWizardState; override;
    procedure Execute; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;

    function Scan: Boolean;
    {* 扫描当前源码中的字符串，返回扫描是否成功。
    　内部创建 Stream/Parser，并产出在 TokenListRef 中，以及 FBeforeImpl}
    procedure MakeUnique;
    {* 将 TokenListRef 中的字符串判重并加上 1 等后缀}
    function GenerateDecl(OutList: TCnIdeStringList; HeadType: TCnStringHeadType): Boolean;
    {* 从 FTokenListRef 中生成 var 或 const 的声明块，内部要使用 FEditStream，产出内容放 OutList 中}
    function Replace: Integer;
    {* 将字符串替换为变量名，不插入声明，内部要使用 FEditStream。返回替换的个数}
    function InsertDecl(Area: TCnStringAreaType; HeadType: TCnStringHeadType): Integer;
    {* 将声明插入当前源码指定部分。返回插入的条数}

    procedure FreeTokens;
    {* 处理完毕后外界须调用以释放内存}
    property TokenListRef: TCnIdeStringList read FTokenListRef;
    {* 扫描结果，对象均是引用}
    property BeforeImpl: Boolean read FBeforeImpl;
    {* 是否有在 implementation 之前的字符串}

  published
    property IgnoreSingleChar: Boolean read FIgnoreSingleChar write FIgnoreSingleChar;
    {* 扫描时是否忽略单字符的字符串}
    property IgnoreSimpleFormat: Boolean read FIgnoreSimpleFormat write FIgnoreSimpleFormat;
    {* 扫描时是否忽略简单的格式化字符串}

    property Prefix: string read FPrefix write FPrefix;
    {* 生成的变量名的前缀，可为空，但不推荐}
    property UseUnderLine: Boolean read FUseUnderLine write FUseUnderLine;
    {* 变量名的分词是否使用下划线作为分隔符}
    property IdentWordStyle: TCnIdentWordStyle read FIdentWordStyle write FIdentWordStyle;
    {* 变量名的分词风格，全大写还是全小写还是首字母大写别的小写}
    property UseFullPinYin: Boolean read FUseFullPinYin write FUseFullPinYin;
    {* 遇到汉字时是使用全拼还是拼音首字母，True 为前者}
    property MaxPinYinWords: Integer read FMaxPinYinWords write FMaxPinYinWords;
    {* 最多的拼音分词个数}
    property MaxWords: Integer read FMaxWords write FMaxWords;
    {* 最多的普通英文分词个数}
    property ShowPreview: Boolean read FShowPreview write FShowPreview;
    {* 是否显示预览窗口}
    property MakeType: Integer read FMakeType write FMakeType;
    {* 生成的字符串类型是 var 还是 const 还是 resourcestring}
    property ToArea: Integer read FToArea write FToArea;
    {* 生成的字符串放置区域是 interface 还是 implementation}
  end;

  TCnExtractStringForm = class(TCnTranslateForm)
    grpScanOption: TGroupBox;
    chkIgnoreSingleChar: TCheckBox;
    chkIgnoreSimpleFormat: TCheckBox;
    grpPinYinOption: TGroupBox;
    lblPinYin: TLabel;
    cbbPinYinRule: TComboBox;
    btnReScan: TButton;
    pnl1: TPanel;
    lvStrings: TListView;
    mmoPreview: TMemo;
    spl1: TSplitter;
    cbbMakeType: TComboBox;
    lblMake: TLabel;
    lblToArea: TLabel;
    cbbToArea: TComboBox;
    btnHelp: TButton;
    btnReplace: TButton;
    btnClose: TButton;
    lblPrefix: TLabel;
    edtPrefix: TEdit;
    lblStyle: TLabel;
    cbbIdentWordStyle: TComboBox;
    lblMaxWords: TLabel;
    edtMaxWords: TEdit;
    udMaxWords: TUpDown;
    lblMaxPinYin: TLabel;
    edtMaxPinYin: TEdit;
    udMaxPinYin: TUpDown;
    chkUseUnderLine: TCheckBox;
    chkShowPreview: TCheckBox;
    btnCopy: TSpeedButton;
    actlstExtract: TActionList;
    actRescan: TAction;
    actCopy: TAction;
    actReplace: TAction;
    actEdit: TAction;
    actDelete: TAction;
    pmStrings: TPopupMenu;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    procedure chkShowPreviewClick(Sender: TObject);
    procedure lvStringsData(Sender: TObject; Item: TListItem);
    procedure FormCreate(Sender: TObject);
    procedure lvStringsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvStringsDblClick(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actRescanExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure actlstExtractUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure actDeleteExecute(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    FTool: TCnEditorExtractString;
    procedure UpdateTokenToListView;
    procedure LoadSettings;
    procedure SaveSettings;
  protected
    function GetHelpTopic: string; override;
  public
    property Tool: TCnEditorExtractString read FTool write FTool;
  end;

{$ENDIF CNWIZARDS_CNCODINGTOOLSETWIZARD}

implementation

{$IFDEF CNWIZARDS_CNCODINGTOOLSETWIZARD}

{$R *.DFM}

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

const
  CnSourceStringPosKinds: TCodePosKinds = [pkField, pkProcedure, pkFunction,
    pkConstructor, pkDestructor, pkFieldDot];

  SCN_HEAD_STRS: array[TCnStringHeadType] of string = ('var', 'const', 'resourcestring');

  SCN_AREA_STRS: array[TCnStringAreaType] of string = ('interface', 'implementation');
  CN_DEF_MAX_WORDS = 6;

{ TCnExtractStringForm }

procedure TCnExtractStringForm.chkShowPreviewClick(Sender: TObject);
begin
  mmoPreview.Visible := chkShowPreview.Checked;
  // spl1.Visible := chkShowPreview.Checked;
end;

procedure TCnExtractStringForm.UpdateTokenToListView;
begin
  lvStrings.Items.Count := FTool.FTokenListRef.Count;
  lvStrings.Invalidate;
end;

procedure TCnExtractStringForm.lvStringsData(Sender: TObject;
  Item: TListItem);
var
  Token: TCnGeneralPasToken;
begin
  if (Item.Index >= 0) and (Item.Index < FTool.TokenListRef.Count) then
  begin
    Token := TCnGeneralPasToken(FTool.TokenListRef.Objects[Item.Index]);
    Item.Caption := IntToStr(Item.Index + 1);
    Item.Data := Token;

    with Item.SubItems do
    begin
      Add(FTool.TokenListRef[Item.Index]);
      Add(FTool.GetPasTokenStr(Token));
    end;
  end;
end;

procedure TCnExtractStringForm.LoadSettings;
begin
  if FTool = nil then
    Exit;

  edtPrefix.Text := FTool.Prefix;
  cbbIdentWordStyle.ItemIndex := Ord(FTool.IdentWordStyle);
  if FTool.UseFullPinYin then
    cbbPinYinRule.ItemIndex := 1
  else
    cbbPinYinRule.ItemIndex := 0;
  udMaxWords.Position := FTool.MaxWords;
  udMaxPinYin.Position := FTool.MaxPinYinWords;
  chkUseUnderLine.Checked := FTool.UseUnderLine;
  chkIgnoreSingleChar.Checked := FTool.IgnoreSingleChar;
  chkIgnoreSimpleFormat.Checked := FTool.IgnoreSimpleFormat;
  chkShowPreview.Checked := FTool.ShowPreview;
  cbbMakeType.ItemIndex := FTool.MakeType;
  cbbToArea.ItemIndex := FTool.ToArea;
end;

procedure TCnExtractStringForm.SaveSettings;
begin
  if FTool = nil then
    Exit;

  FTool.Prefix := edtPrefix.Text;
  FTool.IdentWordStyle := TCnIdentWordStyle(cbbIdentWordStyle.ItemIndex);
  FTool.UseFullPinYin := cbbPinYinRule.ItemIndex = 1;

  FTool.MaxWords := udMaxWords.Position;
  FTool.MaxPinYinWords := udMaxPinYin.Position;
  FTool.UseUnderLine := chkUseUnderLine.Checked;
  FTool.IgnoreSingleChar := chkIgnoreSingleChar.Checked;
  FTool.IgnoreSimpleFormat := chkIgnoreSimpleFormat.Checked;
  FTool.ShowPreview := chkShowPreview.Checked;
  FTool.MakeType := cbbMakeType.ItemIndex;
  FTool.ToArea := cbbToArea.ItemIndex;
end;

procedure TCnExtractStringForm.FormCreate(Sender: TObject);
var
  EditorCanvas: TCanvas;
  I: TCnStringHeadType;
  J: TCnStringAreaType;
begin
  btnCopy.Caption := '';

  for I := Low(SCN_HEAD_STRS) to High(SCN_HEAD_STRS) do
    cbbMakeType.Items.Add(SCN_HEAD_STRS[I]);
  for J := Low(SCN_AREA_STRS) to High(SCN_AREA_STRS) do
    cbbToArea.Items.Add(SCN_AREA_STRS[J]);

  cbbMakeType.ItemIndex := 0;
  cbbToArea.ItemIndex := 0;

  EditorCanvas := EditControlWrapper.GetEditControlCanvas(CnOtaGetCurrentEditControl);
  if EditorCanvas <> nil then
  begin
{$IFDEF DEBUG}
    CnDebugger.LogMsg('Get EditConrol Canvas Font ' + EditorCanvas.Font.Name);
{$ENDIF}
    if EditorCanvas.Font.Name <> mmoPreview.Font.Name then
      mmoPreview.Font.Name := EditorCanvas.Font.Name;
    mmoPreview.Font.Size := EditorCanvas.Font.Size;
    mmoPreview.Font.Style := EditorCanvas.Font.Style - [fsUnderline, fsStrikeOut, fsItalic];
  end;
end;

procedure TCnExtractStringForm.lvStringsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
const
  CnBeforeLine = 1;
  CnAfterLine = 4;
var
  Token: TCnGeneralPasToken;
begin
  if not Selected or (Item = nil) or (Item.Data = nil) then
    Exit;

  Token := TCnGeneralPasToken(Item.Data);
  mmoPreview.Lines.Text := CnOtaGetLineText(Token.EditLine - CnBeforeLine,
    nil, CnBeforeLine + CnAfterLine);
end;

function TCnExtractStringForm.GetHelpTopic: string;
begin
  Result := 'CnEditorExtractString';
end;

procedure TCnExtractStringForm.lvStringsDblClick(Sender: TObject);
begin
  actEdit.Execute;
end;

procedure TCnExtractStringForm.actCopyExecute(Sender: TObject);
var
  L: TCnIdeStringList;
  HT: TCnStringHeadType;
begin
  if (FTool.TokenListRef = nil) or (FTool.TokenListRef.Count <= 0) then
    Exit;

  L := TCnIdeStringList.Create;
  try
    HT := TCnStringHeadType(cbbMakeType.ItemIndex);
    if FTool.GenerateDecl(L, HT) then
    begin
      Clipboard.AsText := L.Text;
      InfoDlg(Format(SCnEditorExtractStringCopiedFmt, [L.Count - 1, SCN_HEAD_STRS[HT]]));
    end;
  finally
    L.Free;
  end;
end;

procedure TCnExtractStringForm.actRescanExecute(Sender: TObject);
begin
  if FTool = nil then
    Exit;

  SaveSettings;
  if FTool.Scan then
  begin
    if FTool.TokenListRef.Count <= 0 then
    begin
      ErrorDlg(SCnEditorExtractStringNotFound);
      Exit;
    end;
{$IFDEF DEBUG}
    CnDebugger.LogMsg('Rescan OK. To Make Unique.');
{$ENDIF}

    FTool.MakeUnique;

{$IFDEF DEBUG}
    CnDebugger.LogMsg('Make Unique OK. Update To ListView.');
{$ENDIF}

    if FTool.BeforeImpl then
      cbbToArea.ItemIndex := Ord(atInterface)
    else
      cbbToArea.ItemIndex := Ord(atImplementation);

    UpdateTokenToListView;
  end;
end;

procedure TCnExtractStringForm.actEditExecute(Sender: TObject);
var
  Idx, K: Integer;
  S, OldName, OldValue: string;
  Token: TCnGeneralPasToken;
begin
  if lvStrings.Selected = nil then
    Exit;

  Idx := lvStrings.Selected.Index;
  if (Idx < 0) or (Idx >= FTool.TokenListRef.Count) then
    Exit;

  S := FTool.TokenListRef[Idx];
  OldName := S;
  Token := TCnGeneralPasToken(FTool.TokenListRef.Objects[Idx]);
  if Token <> nil then
    OldValue := Token.Token
  else
    OldValue := '';

  if CnWizInputQuery(SCnEditorExtractStringChangeName, SCnEditorExtractStringEnterNewName, S) then
  begin
    if (S <> OldName) and (S <> '') then
    begin
      // 拿到旧名字和旧值，挨个搜索，如果有新名字和不同于旧值的，出错退出。
      // 如果有多个旧名字旧值，则都更改成新名字
      for K := 0 to FTool.TokenListRef.Count - 1 do
      begin
        if (FTool.TokenListRef[K] = S) then // 如果有项等于新名字
        begin
          Token := TCnGeneralPasToken(FTool.TokenListRef.Objects[K]);
          if Token.Token <> OldValue then   // 且其值不等于旧值
          begin
            ErrorDlg(SCnEditorExtractStringDuplicatedName);
            Exit;
          end;
        end;
      end;

      for K := 0 to FTool.TokenListRef.Count - 1 do
      begin
        if (FTool.TokenListRef[K] = OldName) then // 如果有项等于旧名字
        begin
          Token := TCnGeneralPasToken(FTool.TokenListRef.Objects[K]);
          if Token.Token = OldValue then          // 且其值等于旧值
          begin
            FTool.TokenListRef[K] := S;           // 则都改成新名字
          end;
        end;
      end;

      lvStrings.Invalidate;
    end;
  end;
end;

procedure TCnExtractStringForm.actReplaceExecute(Sender: TObject);
var
  N, S: Integer;
begin
  if not QueryDlg(SCnEditorExtractStringAskReplace) then
    Exit;

  N := FTool.Replace;
  if N > 0 then
  begin
    S := FTool.InsertDecl(TCnStringAreaType(cbbToArea.ItemIndex),
      TCnStringHeadType(cbbMakeType.ItemIndex));
    if S > 0 then
    begin
      InfoDlg(Format(SCnEditorExtractStringReplacedFmt, [N, S]));
      Close;
    end;
  end;
end;

procedure TCnExtractStringForm.actlstExtractUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  if (Action = actEdit) or (Action = actDelete) then
    (Action as TCustomAction).Enabled := lvStrings.Selected <> nil
  else if {(Action = actCopy) or } (Action = actReplace) then
    (Action as TCustomAction).Enabled := lvStrings.Items.Count > 0
  else if Action = actRescan then
    (Action as TCustomAction).Enabled := CurrentIsDelphiSource;
end;

procedure TCnExtractStringForm.actDeleteExecute(Sender: TObject);
var
  Idx: Integer;
begin
  if lvStrings.Selected = nil then
    Exit;

  Idx := lvStrings.Selected.Index;
  if (Idx < 0) or (Idx >= FTool.TokenListRef.Count) then
    Exit;

  FTool.TokenListRef.Delete(Idx);
  UpdateTokenToListView;

  if FTool.TokenListRef.Count = 0 then
    mmoPreview.Lines.Clear;
end;

procedure TCnExtractStringForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

{ TCnEditorExtractString }

function TCnEditorExtractString.CanExtract(const S: PCnIdeTokenChar): Boolean;
var
  L: Integer;
begin
  Result := False;
{$IFDEF IDE_STRING_ANSI_UTF8} // 非 Unicode 编译器下针对 PWideChar 求长度，只能用 Windows API
  L := lstrlenW(S);
{$ELSE}
  L := StrLen(S);             // 非 Unicode 编译器下针对 PAnsiChar 求长度，以及 Unicode 编译器下针对 PWideChar 求长度
{$ENDIF}
  if L <= 2 then // 单引号或不全，不算
    Exit;

  if FIgnoreSingleChar and (L = 3) and (S[0] = '''') and (S[2] = '''') then // 单个字符也不算
    Exit;

  if FIgnoreSingleChar and (L = 4) and (S[0] = '''') and (S[1] = '''')
    and (S[2] = '''') and (S[2] = '''') then // 单个单引号也不算
    Exit;

  if FIgnoreSimpleFormat and IsSimpleFormat(S) then
    Exit;

  Result := True;
end;

constructor TCnEditorExtractString.Create(AOwner: TCnCodingToolsetWizard);
begin
  inherited;
  FIdentWordStyle := iwsUpperCase;
  FPrefix := 'S';
  FMaxWords := CN_DEF_MAX_WORDS;
  FMaxPinYinWords := CN_DEF_MAX_WORDS;
  FUseUnderLine := True;
  FIgnoreSingleChar := True;
  FIgnoreSimpleFormat := True;
  FShowPreview := True;
end;

destructor TCnEditorExtractString.Destroy;
begin
  FTokenListRef.Free;
  FPasParser.Free;
  FEditStream.Free;
  inherited;
end;

procedure TCnEditorExtractString.Execute;
var
  EditView: IOTAEditView;
begin
  EditView := CnOtaGetTopMostEditView;
  if EditView = nil then
    Exit;

  with TCnExtractStringForm.Create(Application) do
  begin
    Tool := Self;
    LoadSettings;

    if ShowModal = mrOK then
    begin
      SaveSettings;

    end;

    Free;
  end;
end;

procedure TCnEditorExtractString.FreeTokens;
begin
  FreeAndNil(FTokenListRef);
  FreeAndNil(FPasParser);
  FreeAndNil(FEditStream);
end;

function TCnEditorExtractString.GenerateDecl(OutList: TCnIdeStringList;
  HeadType: TCnStringHeadType): Boolean;
var
  I, L: Integer;
  Token: TCnGeneralPasToken;
begin
  Result := False;
  if (OutList = nil) or (FTokenListRef = nil) or (FTokenListRef.Count <= 0) then
    Exit;

  L := EditControlWrapper.GetBlockIndent;
  OutList.Clear;
  OutList.Add(SCN_HEAD_STRS[HeadType]);

  if HeadType in [htVar] then
  begin
    for I := 0 to FTokenListRef.Count - 1 do
    begin
      Token := TCnGeneralPasToken(FTokenListRef.Objects[I]);
      OutList.Add(Spc(L) + FTokenListRef[I] + ': string = ' + GetPasTokenStr(Token) + ';');
    end;
    RemoveDuplicatedStrings(OutList);
    Result := True;
  end
  else if HeadType in [htConst, htResourcestring] then
  begin
    for I := 0 to FTokenListRef.Count - 1 do
    begin
      Token := TCnGeneralPasToken(FTokenListRef.Objects[I]);
      OutList.Add(Spc(L) + FTokenListRef[I] + ' = ' + GetPasTokenStr(Token) + ';');
    end;
    RemoveDuplicatedStrings(OutList);
    Result := True;
  end;
end;

function TCnEditorExtractString.GetCaption: string;
begin
  Result := SCnEditorExtractStringMenuCaption;
end;

function TCnEditorExtractString.GetDefShortCut: TShortCut;
begin
  Result := 0;
end;

procedure TCnEditorExtractString.GetEditorInfo(var Name, Author,
  Email: string);
begin
  Name := SCnEditorExtractStringName;
  Author := SCnPack_LiuXiao;
  Email := SCnPack_LiuXiaoEmail;
end;

function TCnEditorExtractString.GetHint: string;
begin
  Result := SCnEditorExtractStringMenuHint;
end;

function TCnEditorExtractString.GetPasTokenStr(Token: TCnGeneralPasToken): TCnIdeTokenString;
var
  P: PByte;
begin
  Result := '';
  if (Token <> nil) and (Token.TokenLength > 0) then
  begin
    if Token.TokenLength < CN_TOKEN_MAX_SIZE then
      Result := TCnIdeTokenString(Token.Token)
    else if (FEditStream <> nil) and
      (FEditStream.Size >= (Token.TokenPos + Token.TokenLength) * SizeOf(Char)) then
    begin
      SetLength(Result, Token.TokenLength);
      P := FEditStream.Memory;
      Inc(P, Token.TokenPos * SizeOf(Char));
      Move(P^, Result[1], Token.TokenLength * SizeOf(Char));
    end;
  end;
end;

function TCnEditorExtractString.GetState: TWizardState;
begin
  Result := inherited GetState;
  if wsEnabled in Result then
  begin
    if not CurrentIsDelphiSource then
      Result := [];
  end;
end;

function TCnEditorExtractString.InsertDecl(Area: TCnStringAreaType;
  HeadType: TCnStringHeadType): Integer;
const
  KINDS: array[TCnStringAreaType] of TTokenKind = (tkInterface, tkImplementation);
var
  Lex: TCnGeneralWidePasLex;
  Stream: TMemoryStream;
  EditView: IOTAEditView;
  InsPos: Integer;
  Names: TCnIdeStringList;
  S: TCnIdeTokenString;
  EditWriter: IOTAEditWriter;
begin
  Result := 0;
  // 找 interface 或 implementation 后的 uses 的分号空，并插入其后，如无 uses，直接插入其后

  EditView := CnOtaGetTopMostEditView;
  if EditView = nil then
    Exit;

  Stream := nil;
  Lex := nil;
  Names := nil;

  try
    Stream := TMemoryStream.Create;
    CnGeneralSaveEditorToStream(EditView.Buffer, Stream);

    Lex := TCnGeneralWidePasLex.Create;
    Lex.Origin := Stream.Memory;

    while (Lex.TokenID <> tkNull) and (Lex.TokenID <> KINDS[Area]) do
      Lex.NextNoJunk;

    if Lex.TokenID = tkNull then
      Exit;

    // 此刻找到了 interface 或 implementation，记录其尾巴位置
    InsPos := Lex.TokenPos + Length(Lex.Token);

    while (Lex.TokenID <> tkNull) and (Lex.TokenID <> tkUses) do
      Lex.NextNoJunk;

    if Lex.TokenID <> tkNull then
    begin
      // 此刻找到了 uses，再找后面的第一个分号
      while (Lex.TokenID <> tkNull) and (Lex.TokenID <> tkSemiColon) do
        Lex.NextNoJunk;

      if Lex.TokenID <> tkNull then
      begin
        // 找到了 uses 后的第一个分号，再记录其尾巴位置
        InsPos := Lex.TokenPos + Length(Lex.Token);
      end;
    end;

    // 利用该位置，换算成编辑器里的线性位置，再插入换行加空行加内容
    Names := TCnIdeStringList.Create;
    if not GenerateDecl(Names, HeadType) then
      Exit;

    if Names.Count <= 1 then
      Exit;

    Result := Names.Count - 1;
    Names.Insert(0, '');
    Names.Insert(0, '');
    S := Names.Text;

    if Length(S) > 2 then // 去掉末尾多余的回车
    begin
      if (S[Length(S) - 1] = #13) and (S[Length(S)] = #10) then
        Delete(S, Length(S) - 1, 2);
    end;

    EditWriter := CnOtaGetEditWriterForSourceEditor;

{$IFDEF IDE_WIDECONTROL}
    // 插入时，Wide 要做 Utf8 转换
    EditWriter.CopyTo(Length(UTF8Encode(Copy(Lex.Origin, 1, InsPos))));
  {$IFDEF UNICODE}
    EditWriter.Insert(PAnsiChar(ConvertTextToEditorTextW(S)));
  {$ELSE}
    EditWriter.Insert(PAnsiChar(ConvertWTextToEditorText(S)));
  {$ENDIF}
{$ELSE}
    EditWriter.CopyTo(InsPos);
    EditWriter.Insert(PAnsiChar(ConvertTextToEditorText(S)));
{$ENDIF}
    EditWriter := nil;
  finally
    Names.Free;
    Lex.Free;
    Stream.Free;
  end;
end;

procedure TCnEditorExtractString.MakeUnique;
var
  I, J: Integer;
  Map: TCnStrToStrHashMap;
  S, H: string;
  Token: TCnGeneralPasToken;
begin
  if FTokenListRef.Count <= 1 then
    Exit;

  Map := TCnStrToStrHashMap.Create;
  try
    for I := 0 to FTokenListRef.Count - 1 do
    begin
      Token := TCnGeneralPasToken(FTokenListRef.Objects[I]);
      if Map.Find(string(FTokenListRef[I]), S) then
      begin
        if S <> string(GetPasTokenStr(Token)) then
        begin
          // 有同名的，但值不同，要换名
          J := 1;
          H := FTokenListRef[I];
          repeat
            FTokenListRef[I] := H + IntToStr(J);
            Inc(J);
          until not Map.Find(string(FTokenListRef[I]), S);

          // 换名后要添加
          Map.Add(string(FTokenListRef[I]), string(GetPasTokenStr(Token)));
        end;
        // 同名同值忽略
      end
      else // 无同名的，直接添加
        Map.Add(string(FTokenListRef[I]), string(GetPasTokenStr(Token)));
    end;
  finally
    Map.Free;
  end;
end;

function TCnEditorExtractString.Replace: Integer;
var
  I, LastTokenPos: Integer;
  EditView: IOTAEditView;
  Token, StartToken, EndToken, PrevToken: TCnGeneralPasToken;
  NewCode: TCnIdeTokenString;
  EditWriter: IOTAEditWriter;
begin
  Result := 0;
  EditView := CnOtaGetTopMostEditView;
  if EditView = nil then
    Exit;

  StartToken := TCnGeneralPasToken(FTokenListRef.Objects[0]);
  EndToken := TCnGeneralPasToken(FTokenListRef.Objects[FTokenListRef.Count - 1]);
  PrevToken := nil;

  // 拼接替换后的字符串
  for I := 0 to FTokenListRef.Count - 1 do
  begin
    Token := TCnGeneralPasToken(FTokenListRef.Objects[I]);
    if PrevToken = nil then
      NewCode := FTokenListRef[I]
    else
    begin
      // 从上一 Token 的尾巴，到现任 Token 的头，再加替换后的文字，用 Ansi/Wide/Wide String 来计算
      LastTokenPos := PrevToken.TokenPos + PrevToken.TokenLength;
      NewCode := NewCode + Copy(FPasParser.Source, LastTokenPos + 1,
        Token.TokenPos - LastTokenPos) + FTokenListRef[I];
    end;
    Inc(Result);
    PrevToken := TCnGeneralPasToken(FTokenListRef.Objects[I]);
  end;

  EditWriter := CnOtaGetEditWriterForSourceEditor;

{$IFDEF IDE_WIDECONTROL}
  // 插入时，Wide 要做 Utf8 转换
  EditWriter.CopyTo(Length(UTF8Encode(Copy(FPasParser.Source, 1, StartToken.TokenPos))));
  EditWriter.DeleteTo(Length(UTF8Encode(Copy(FPasParser.Source, 1, EndToken.TokenPos + EndToken.TokenLength))));
  {$IFDEF UNICODE}
  EditWriter.Insert(PAnsiChar(ConvertTextToEditorTextW(NewCode)));
  {$ELSE}
  EditWriter.Insert(PAnsiChar(ConvertWTextToEditorText(NewCode)));
  {$ENDIF}
{$ELSE}
  EditWriter.CopyTo(StartToken.TokenPos);
  EditWriter.DeleteTo(EndToken.TokenPos + (EndToken.TokenLength));
  EditWriter.Insert(PAnsiChar(ConvertTextToEditorText(AnsiString(NewCode))));
{$ENDIF}
  EditWriter := nil;
end;

function TCnEditorExtractString.Scan: Boolean;
var
  I, CurrPos, LastTokenPos: Integer;
  EditView: IOTAEditView;
  Token: TCnGeneralPasToken;
  EditPos: TOTAEditPos;
  Info: TCodePosInfo;
  S: TCnIdeTokenString;
  Lex: TCnGeneralWidePasLex;
begin
  Result := False;
  EditView := CnOtaGetTopMostEditView;
  if EditView = nil then
    Exit;

  Lex := nil;

  try
    FreeTokens;

    FPasParser := TCnGeneralPasStructParser.Create;
{$IFDEF BDS}
    FPasParser.UseTabKey := True;
    FPasParser.TabWidth := EditControlWrapper.GetTabWidth;
{$ENDIF}

    FEditStream := TMemoryStream.Create;
    CnGeneralSaveEditorToStream(EditView.Buffer, FEditStream);

{$IFDEF DEBUG}
    CnDebugger.LogMsg('CnEditorExtractString Scan to ParseString.');
{$ENDIF}

    // 解析当前显示的源文件中的字符串
    CnPasParserParseString(FPasParser, FEditStream);
    for I := 0 to FPasParser.Count - 1 do
    begin
      Token := FPasParser.Tokens[I];
      if CanExtract(Token.Token) then
      begin
        ConvertGeneralTokenPos(Pointer(EditView), Token);

{$IFDEF UNICODE}
        ParsePasCodePosInfoW(PChar(FEditStream.Memory), Token.EditLine, Token.EditCol, Info);
{$ELSE}
        EditPos.Line := Token.EditLine;
        EditPos.Col := Token.EditCol;
        CurrPos := CnOtaGetLinePosFromEditPos(EditPos);

        Info := ParsePasCodePosInfo(PChar(FEditStream.Memory), CurrPos);
{$ENDIF}
        Token.Tag := Ord(Info.PosKind);
      end
      else
        Token.Tag := Ord(pkUnknown);
    end;

{$IFDEF DEBUG}
    CnDebugger.LogInteger(FPasParser.Count, 'PasParser.Count');
{$ENDIF}

    if FTokenListRef = nil then
      FTokenListRef := TCnIdeStringList.Create
    else
      FTokenListRef.Clear;

    for I := 0 to FPasParser.Count - 1 do
    begin
      Token := FPasParser.Tokens[I];
      if TCodePosKind(Token.Tag) in CnSourceStringPosKinds then
      begin
        S := ConvertStringToIdent(string(Token.Token), FPrefix, FUseUnderLine,
          FIdentWordStyle, FUseFullPinYin, FMaxPinYinWords, FMaxWords);
        // 在 D2005~2007 下有 AnsiString 到 WideString 的转换但也无影响

        FTokenListRef.AddObject(S, Token);
      end;
    end;

{$IFDEF DEBUG}
    CnDebugger.LogInteger(FTokenListRef.Count, 'TokensRefList.Count');
{$ENDIF}

    FBeforeImpl := False;
    if FTokenListRef.Count > 0 then
    begin
      Token := TCnGeneralPasToken(FTokenListRef.Objects[0]);

      // 再找 implementation，看第一个是否在其前面
      FEditStream.Position := 0;
      Lex := TCnGeneralWidePasLex.Create;
      Lex.Origin := FEditStream.Memory;

      while not (Lex.TokenID in [tkNull, tkImplementation]) do
        Lex.NextNoJunk;

      if Lex.TokenID = tkImplementation then
      begin
{$IFDEF SUPPORT_WIDECHAR_IDENTIFIER}
        FBeforeImpl := Token.LineNumber < Lex.LineNumber - 1;
{$ELSE}
        FBeforeImpl := Token.LineNumber < Lex.LineNumber;
{$ENDIF}
      end;
    end;
    Result := True;
  finally
    Lex.Free;
  end;
end;

initialization
  RegisterCnCodingToolset(TCnEditorExtractString); // 注册工具

{$ENDIF CNWIZARDS_CNCODINGTOOLSETWIZARD}
end.
