page 50456 "District Details List"
{
    PageType = List;
    SourceTable = "District Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'District Details List';

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

