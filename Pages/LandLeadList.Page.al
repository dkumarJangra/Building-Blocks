page 60666 "Land Lead List"
{
    CardPageID = "Land Lead Card";
    PageType = List;
    SourceTable = "Land Lead/Opp Header";
    SourceTableView = WHERE("Document Type" = CONST(Lead));
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
                field("Opportunity Document No."; Rec."Opportunity Document No.")
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
                field("Village Name"; Rec."Village Name")
                {
                }
                field("Mandalam Name"; Rec."Mandalam Name")
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::Lead;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::Lead;
    end;
}

