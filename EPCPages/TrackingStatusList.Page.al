page 97766 "Tracking Status List"
{
    Caption = 'Tracking Status';
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Document Tracking status";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Update Versions"; Rec."Update Versions")
                {
                }
                field("Generate Transmittal Nos"; Rec."Generate Transmittal Nos")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            OKOnPush;
    end;

    var
        NewDocTrack: Record "New Document Tracking";
        TableID: Integer;
        DocType: Option ,Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        DocNo: Code[20];
        LineNo: Integer;
        DocCode1: Code[20];
        Job: Record Job;
        EntryNo: Integer;


    procedure SetDocTrack(TabID: Integer; DocType: Option ,Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; "DocNo.": Code[20]; "LineNo.": Integer; DocCode: Code[20])
    begin
        TableID := TabID;
        DocType := DocType;
        DocNo := "DocNo.";
        LineNo := "LineNo.";
        DocCode1 := DocCode;
    end;

    local procedure OKOnPush()
    begin
        IF NewDocTrack.GET(TableID, DocType, DocNo, LineNo, DocCode1) THEN BEGIN
            BEGIN
                EntryNo := NewDocTrack.CreateLog();
                NewDocTrack.Status := Rec.Code;
                NewDocTrack.MODIFY;
                NewDocTrack.ModifyLog(EntryNo);
            END;
        END;
    end;
}

