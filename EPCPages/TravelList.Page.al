page 97995 "Travel List"
{
    CardPageID = "Travel Generation 1";
    Editable = false;
    PageType = List;
    SourceTable = "Travel Header";
    SourceTableView = WHERE("Sent for Approval" = CONST(false));
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
                field("Team Lead"; Rec."Team Lead")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("ARM TA Code"; Rec."ARM TA Code")
                {
                }
                field(dimTACode; Rec.dimTACode)
                {
                    Caption = 'For Old TA Code';
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

