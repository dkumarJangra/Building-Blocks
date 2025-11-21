page 60711 "Report Request Web/Mb List"
{
    PageType = List;
    SourceTable = "Report Request from Web/Mb.";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Report Id"; Rec."Report Id")
                {
                }
                field("Report Name"; Rec."Report Name")
                {
                }
                field("Report Request Date"; Rec."Report Request Date")
                {
                }
                field("Report Request Time"; Rec."Report Request Time")
                {
                }
                field("Report Send"; Rec."Report Send")
                {
                }
                field("Report Sending Date"; Rec."Report Sending Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Report Generated"; Rec."Report Generated")
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
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
}

