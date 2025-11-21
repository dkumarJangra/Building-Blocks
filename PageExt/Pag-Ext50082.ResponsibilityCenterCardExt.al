pageextension 50082 "BBG Responsib. Center Card Ext" extends "Responsibility Center Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;

                }
                field("Job Code"; Rec."Job Code")
                {
                    ApplicationArea = All;

                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;

                }
                field(Branch; Rec.Branch)
                {
                    ApplicationArea = All;

                }
                field("Subcon/Site Location"; Rec."Subcon/Site Location")
                {
                    ApplicationArea = All;

                }
                field("Region Name"; Rec."Region Name")
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
        Rec.SETRANGE(Code);
    end;
}