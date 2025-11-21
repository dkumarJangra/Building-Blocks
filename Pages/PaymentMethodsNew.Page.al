page 50006 "Payment Methods New"
{
    Caption = 'Payment Methods';
    Editable = false;
    PageType = Card;
    SourceTable = "Payment Method";
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
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
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
                action("&Release")
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        CurrPage.EDITABLE(FALSE);
                        CurrPage.UPDATE;
                    end;
                }
                action("Re&Open")
                {
                    Caption = 'Re&Open';

                    trigger OnAction()
                    begin
                        CurrPage.EDITABLE(TRUE);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }
}

