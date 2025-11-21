page 97911 "Bonus Approve"
{
    PageType = Card;
    SourceTable = "Bonus Entry";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Unit No."; Rec."Unit No.")
                {
                }
                field("Installment No."; Rec."Installment No.")
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                }
                field("Bonus %"; Rec."Bonus %")
                {
                }
                field("Bonus Amount"; Rec."Bonus Amount")
                {
                }
                field(Stopped; Rec.Stopped)
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field("Pmt Received From Code"; Rec."Pmt Received From Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Approve")
            {
                Caption = '&Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ReapprovedBonusEntry: Record "Reapproved Bonus Entry";
                begin
                    IF Rec.COUNT = 0 THEN
                        EXIT;
                    IF NOT CONFIRM('Do you want to approve the bonus entries') THEN
                        EXIT;

                    IF Rec.FINDSET THEN
                        REPEAT
                            ReapprovedBonusEntry.INIT;
                            ReapprovedBonusEntry."Entry No." := Rec."Entry No.";
                            ReapprovedBonusEntry."User ID" := USERID;
                            ReapprovedBonusEntry."Posting date" := GetDescription.GetDocomentDate;
                            ReapprovedBonusEntry."Posting Time" := TIME;
                            ReapprovedBonusEntry.INSERT;
                        UNTIL Rec.NEXT = 0;
                    COMMIT;
                    MESSAGE('Done');
                    CurrPage.CLOSE;
                end;
            }
            action("Re&move")
            {
                Caption = 'Re&move';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF CONFIRM('Delete selected records') THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(Rec);
                        Rec.DELETEALL;
                        Rec.RESET;
                    END;
                end;
            }
        }
    }

    var
        EntryNoFilter: Text[1024];
        Text001: Label 'Please enter Voucher No.';
        Text002: Label 'Voucher No. %1 (dated %2) is already valid. It cannot be revalidated.';
        Text003: Label 'The Voucher %1 is already Approved.';
        GetDescription: Codeunit GetDescription;
}

