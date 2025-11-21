page 60810 "Report E-mail Log"
{
    PageType = List;
    SourceTable = "Report Data for E-Mail";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Report E-mail Log';
    Editable = False;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Report ID"; Rec."Report ID")
                {

                }
                field("Associate Code"; Rec."Associate Code")
                {

                }
                field("Report Batch No."; Rec."Report Batch No.")
                {

                }
                field("Report Name"; Rec."Report Name")
                {

                }
                field("Report Run Date"; Rec."Report Run Date")
                {

                }
                field("Report Run Time"; Rec."Report Run Time")
                {

                }
                field("E-Mail Send"; Rec."E-Mail Send")
                {

                }
                field("Error Message"; Rec."Error Message")
                {

                }

            }
        }
    }

    actions
    {

    }

    var

}

