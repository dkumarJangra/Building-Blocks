page 50072 "Region/Rank  List"
{
    CardPageID = "Region/Rank Master";
    Editable = false;
    PageType = List;
    SourceTable = "Rank Code Master";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Use for CP only"; Rec."Use for CP only")
                {

                }
                field("Applicable New commission Str."; Rec."Applicable New commission Str.")
                {
                    Caption = 'Applicable New comm. Str. Amount Base';
                }
                field("Min Days"; Rec."Min Days")
                {
                }
                field("Max Days"; Rec."Max Days")
                {
                }
                field("Min. Amount"; Rec."Min. Amount")
                {
                }
                field(Extent; Rec.Extent)
                {
                }
                field("Max Amount"; Rec."Max Amount")
                {
                }
                field("No of Days"; Rec."No of Days")
                {
                }
            }
        }
    }

    actions
    {
    }
}

