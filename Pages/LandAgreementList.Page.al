page 50155 "Land Agreement List"
{
    CardPageID = "Land Agreement";
    PageType = List;
    SourceTable = "Land Agreement Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creation Time"; Rec."Creation Time")
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
                field("Post Code"; Rec."Post Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("Sale Deed No."; Rec."Sale Deed No.")
                {
                }
                field("Date of Registration"; Rec."Date of Registration")
                {
                }
                field("Area"; Rec.Area)
                {
                }
                field("Total Value"; Rec."Total Value")
                {
                }
            }
        }
    }

    actions
    {
    }
}

