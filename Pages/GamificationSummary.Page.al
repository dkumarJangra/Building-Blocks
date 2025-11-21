page 60680 "Gamification Summary"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Gamification Details";
    SourceTableView = WHERE("Show Records" = CONST(true));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Date"; Rec."Document Date")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Team Name"; Rec."Team Name")
                {
                }
                field("No. of Records"; Rec."No. of Records")
                {
                }
                field(Sankalp; Rec.Sankalp)
                {
                }
                field(Mahasankalp; Rec.Mahasankalp)
                {
                }
                field("Total Values"; Rec."Total Values")
                {
                }
                field("Show Records"; Rec."Show Records")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field(Rank; Rec.Rank)
                {
                }
                field(Batch; Rec.Batch)
                {
                }
                field(Points; Rec.Points)
                {
                }
                field("Rate per Point"; Rec."Rate per Point")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Insert Data (Individual)")
            {
                Image = process;
                Promoted = true;
                RunObject = Report "Gamification Details Batch";
            }
            action("Insert Data (Team)")
            {
                Image = process;
                Promoted = true;
                RunObject = Report "Gamification Team Detail Batch";
            }
        }
    }
}

