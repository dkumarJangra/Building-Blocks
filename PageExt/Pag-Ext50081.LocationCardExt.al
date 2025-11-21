pageextension 50081 "BBG Location Card Ext" extends "Location Card"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("BBG Address 3"; Rec."BBG Address 3")
                {
                    ApplicationArea = All;

                }
                field("BBG Regional Office"; Rec."BBG Regional Office")
                {
                    ApplicationArea = All;

                }
                field("BBG Use As Subcon/Site Location"; Rec."BBG Use As Subcon/Site Location")
                {
                    ApplicationArea = All;

                }
                field("BBG Use As Main Store Location"; Rec."BBG Use As Main Store Location")
                {
                    ApplicationArea = All;

                }
                field("BBG Branch"; Rec."BBG Branch")
                {
                    ApplicationArea = All;

                }
                field("BBG Food Court Location"; Rec."BBG Food Court Location")
                {
                    ApplicationArea = All;

                }

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
        Rec.SETRANGE(Code);// Custom Code
    end;

    trigger OnModifyRecord(): Boolean
    var
        Company: Record Company;
        v_Location: Record Location;
    begin

    end;
}