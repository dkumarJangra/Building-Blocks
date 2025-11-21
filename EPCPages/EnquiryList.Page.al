page 97883 "Enquiry List"
{
    PageType = Card;
    SourceTable = "Vendor Enquiry Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Indent No."; Rec."Indent No.")
                {
                    Caption = 'PR No.';
                }
                field("Enquiry no."; Rec."Enquiry no.")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Job Code"; Rec."Job Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Expected Date of Offer"; Rec."Expected Date of Offer")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Enquiry")
            {
                Caption = '&Enquiry';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "User Resp center Setup";
                    //RunPageLink = "Enquiry no."  = FIELD("Enquiry no.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }
}

