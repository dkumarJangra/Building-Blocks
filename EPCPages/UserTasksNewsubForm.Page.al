page 97784 "User Tasks New sub Form"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "User Tasks New";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Initiator; Rec.Initiator)
                {
                }
                field("Approvar ID"; Rec."Approvar ID")
                {
                }
                field("Alternate Approvar ID"; Rec."Alternate Approvar ID")
                {
                }
                field("Sent Date"; Rec."Sent Date")
                {
                }
                field("Sent Time"; Rec."Sent Time")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Activity; Rec.Activity)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Received From"; Rec."Received From")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Authorised Date"; Rec."Authorised Date")
                {
                }
                field("Authorised Time"; Rec."Authorised Time")
                {
                }
                field("Approval Remarks"; Rec."Approval Remarks")
                {
                }
                field("Initiator Remarks"; Rec."Initiator Remarks")
                {
                }
            }
        }
    }

    actions
    {
    }
}

