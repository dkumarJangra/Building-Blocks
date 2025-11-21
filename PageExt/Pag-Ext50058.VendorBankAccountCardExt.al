pageextension 50058 "BBG Vendor Bank Acc. Card Ext" extends "Vendor Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        modify(Name)
        {
            Caption = 'Bank Name';
        }
        modify("Bank Branch No.")
        {
            Caption = 'IFSC Code/ Bank Branch No.';
        }
        modify("Bank Account No.")
        {
            ShowMandatory = TRUE;
        }
        addafter("Transit No.")
        {
            field(Default; Rec.Default)
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

    trigger OnAfterGetRecord()
    begin
        Rec.SETRANGE(Code);
    end;
}