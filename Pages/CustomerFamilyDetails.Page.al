page 60709 "Customer Family Details"
{
    PageType = ListPart;
    SourceTable = "Customer Family Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Family Member ID"; Rec."Family Member ID")
                {
                }
                field("Customer Lead ID"; Rec."Customer Lead ID")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Image Path"; Rec."Image Path")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field(Relation; Rec.Relation)
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("State code"; Rec."State code")
                {
                }
                field(Age; Rec.Age)
                {
                }
            }
        }
    }

    actions
    {
    }
}

