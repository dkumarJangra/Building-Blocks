page 50264 "Customer Address Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Customer Address Details";
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
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Customer ID"; Rec."Customer ID")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Customer Address"; Rec."Customer Address")
                {
                }
                field("Customer Address 2"; Rec."Customer Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                }
                field(Sex; Rec.Sex)
                {
                }
                field("Father's/Husband's Name"; Rec."Father's/Husband's Name")
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field("Aadhar No."; Rec."Aadhar No.")
                {
                }
                field(State; Rec.State)
                {
                }
            }
        }
    }

    actions
    {
    }
}

