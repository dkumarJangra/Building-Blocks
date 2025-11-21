page 50524 "General Journal Narration"
{

    PageType = List;
    SourceTable = "Gen. Journal Narration";
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = TableData "Gen. Journal Narration" = rimd;

    Caption = 'BBG General Journal Narration';

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Gen. Journal Line No."; Rec."Gen. Journal Line No.")
                {
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {

        }
    }
}

