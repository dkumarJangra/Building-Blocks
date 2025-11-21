page 60710 "Cutomer Visit Details"
{
    PageType = ListPart;
    SourceTable = "Customer Visit Schedule Detail";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule ID"; Rec."Schedule ID")
                {
                }
                field("Customer Lead ID"; Rec."Customer Lead ID")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Schedule Date"; Rec."Schedule Date")
                {
                }
                field("Visit Status"; Rec."Visit Status")
                {
                }
                field("Visit Type"; Rec."Visit Type")
                {
                }
                field("Visit Date"; Rec."Visit Date")
                {
                }
                field(Comments; Rec.Comments)
                {
                }
                field("Image Path"; Rec."Image Path")
                {
                }
                field("Schedule Time"; Rec."Schedule Time")
                {
                }
                field("Visit Time"; Rec."Visit Time")
                {
                }
                field(Longitude; Rec.Longitude)
                {
                }
                field(Latitude; Rec.Latitude)
                {
                }
                field(visitAddress; Rec.visitAddress)
                {
                }
            }
        }
    }

    actions
    {
    }
}

