page 50418 "Project Price Attachment List"
{
    Caption = 'Project Price Attachment List';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Document;
    SourceTableView = SORTING("Document Type", "No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Document));
    //UsageCategory = Lists;
    DeleteAllowed = False;
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
                action("&Importother")
                {
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        OK: Boolean;
                        FileName: TExt[100];
                    begin
                        UserSetup.GET(USERID);
                        UserSetup.TESTFIELD("Import Document");
                        //Rec.Import('', TRUE, FALSE);
                        Clear(FileTransferCU);  // 030325 
                        FileName := FileTransferCU.CallAPI_SendfileDocAttachment();  //030325
                        Rec.Description := FileName;
                        Rec.Insert(True);
                        CurrPage.UPDATE(TRUE);
                    end;
                }

                action("&Exportother")
                {
                    Caption = 'Export';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        DocSetups: Record "Document Setup";

                    begin
                        DocSetups.GET;
                        DocSetups.TestField("Import Path (BC)");
                        Clear(FileTransferCU);  //040325
                        FileTransferCU.ExportFile(Rec, '', DocSetups."Import Path (BC)");  //040325

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
        FileTransferCU: Codeunit "File Transfer";

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

