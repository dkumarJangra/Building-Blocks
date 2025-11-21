page 50119 "User Document Attachment"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "User Document Attachment";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field(USER_ID; Rec.USER_ID)
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document Attachment Path"; Rec."Document Attachment Path")
                {
                }
                field("Old Document Attach Path"; Rec."Old Document Attach Path")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Document Attachment Date"; Rec."Document Attachment Date")
                {
                }
                field("Document Attachment Time"; Rec."Document Attachment Time")
                {
                }
                field("Document Verified"; Rec."Document Verified")
                {
                }
                field("Document Verified By"; Rec."Document Verified By")
                {
                }
                field("Document Verified Date"; Rec."Document Verified Date")
                {
                }
                field("Document Verified Time"; Rec."Document Verified Time")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Document_Verify)
            {
                Caption = 'Document Verify';

                trigger OnAction()
                begin
                    Rec."Document Verified" := TRUE;
                    Rec."Document Verified By" := USERID;
                    Rec."Document Verified Date" := TODAY;
                    Rec."Document Verified Time" := TIME;
                    Rec.MODIFY;
                end;
            }
            action("Document_Un-Verify")
            {
                Caption = 'Document Un-Verify';

                trigger OnAction()
                begin
                    Rec."Document Verified" := FALSE;
                    Rec."Document Verified By" := USERID;
                    Rec."Document Verified Date" := TODAY;
                    Rec."Document Verified Time" := TIME;
                    Rec.MODIFY;
                end;
            }
            action(OpenDocument)
            {
                Caption = 'Show Document';
                Image = showdocument;

                trigger OnAction()
                var
                    UnitSetup: Record "Unit Setup";
                    BBGSetups: Record "BBG Setups";
                    FileTransferCu: Codeunit "File Transfer";
                    FileName: Text[200];
                    FilePath: Text[200];
                    LastPos: integer;
                    CustSMSText: Text;
                    I: Integer;
                begin
                    UnitSetup.GET;
                    UnitSetup.TESTFIELD(UnitSetup."Associate Document Path");
                    BBGSetups.GET;  //ALLE 230823  Added
                    BBGSetups.TESTFIELD("New Associate Doc Attach Path");
                    Clear(FileTransferCu);
                    FilePath := '';
                    FileName := '';
                    FilePath := BBGSetups."New Associate Doc Attach Path" + Rec."Document Attachment Path";

                    LastPos := 0;
                    CustSMSText := Rec."Document Attachment Path";

                    FOR I := 1 TO 3 DO BEGIN
                        CustSMSText := COPYSTR(CustSMSText, LastPos + 1, 250);
                        LastPos := STRPOS(CustSMSText, '/');

                        FileName := COPYSTR(CustSMSText, LastPos + 1, 100);
                    END;

                    FileTransferCu.ExportFileOthers(FilePath, '', FileName);

                    //ALLE 230823  Added
                    //IF "Old Document Attach Path" <> '' THEN   //ALLE 250823 Code Commented
                    //  HYPERLINK("Old Document Attach Path")   //ALLE 250823 Code Commented
                    //ELSE BEGIN    //ALLE 250823 Code Commented

                    // IF FILE.EXISTS(UnitSetup."Associate Document Path" + Rec."Document Attachment Path") THEN     //ALLE 230823  Added
                    //     HYPERLINK(UnitSetup."Associate Document Path" + Rec."Document Attachment Path")
                    // ELSE
                    //     HYPERLINK(BBGSetups."New Associate Doc Attach Path" + Rec."Document Attachment Path");
                    //END;   //ALLE 250823 Code Commented
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow Mobile App", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;
}

