page 50298 "Team Target Details"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Team / Leader Target Details";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                    OptionCaption = ' ,Team,Leader,Rank';
                }
                field("Rank Code"; Rec."Rank Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Code; Rec.Code)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = all;

                }
                field("Field Type"; Rec."Field Type")
                {
                    ApplicationArea = all;
                }
                field("Target Value"; Rec."Target Value")
                {
                    ApplicationArea = all;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                }
                field("Last Modify By"; Rec."Last Modify By")
                {
                    ApplicationArea = all;
                }
                field("Last Modify DateTime"; Rec."Last Modify DateTime")
                {
                    ApplicationArea = all;
                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        // area(Processing)
        // {
        //     action(ActionName)
        //     {

        //         trigger OnAction()
        //         begin

        //         end;
        //     }
        // }
    }
    var
        RankCode: Record "Rank Code";

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Rank;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Rank;
    end;
}