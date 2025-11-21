page 97922 "Change Rank History"
{
    Editable = false;
    PageType = List;
    SourceTable = "Rank Change History";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                }
                field(MMCode; Rec.MMCode)
                {
                }
                field("Authorised Person"; Rec."Authorised Person")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Old Parent Code"; Rec."Old Parent Code")
                {
                }
                field("Parent Rank Old"; Rec."Parent Rank Old")
                {
                }
                field("New Parent Code"; Rec."New Parent Code")
                {
                }
                field("Parent Rank New"; Rec."Parent Rank New")
                {
                }
                field("Authorisation Date"; Rec."Authorisation Date")
                {
                }
                field("Previous Rank"; Rec."Previous Rank")
                {
                }
                field("New Rank"; Rec."New Rank")
                {
                }
                field(Inactive; Rec.Inactive)
                {
                }
                field(Suspended; Rec.Suspended)
                {
                }
                field("Suspended From Date"; Rec."Suspended From Date")
                {
                }
                field("Suspend Removal Date"; Rec."Suspend Removal Date")
                {
                }
                field("Hold Payables"; Rec."Hold Payables")
                {
                }
                field("Unhold Payables"; Rec."Unhold Payables")
                {
                }
                field("USER ID"; Rec."USER ID")
                {
                }
                field("Modification Date"; Rec."Modification Date")
                {
                }
                field("Modification Time"; Rec."Modification Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

