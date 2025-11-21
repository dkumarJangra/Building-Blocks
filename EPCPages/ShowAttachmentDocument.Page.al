page 60726 "Show Attachment Document"
{
    Caption = 'Documents';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Document;
    SourceTableView = SORTING("Document Type", "No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Document));
    //UsageCategory = Lists;
    ApplicationArea = All;

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
                    Visible = false;

                    trigger OnAction()
                    var
                        OK: Boolean;
                    begin
                        UserSetup.GET(USERID);
                        UserSetup.TESTFIELD("Import Document");
                        Rec.Import('', TRUE, TRUE);
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                action("&Exportovat")
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
                        FileTransferCu: codeunit "File Transfer";
                    begin
                        //Rec.Export('', TRUE, TRUE);
                        //040325 Code added Start
                        DocSetup.GET;
                        DocSetup.TestField("Audit File Upload Path(BC)");
                        Clear(FileTransferCu);
                        FileTransferCu.ExportFile(Rec, '', DocSetup."Audit File Upload Path(BC)");
                        //040325 Code added End
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
        DocMgt: Report "Document Management";
        DocAccMgt: Report "Document Access Management";
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

