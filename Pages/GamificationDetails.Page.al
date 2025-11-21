page 60683 "Gamification Details"
{
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Gamification Details";
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
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Batch Run Time"; Rec."Batch Run Time")
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
                field("Date of Joining"; Rec."Date of Joining")
                {
                }
                field("Latest DOJ of Application"; Rec."Latest DOJ of Application")
                {
                }
                field("Allotment Extent"; Rec."Allotment Extent")
                {
                }
                field("Allotment Collection"; Rec."Allotment Collection")
                {
                }
                field("Registration Extent"; Rec."Registration Extent")
                {
                }
                field("Registration Collection"; Rec."Registration Collection")
                {
                }
                field("Booking Allotment"; Rec."Booking Allotment")
                {
                }
                field("Booking Collection"; Rec."Booking Collection")
                {
                }
                field("Booking Extent"; Rec."Booking Extent")
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

