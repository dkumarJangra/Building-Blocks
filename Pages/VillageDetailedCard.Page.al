page 50463 "Village Details Card"
{
    Caption = 'Village Details Card';
    PageType = Card;
    SourceTable = "Village Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    InsertAllowed = True;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {

                }

                field("State Code"; Rec."State Code")
                {

                }
                field("State Name"; Rec."State Name")
                {

                }
                field("District Code"; Rec."District Code")
                {

                }
                Field("Mandal Code"; Rec."Mandal Code")
                {

                }
            }
        }
    }

    actions
    {
        //     action("Process Open")
        //     {

        //         trigger OnAction()
        //         begin
        //             Rec."Open Stage" := '';
        //             UpdateOpenStatus;
        //             //UpdateDays;
        //             Rec.MODIFY;
        //         end;
        //     }
        // }
    }

}

