page 50000 "Land Bank"
{
    // ALLEPG 080713 : Created new form.

    AutoSplitKey = false;
    DelayedInsert = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Land Book";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field(Select; Rec.Select)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Posting Type"; Rec."Posting Type")
                {
                }
                field(Mode; Rec.Mode)
                {
                }
                field("Release/ReOpen"; Rec."Release/ReOpen")
                {
                }
                field("Bank Code"; Rec."Bank Code")
                {
                }
                field(Towards; Rec.Towards)
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Cheque Cleared"; Rec."Cheque Cleared")
                {
                }
                field("Cheque Cleared Date"; Rec."Cheque Cleared Date")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Registered Value"; Rec."Registered Value")
                {
                }
                field(Registered; Rec.Registered)
                {
                }
                field("Registration No."; Rec."Registration No.")
                {
                }
                field("Registration Date"; Rec."Registration Date")
                {
                }
                field("Registration Office"; Rec."Registration Office")
                {
                }
                field("Registration in Favour of"; Rec."Registration in Favour of")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Reference By"; Rec."Reference By")
                {
                }
                field("Contact No."; Rec."Contact No.")
                {
                }
                field("Applied With"; Rec."Applied With")
                {
                }
                field("Estimated Value"; Rec."Estimated Value")
                {
                }
                field(Remark; Rec.Remark)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        LandBook.RESET;
                        LandBook.SETRANGE(Select, TRUE);
                        IF LandBook.FINDSET THEN
                            REPEAT
                                LandBook."Release/ReOpen" := LandBook."Release/ReOpen"::Release;
                                LandBook.MODIFY;
                            UNTIL LandBook.NEXT = 0;
                    end;
                }
                action(ReOpen)
                {
                    Caption = 'ReOpen';

                    trigger OnAction()
                    begin
                        CLEAR(LandBook);
                        LandBook.RESET;
                        LandBook.SETRANGE("Entry No.", Rec."Entry No.");
                        IF LandBook.FINDFIRST THEN BEGIN
                            LandBook."Release/ReOpen" := LandBook."Release/ReOpen"::Open;
                            LandBook.MODIFY;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        LandBook.RESET;
        LandBook.SETRANGE("Release/ReOpen", LandBook."Release/ReOpen"::Open);
        IF LandBook.FINDFIRST THEN
            ERROR('Please release or Delete the Entry No. -' + FORMAT(LandBook."Entry No."));
    end;

    var
        LandBook: Record "Land Book";
}

