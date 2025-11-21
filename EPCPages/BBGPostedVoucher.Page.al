page 98050 "BBG Posted Narration"
{
    Caption = 'BBG Posted Narration';

    PageType = List;
    SourceTable = "Posted Narration";
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = tabledata "Posted Narration" = rm;

    layout
    {
        area(content)
        {
            repeater(Group)
            {


                field("Document Type"; Rec."Document Type")
                {
                    Editable = False;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Narration"; Rec."Narration")
                {
                }

            }
        }
    }

    actions
    {
    }
    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
        USERSetup: Record "User Setup";
    begin

        USERSetup.RESET;
        USERSetup.GET(UserId);
        USERSetup.TestField("Modify Posted Narration");

    end;
}

