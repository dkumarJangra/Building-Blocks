page 50200 "Associate Hierarcy with App."
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Associate Hierarcy with App.";
    SourceTableView = WHERE(Status = CONST(Active));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application Code"; Rec."Application Code")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field("Rank Description"; Rec."Rank Description")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Region/Rank Code"; Rec."Region/Rank Code")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Application DOJ"; Rec."Application DOJ")
                {
                }
                field("Team Code"; Rec."Team Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

