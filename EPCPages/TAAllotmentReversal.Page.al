page 50053 "TA Allotment / Reversal"
{
    Editable = false;
    PageType = List;
    SourceTable = "TA Application wise Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Introducer Name"; Rec."Introducer Name")
                {
                }
                field("Associate UpLine Code"; Rec."Associate UpLine Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Gross TA Rate"; Rec."Gross TA Rate")
                {
                }
                field("TA Rate"; Rec."TA Rate")
                {
                }
                field("TA Generation Date"; Rec."TA Generation Date")
                {
                }
                field("TA Amount"; Rec."TA Amount")
                {
                }
                field("TA Reverse"; Rec."TA Reverse")
                {
                }
                field("TA Detail Line No."; Rec."TA Detail Line No.")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
            }
        }
    }

    actions
    {
    }
}

