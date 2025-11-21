page 50480 "Application Aadhaar Attachment"
{
    Caption = 'Application Aadhaar Attachment';
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
            group("Fu&nctions")
            {
                Caption = 'F&unction';
                action("&ImportovatBBG")
                {
                    Caption = 'Import Aadhaar Image';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        OK: Boolean;
                        FileName: TExt[100];
                        BBGSetups: Record "BBG Setups";
                    begin
                        BBGSetups.GET;
                        UserSetup.GET(USERID);
                        UserSetup.TESTFIELD("Import Document");
                        //Rec.Import('', TRUE, FALSE);
                        Clear(FileTransferCU);  // 030325 
                        FileName := FileTransferCU.CallAPI_SendfileDocAttachJagriti();  //030325
                        Rec.Description := FileName;
                        Rec."Import Path" := BBGSetups."Download Doc. Jagriti Path(BC)";//'C:\BBG_DocumentUpload\wwwroot\Uploaded\Doc Attachment\BBG Developers';  //'https://epc.bbgindia.com:44389/Uploaded/Doc Attachment/BBG Developers';
                        Rec.Insert(True);
                        CurrPage.UPDATE(TRUE);
                    end;
                }


                action("&ExportovatBBG")
                {
                    Caption = 'Export Aadhaar Image';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        DocSetups: Record "Document Setup";
                        BBGSetps: Record "BBG Setups";

                    begin
                        // DocSetups.GET;

                        // DocSetups.TestField("Import Path (BC)");
                        BBGSetps.GET;
                        BBGSetps.TestField("Download Doc. Jagriti Path(BC)");
                        Clear(FileTransferCU);  //040325
                        FileTransferCU.ExportFile(Rec, '', BBGSetps."Download Doc. Jagriti Path(BC)");//DocSetups."Import Path (BC)");  //040325

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

