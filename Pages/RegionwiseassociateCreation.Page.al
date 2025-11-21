page 50230 "Region/Districts default Rank"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Region/Districts Rank Entry";
    Caption = 'Region/Districts default Rank';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Region_Districts Code"; Rec."Region_Districts Code")
                {
                    ApplicationArea = all;
                }

                field("State Code"; Rec."State Code")
                {
                    ApplicationArea = all;
                }
                field("Region/Rank Code"; Rec."Region/Rank Code")
                {
                    ApplicationArea = all;
                }
                field("State Name"; Rec."State Name")
                {
                    ApplicationArea = all;
                }
                field(Rank; Rec.Rank)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;

                }


            }
        }

    }

    actions
    {
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        If (UserId <> 'BCUSER') AND (UserId <> 'NAVUSER4') then
            Error('Not Authorised');

    end;
}