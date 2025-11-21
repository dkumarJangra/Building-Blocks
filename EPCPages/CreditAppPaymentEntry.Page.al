page 97834 "Credit App. Payment Entry"
{
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Debit App. Payment Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Visible = false;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    OptionCaption = ' ,,,,,,,,,Debit Note';
                    Visible = true;
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Caption = 'Associate Code';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Payment Mode", Rec."Payment Mode"::"Debit Note");
                    end;
                }
                field("Introducer Name"; Rec."Introducer Name")
                {
                    Caption = 'Associate Name';
                    Editable = false;
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    Caption = 'Comm. Base Amt.';
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field("Commission Adj. Amount"; Rec."Commission Adj. Amount")
                {
                    Caption = 'Commission Adj. Amount';
                    Editable = false;
                }
                field("Principal Adj. Amount"; Rec."Principal Adj. Amount")
                {
                }
                field("Net Payable Amt"; Rec."Net Payable Amt")
                {
                    Caption = 'Total Debit Amt on Ass. / BBG';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

