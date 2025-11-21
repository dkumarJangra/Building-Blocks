page 50454 "Mandal Details List"
{
    PageType = List;
    SourceTable = "Mandal Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Mandal Details List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }

                field("State Code"; Rec."State Code")
                {

                }
                field("State Name"; Rec."State Name")
                {
                    Editable = false;
                }
                field("District Code"; Rec."District Code")
                {

                }

            }
        }
    }

    // actions
    // {
    //     area(processing)
    //     {
    //         action("Insert Data")
    //         {
    //             RunObject = Report "Yearly De-Activate Vendor";
    //         }
    //     }
    // }

    var

}

