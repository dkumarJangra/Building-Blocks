page 97882 "Enquiry Subform"
{
    // AlleDK 090610 Show Job no and Job Task No.
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Enquiry Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Description2; Rec.Description2)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit cost"; Rec."Unit cost")
                {
                    Editable = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Inspection by"; Rec."Inspection by")
                {
                }
                field(Source; Rec.Source)
                {
                }
                field("Uint of Measure"; Rec."Uint of Measure")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = true;
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = false;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

