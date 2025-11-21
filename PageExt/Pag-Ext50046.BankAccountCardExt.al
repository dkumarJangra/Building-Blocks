pageextension 50046 "BBG Bank Account Card Ext" extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Date Modified")
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
            }
            field("Branch Name"; Rec."Branch Name")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
            }
        }
        addafter("Home Page")
        {
            field("Hide Bank Account"; Rec."Hide Bank Account")
            {
                Caption = ' Bank Account Hide';
                ApplicationArea = All;

                trigger OnValidate()
                var
                    AccessControl: Record "Access Control";
                begin
                    AccessControl.RESET;
                    AccessControl.SETRANGE("User Name", USERID);
                    AccessControl.SETRANGE(AccessControl."Role ID", 'BankAccHide');
                    IF NOT AccessControl.FINDFIRST THEN
                        ERROR('Contact Admin');
                end;
            }
        }
        addafter(IBAN)
        {
            field("RTGS/IFSC"; Rec."RTGS/IFSC")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}