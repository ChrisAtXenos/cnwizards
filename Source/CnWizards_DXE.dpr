{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2024 CnPack 开发组                       }
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

library CnWizards_DXE;

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

uses
  CnWizDllEntry in 'Framework\CnWizDllEntry.pas',
  CnWizConsts in 'Framework\CnWizConsts.pas',
  CnWizCompilerConst in 'Framework\CnWizCompilerConst.pas',
  CnWizShortCut in 'Framework\CnWizShortCut.pas',
  CnWizMenuAction in 'Framework\CnWizMenuAction.pas',
  CnWizClasses in 'Framework\CnWizClasses.pas',
  CnWizManager in 'Framework\CnWizManager.pas',
  CnWizOptions in 'Framework\CnWizOptions.pas',
  CnWizSplash in 'Misc\CnWizSplash.pas',
  CnWizTipOfDayFrm in 'Misc\CnWizTipOfDayFrm.pas' {CnWizTipOfDayForm},
  CnWizAbout in 'Misc\CnWizAbout.pas',
  CnWizAboutFrm in 'Misc\CnWizAboutFrm.pas' {CnWizAboutForm},
  CnWizCommentFrm in 'Misc\CnWizCommentFrm.pas' {CnWizCommentForm},
  CnWizBoot in 'Misc\CnWizBoot.pas' {CnWizBootForm},
  CnWizFeedbackFrm in 'Misc\CnWizFeedbackFrm.pas' {CnWizFeedbackForm},
  CnWizShareImages in 'Misc\CnWizShareImages.pas' {dmCnSharedImages: TDataModule},
  CnWizUpgradeFrm in 'Misc\CnWizUpgradeFrm.pas' {CnWizUpgradeForm},
  CnIDEVersion in 'Misc\CnIDEVersion.pas',
  CnWizMultiLang in 'MultiLang\CnWizMultiLang.pas' {CnTranslateForm},
  CnWizMultiLangFrame in 'MultiLang\CnWizMultiLangFrame.pas' {CnTranslateFrame: TFrame},
  CnWizTranslate in 'MultiLang\CnWizTranslate.pas',
  CnWizUtils in 'Utils\CnWizUtils.pas',
  CnWizNotifier in 'Utils\CnWizNotifier.pas',
  CnWizIdeUtils in 'Utils\CnWizIdeUtils.pas',
  CnWizConfigFrm in 'Config\CnWizConfigFrm.pas' {CnWizConfigForm},
  CnWizMenuSortFrm in 'Config\CnWizMenuSortFrm.pas' {CnMenuSortForm},
  CnWizSubActionShortCutFrm in 'Config\CnWizSubActionShortCutFrm.pas' {CnWizSubActionShortCutForm},
  CnDesignEditor in 'DesignEditors\CnDesignEditor.pas',
  CnDesignEditorConsts in 'DesignEditors\CnDesignEditorConsts.pas',
  CnDesignEditorUtils in 'DesignEditors\CnDesignEditorUtils.pas',
  CnPropEditorCustomizeFrm in 'DesignEditors\CnPropEditorCustomizeFrm.pas' {CnPropEditorCustomizeForm},
  CnHintEditorFrm in 'DesignEditors\CnHintEditorFrm.pas' {CnHintEditorForm},
  CnMultiLineEditorFrm in 'DesignEditors\CnMultiLineEditorFrm.pas' {CnMultiLineEditorForm},
  CnSetPropEditor in 'DesignEditors\CnSetPropEditor.pas',
  CnDesignPropEditors in 'DesignEditors\CnDesignPropEditors.pas',
  CnDesignStringModule in 'DesignEditors\CnDesignStringModule.pas',
  CnSizeConstraintsEditorFrm in 'DesignEditors\CnSizeConstraintsEditorFrm.pas' {CnSizeConstraintsEditorForm},
  CnMultiLineEdtUserFmtFrm in 'DesignEditors\CnMultiLineEdtUserFmtFrm.pas' {CnMultiLineEditorUserFmtForm},
  CnMultiLineEdtToolOptFrm in 'DesignEditors\CnMultiLineEdtToolOptFrm.pas' {CnMultiLineEditorToolsOptionForm},
  CnAlignPropEditor in 'DesignEditors\CnAlignPropEditor.pas',
  CnFastCodeWizard in 'IdeEnhancements\CnFastCodeWizard.pas',
  CnDesignWizard in 'DesignWizard\CnDesignWizard.pas' {CnNonArrangeForm},
  CnCodingToolsetWizard in 'CodingToolset\CnCodingToolsetWizard.pas' {CnEditorToolsForm},
  CnListCompFrm in 'DesignWizard\CnListCompFrm.pas' {CnListCompForm},
  CnPropertyCompareFrm in 'DesignWizard\CnPropertyCompareFrm.pas' {CnPropertyCompareForm},
  CnPropertyCompConfigFrm in 'DesignWizard\CnPropertyCompConfigFrm.pas' {CnPropertyCompConfigForm},
  CnCompToCodeFrm in 'DesignWizard\CnCompToCodeFrm.pas' {CnCompToCodeForm},
  CnMessageBoxWizard in 'SimpleWizards\CnMessageBoxWizard.pas' {CnMessageBoxForm},
  CnComponentSelector in 'SimpleWizards\CnComponentSelector.pas' {CnComponentSelectorForm},
  CnTabOrderWizard in 'SimpleWizards\CnTabOrderWizard.pas' {CnTabOrderForm},
  CnBookmarkWizard in 'SimpleWizards\CnBookmarkWizard.pas' {CnBookmarkForm},
  CnWizControlHook in 'Utils\CnWizControlHook.pas',
  CnBookmarkConfigFrm in 'SimpleWizards\CnBookmarkConfigFrm.pas' {CnBookmarkConfigForm},
  CnWizMacroFrm in 'Utils\CnWizMacroFrm.pas' {CnWizMacroForm},
  CnWizMacroUtils in 'Utils\CnWizMacroUtils.pas',
  CnWizMacroText in 'Utils\CnWizMacroText.pas',
  CnSrcTemplate in 'SrcTemplate\CnSrcTemplate.pas' {CnSrcTemplateForm},
  CnSrcTemplateEditFrm in 'SrcTemplate\CnSrcTemplateEditFrm.pas' {CnSrcTemplateEditForm},
  CnEditorOpenFile in 'CodingToolset\CnEditorOpenFile.pas',
  CnEditorOpenFileFrm in 'CodingToolset\CnEditorOpenFileFrm.pas' {CnEditorOpenFileForm},
  CnEditorCodeSwap in 'CodingToolset\CnEditorCodeSwap.pas',
  CnEditorZoomFullScreen in 'CodingToolset\CnEditorZoomFullScreen.pas' {CnEditorZoomFullScreenForm},
  CnEditorCodeTool in 'CodingToolset\CnEditorCodeTool.pas',
  CnEditorCodeToString in 'CodingToolset\CnEditorCodeToString.pas' {CnEditorCodeToStringForm},
  CnEditorCodeDelBlank in 'CodingToolset\CnEditorCodeDelBlank.pas' {CnDelBlankForm},
  CnEditorCodeComment in 'CodingToolset\CnEditorCodeComment.pas' {CnEditorCodeCommentForm},
  CnEditorCodeIndent in 'CodingToolset\CnEditorCodeIndent.pas',
  CnAsciiChart in 'CodingToolset\CnAsciiChart.pas' {CnAsciiForm},
  CnEditorInsertColor in 'CodingToolset\CnEditorInsertColor.pas',
  CnEditorInsertTime in 'CodingToolset\CnEditorInsertTime.pas' {CnEditorInsertTimeForm},
  CnEditorCollector in 'CodingToolset\CnEditorCollector.pas' {CnEditorCollectorForm},
  CnEditorSortLines in 'CodingToolset\CnEditorSortLines.pas',
  CnEditorToggleUses in 'CodingToolset\CnEditorToggleUses.pas',
  CnEditorToggleVar in 'CodingToolset\CnEditorToggleVar.pas',
  CnEditorJumpMessage in 'CodingToolset\CnEditorJumpMessage.pas',
  CnEditorFontZoom in 'CodingToolset\CnEditorFontZoom.pas',
  CnEditorDuplicateUnit in 'CodingToolset\CnEditorDuplicateUnit.pas',
  CnEditorExtractString in 'CodingToolset\CnEditorExtractString.pas' {CnExtractStringForm},
  CnMsdnWizard in 'SimpleWizards\CnMsdnWizard.pas' {CnMsdnConfigForm},
  CnPas2HtmlWizard in 'SimpleWizards\CnPas2HtmlWizard.pas' {CnPas2HtmlForm},
  CnPasConvertTypeFrm in 'SimpleWizards\CnPasConvertTypeFrm.pas' {CnPasConvertTypeForm},
  CnPas2HtmlConfigFrm in 'SimpleWizards\CnPas2HtmlConfigFrm.pas' {CnPas2HtmlConfigForm},
  CnPasConvert in 'Utils\CnPasConvert.pas',
  CnWizEditFiler in 'Utils\CnWizEditFiler.pas',
  CnReplaceWizard in 'SimpleWizards\CnReplaceWizard.pas' {CnReplaceWizardForm},
  CnWizSearch in 'Utils\CnWizSearch.pas',
  CnDiffEditorFrm in 'SourceDiff\CnDiffEditorFrm.pas' {CnDiffEditorForm},
  CnSourceDiffFrm in 'SourceDiff\CnSourceDiffFrm.pas' {CnSourceDiffForm},
  CnSourceDiffWizard in 'SourceDiff\CnSourceDiffWizard.pas',
  CnStatFrm in 'SourceStat\CnStatFrm.pas' {CnStatForm},
  CnStatResultFrm in 'SourceStat\CnStatResultFrm.pas' {CnStatResultForm},
  CnStatWizard in 'SourceStat\CnStatWizard.pas',
  CnLineParser in 'Utils\CnLineParser.pas',
  CnPrefixExecuteFrm in 'PrefixWizard\CnPrefixExecuteFrm.pas' {CnPrefixExecuteForm},
  CnPrefixNewFrm in 'PrefixWizard\CnPrefixNewFrm.pas' {CnPrefixNewForm},
  CnPrefixEditFrm in 'PrefixWizard\CnPrefixEditFrm.pas' {CnPrefixEditForm},
  CnPrefixConfigFrm in 'PrefixWizard\CnPrefixConfigFrm.pas' {CnPrefixConfigForm},
  CnPrefixWizard in 'PrefixWizard\CnPrefixWizard.pas',
  CnPrefixList in 'PrefixWizard\CnPrefixList.pas',
  CnPrefixCompFrm in 'PrefixWizard\CnPrefixCompFrm.pas' {CnPrefixCompForm},
  CnNamePropEditor in 'DesignEditors\CnNamePropEditor.pas',
  CnSrcEditorEnhance in 'SrcEditorEnhance\CnSrcEditorEnhance.pas' {CnSrcEditorEnhanceForm},
  CnFormEnhancements in 'IdeEnhancements\CnFormEnhancements.pas' {CnFormEnhanceConfigForm},
  CnFlatToolbarConfigFrm in 'IdeEnhancements\CnFlatToolbarConfigFrm.pas' {CnFlatToolbarConfigForm},
  CnPaletteEnhancements in 'IdeEnhancements\CnPaletteEnhancements.pas',
  CnPaletteEnhanceFrm in 'IdeEnhancements\CnPaletteEnhanceFrm.pas' {CnPalEnhanceForm},
  CnCompFilterFrm in 'IdeEnhancements\CnCompFilterFrm.pas' {CnCompFilterForm},
  CnCorPropWizard in 'CorProperty\CnCorPropWizard.pas',
  CnCorPropFrm in 'CorProperty\CnCorPropFrm.pas' {CnCorPropForm},
  CnCorPropCfgFrm in 'CorProperty\CnCorPropCfgFrm.pas' {CnCorPropCfgForm},
  CnCorPropRulesFrm in 'CorProperty\CnCorPropRulesFrm.pas' {CnCorPropRuleForm},
  CnProjectExtWizard in 'ProjectExtWizard\CnProjectExtWizard.pas',
  CnProjectViewBaseFrm in 'ProjectExtWizard\CnProjectViewBaseFrm.pas' {CnProjectViewBaseForm},
  CnProjectViewUnitsFrm in 'ProjectExtWizard\CnProjectViewUnitsFrm.pas' {CnProjectViewUnitsForm},
  CnProjectViewFormsFrm in 'ProjectExtWizard\CnProjectViewFormsFrm.pas' {CnProjectViewFormsForm},
  CnProjectUseUnitsFrm in 'ProjectExtWizard\CnProjectUseUnitsFrm.pas' {CnProjectViewUnitsForm},
  CnProjectFramesFrm in 'ProjectExtWizard\CnProjectFramesFrm.pas' {CnProjectFramesForm},
  CnProjectListUsedFrm in 'ProjectExtWizard\CnProjectListUsedFrm.pas' {CnProjectListUsedForm},
  CnWizDfmParser in 'Utils\CnWizDfmParser.pas',
  CnCommentCropper in 'SimpleWizards\CnCommentCropper.pas' {CnCommentCropForm},
  CnSourceCropper in 'Utils\CnSourceCropper.pas',
  CnCpuWinEnhancements in 'IdeEnhancements\CnCpuWinEnhancements.pas',
  CnCpuWinEnhanceFrm in 'IdeEnhancements\CnCpuWinEnhanceFrm.pas' {CnCpuWinEnhanceForm},
  CnRepositoryMenu in 'RepositoryWiz\CnRepositoryMenu.pas',
  CnDUnitWizard in 'RepositoryWiz\CnDUnitWizard.pas',
  CnDUnitSetFrm in 'RepositoryWiz\CnDUnitSetFrm.pas' {CnDUnitSetForm},
  CnOTACreators in 'RepositoryWiz\CnOTACreators.pas',
  CnIniFilerWizard in 'RepositoryWiz\CnIniFilerWizard.pas',
  CnIniFilerFrm in 'RepositoryWiz\CnIniFilerFrm.pas' {CnIniFilerForm},
  CnMemProfWizard in 'RepositoryWiz\CnMemProfWizard.pas' {CnMemProfForm},
  CnTestWizard in 'RepositoryWiz\CnTestWizard.pas' {CnTestWizardForm},
  CnWizMethodHook in 'Utils\CnWizMethodHook.pas',
  CnWizIdeDock in 'Utils\CnWizIdeDock.pas' {CnIdeDockForm},
  CnExplore in 'ExplorerWizard\CnExplore.pas' {CnExploreForm},
  CnExploreDirectory in 'ExplorerWizard\CnExploreDirectory.pas' {CnExploreDirctoryForm},
  CnExploreFilter in 'ExplorerWizard\CnExploreFilter.pas' {CnExploreFilterForm},
  CnExploreFilterEditor in 'ExplorerWizard\CnExploreFilterEditor.pas' {CnExploreFilterEditorForm},
  CnProjectDelTempFrm in 'ProjectExtWizard\CnProjectDelTempFrm.pas' {CnProjectDelTempForm},
  CnRoClasses in 'ReopenWizard\CnRoClasses.pas',
  CnRoFrmFileList in 'ReopenWizard\CnRoFrmFileList.pas' {RecentFilesFrame: TFrame},
  CnRoInterfaces in 'ReopenWizard\CnRoInterfaces.pas',
  CnRoWizard in 'ReopenWizard\CnRoWizard.pas',
  CnRoFilesList in 'ReopenWizard\CnRoFilesList.pas' {CnFilesListForm},
  CnRoOptions in 'ReopenWizard\CnRoOptions.pas' {CnRoOptionsDlg},
  CnFilesSnapshot in 'ReopenWizard\CnFilesSnapshot.pas',
  CnFilesSnapshotManageFrm in 'ReopenWizard\CnFilesSnapshotManageFrm.pas' {CnProjectFilesSnapshotManageForm},
  CnWinTopRoller in 'IdeEnhancements\CnWinTopRoller.pas' {CnTopRollerForm},
  CnWizEdtTabSetHook in 'EditorTabSet\CnWizEdtTabSetHook.pas',
  CnWizEdtTabSetFrm in 'EditorTabSet\CnWizEdtTabSetFrm.pas' {CnWizEdtTabSetForm},
  CnInputHelper in 'InputHelper\CnInputHelper.pas',
  CnInputHelperFrm in 'InputHelper\CnInputHelperFrm.pas' {CnInputHelperForm},
  CnInputHelperEditFrm in 'InputHelper\CnInputHelperEditFrm.pas' {CnInputHelperEditForm},
  CnInputSymbolList in 'InputHelper\CnInputSymbolList.pas',
  CnInputIdeSymbolList in 'InputHelper\CnInputIdeSymbolList.pas',
  CnWizIdeHooks in 'Utils\CnWizIdeHooks.pas',
  CnEditControlWrapper in 'Utils\CnEditControlWrapper.pas',
  CnSrcEditorGutter in 'SrcEditorEnhance\CnSrcEditorGutter.pas',
  CnSrcEditorToolBar in 'SrcEditorEnhance\CnSrcEditorToolBar.pas',
  CnProjectBackupFrm in 'ProjectExtWizard\CnProjectBackupFrm.pas' {CnProjectBackupForm},
  CnProjectBackupSaveFrm in 'ProjectExtWizard\CnProjectBackupSaveFrm.pas' {CnProjectBackupSaveForm},
  CnSrcEditorMisc in 'SrcEditorEnhance\CnSrcEditorMisc.pas',
  CnSrcEditorThumbnail in 'SrcEditorEnhance\CnSrcEditorThumbnail.pas',
  CnSrcEditorNav in 'SrcEditorEnhance\CnSrcEditorNav.pas',
  CnSrcEditorBlockTools in 'SrcEditorEnhance\CnSrcEditorBlockTools.pas',
  CnSrcEditorCodeWrap in 'SrcEditorEnhance\CnSrcEditorCodeWrap.pas' {CnSrcEditorCodeWrapForm},
  CnGroupReplace in 'Utils\CnGroupReplace.pas',
  CnSrcEditorReplaceInBlock in 'SrcEditorEnhance\CnSrcEditorReplaceInBlock.pas' {CnSrcEditorReplaceInBlockForm},
  CnSrcEditorGroupReplace in 'SrcEditorEnhance\CnSrcEditorGroupReplace.pas' {CnSrcEditorGroupReplaceForm},
  CnSrcEditorWebSearch in 'SrcEditorEnhance\CnSrcEditorWebSearch.pas' {CnSrcEditorWebSearchForm},
  CnSrcEditorKey in 'SrcEditorEnhance\CnSrcEditorKey.pas',
  CnIdentRenameFrm in 'SrcEditorEnhance\CnIdentRenameFrm.pas' {CnIdentRenameForm},
  CnWizFlatButton in 'Utils\CnWizFlatButton.pas',
  CnSourceHighlight in 'SourceHighlight\CnSourceHighlight.pas',
  CnSourceHighlightFrm in 'SourceHighlight\CnSourceHighlightFrm.pas' {CnSourceHighlightForm},
  CnHighlightLineFrm in 'SourceHighlight\CnHighlightLineFrm.pas' {CnHighlightLineForm},
  CnHighlightSeparateLineFrm in 'SourceHighlight\CnHighlightSeparateLineFrm.pas' {CnHighlightSeparateLineForm},
  CnHighlightCustomIdentFrm in 'SourceHighlight\CnHighlightCustomIdentFrm.pas' {CnHighlightCustomIdentForm},
  CnProcListWizard in 'SimpleWizards\CnProcListWizard.pas' {CnProcListForm},
  CnVerEnhancements in 'IdeEnhancements\CnVerEnhancements.pas',
  CnVerEnhanceFrm in 'IdeEnhancements\CnVerEnhanceFrm.pas' {CnVerEnhanceForm},
  CnDebugEnhancements in 'IdeEnhancements\CnDebugEnhancements.pas' {CnDebugEnhanceForm},
  CnDataSetVisualizer in 'IdeEnhancements\CnDataSetVisualizer.pas' {CnDataSetViewerFrame: TFrame},
  CnStringsVisualizer in 'IdeEnhancements\CnStringsVisualizer.pas' {CnStringsViewerFrame: TFrame},
  CnProjectDirBuilderFrm in 'ProjectExtWizard\CnProjectDirBuilderFrm.pas' {CnProjectDirBuilderForm},
  CnProjectDirImportFrm in 'ProjectExtWizard\CnProjectDirImportFrm.pas' {CnImportDirForm},
  CnDCU32 in 'Utils\CnDCU32.pas',
  CnUsesToolsWizard in 'UsesWizard\CnUsesToolsWizard.pas' {CnUsesCleanerForm},
  CnUsesCleanResultFrm in 'UsesWizard\CnUsesCleanResultFrm.pas' {CnUsesCleanResultForm},
  CnUsesInitTreeFrm in 'UsesWizard\CnUsesInitTreeFrm.pas' {CnUsesInitTreeForm},
  CnUsesIdentFrm in 'UsesWizard\CnUsesIdentFrm.pas' {CnUsesIdentForm},
  CnIdeEnhanceMenu in 'IdeEnhancements\CnIdeEnhanceMenu.pas',
  CnIdeBRWizard in 'SimpleWizards\CnIdeBRWizard.pas',
  CnScriptWizard in 'ScriptWizard\CnScriptWizard.pas' {CnScriptWizardForm},
  CnScriptFrm in 'ScriptWizard\CnScriptFrm.pas' {CnScriptForm},
  CnScriptClasses in 'ScriptWizard\CnScriptClasses.pas',
  CnScriptRegister in 'ScriptWizard\CnScriptRegister.pas',
  CnImageListEditorFrm in 'DesignEditors\CnImageListEditorFrm.pas' {CnImageListEditorForm},
  CnImageListEditor in 'DesignEditors\CnImageListEditor.pas',
  CnImageProviderMgr in 'Utils\CnImageProviderMgr.pas',
  CnImageProvider_IconFinder in 'Utils\CnImageProvider_IconFinder.pas',
  CnImageProvider_FindIcons in 'Utils\CnImageProvider_FindIcons.pas',
  CnImageProvider_LocalCache in 'Utils\CnImageProvider_LocalCache.pas',
  CnFormatterIntf in 'CodeFormatter\CnFormatterIntf.pas',
  CnCodeFormatterWizard in 'CodeFormatter\CnCodeFormatterWizard.pas' {CnCodeFormatterForm};

{$R *.RES}

begin
end.
