page 50221 "Non-Display Bank Account List"
{
    PageType = List;
    SourceTable = "Bank Account";
    SourceTableView = WHERE("Hide Bank Account" = CONST(true));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("Hide Bank Account"; Rec."Hide Bank Account")
                {
                    Caption = 'Bank Account Hide';

                    trigger OnValidate()
                    begin
                        AccessControl.RESET;
                        AccessControl.SETRANGE("User Name", USERID);
                        AccessControl.SETRANGE(AccessControl."Role ID", 'BankAccHide');
                        IF NOT AccessControl.FINDFIRST THEN
                            ERROR('Contact Admin');
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        AccessControl: Record "Access Control";
}

