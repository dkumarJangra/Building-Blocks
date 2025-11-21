page 60722 "Land Document Attachment"
{
    AutoSplitKey = true;
    Caption = 'Documents';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Land Document Attachment";
    SourceTableView = SORTING("Document Type", "No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Document));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Attachment Type"; Rec."Attachment Type")
                {
                }
                field(Applicable; Rec.Applicable)
                {
                }
                field("Import Path"; Rec."Import Path")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("File Extension"; Rec."File Extension")
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Document Import Date"; Rec."Document Import Date")
                {
                }
                field("Document Import By"; Rec."Document Import By")
                {
                }
                field("Document Import Time"; Rec."Document Import Time")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Dokument")
            {
                Caption = '&Document';
                action("&Zobrazit")
                {
                    Caption = 'View';
                    Image = View;
                    ShortCutKey = 'Shift+Ctrl+V';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.View(DocMgt);
                    end;
                }
                action("U&pravit")
                {
                    Caption = 'Edit';
                    Image = Edit;
                    ShortCutKey = 'Shift+Ctrl+E';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.Edit(DocMgt);
                    end;
                }
            }
        }
        area(processing)
        {
            group("Fu&nkce")
            {
                Caption = 'F&unction';
                action("&Importovat")
                {
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        OK: Boolean;
                        DocSetup: Record "Document Setup";
                        FileTransferCu: codeunit "File Transfer";
                    begin
                        UserSetup.GET(USERID);
                        UserSetup.TESTFIELD("Import Document");
                        DocSetup.GET;
                        DocSetup.TestField("Audit File Upload Path(BC)");
                        Clear(FileTransferCu);
                        FileTransferCu.CallAPI_SendfileAuditFiles();

                        //Rec.Import('', TRUE);
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                action("Exportovat")
                {
                    Caption = 'Export';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        OK: Boolean;
                        DocSetup: Record "Document Setup";
                        FileTransferCu: Codeunit "File Transfer";
                    begin
                        //Rec.Export('', TRUE, TRUE);
                        //040325 Code added Start
                        DocSetup.GET;
                        DocSetup.TestField("Audit File Upload Path(BC)");
                        Clear(FileTransferCu);
                        FileTransferCu.ExportFileLandProject(Rec, '', DocSetup."Audit File Upload Path(BC)");
                        //040325 Code added End
                    end;
                }
                action("&Vytvo²it kopii")
                {
                    Caption = 'Copy';
                    Image = Copy;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.Clone();
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                action("Importovat")
                {
                    Caption = 'Import Project Doc';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        OK: Boolean;
                    begin
                        UserSetup.GET(USERID);
                        UserSetup.TESTFIELD("Import Document");
                        Rec.ImportProjectDoc('', TRUE);
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                action("&Exportovat")
                {
                    Caption = 'Export Project Doc';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        OK: Boolean;
                        FileTransferCu: Codeunit "File transfer";
                        DocSetup: Record "Document Setup";
                    begin
                        //Rec.ExportProjectDoc('', TRUE);
                        //040325 Code added Start
                        DocSetup.GET;
                        DocSetup.TestField("Audit File Upload Path(BC)");
                        Clear(FileTransferCu);
                        FileTransferCu.ExportFileLandProject(Rec, '', DocSetup."Audit File Upload Path(BC)");
                        //040325 Code added END
                    end;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        EXIT(NOT Rec.IsInUse(TRUE));
    end;

    trigger OnModifyRecord(): Boolean
    begin
        EXIT(NOT Rec.IsInUse(TRUE));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        EXIT(DocMgt.Finish(FALSE));
    end;

    var
        DocMgt: Report "Land Document Management";
        DocAccMgt: Report "Land Doc Access Management";
        UserSetup: Record "User Setup";

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CurrPage.EDITABLE := Rec."In Use By" = '';
    end;

    local procedure OnTimer()
    begin
        IF DocMgt.Finish(TRUE) THEN
            DocMgt.Finish(FALSE);
    end;
}

