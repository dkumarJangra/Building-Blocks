page 97868 "Document Setup"
{
    InsertAllowed = true;
    PageType = List;
    SourceTable = "Document Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Nos."; Rec."Document Nos.")
                {
                }
                field("Import Path"; Rec."Import Path")
                {
                }
                field("Export Path"; Rec."Export Path")
                {
                    Visible = false;
                }
                field("Audit File Upload Path"; Rec."Audit File Upload Path")
                {
                }
                field("Audit File Upload Path(BC)"; Rec."Audit File Upload Path(BC)")
                {

                }
                field("Import Path (BC)"; Rec."Import Path (BC)")
                {

                }

            }
        }
    }

    actions
    {
    }
}

