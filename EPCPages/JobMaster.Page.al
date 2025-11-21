page 97769 "Job Master"
{
    PageType = Card;
    SourceTable = "Job Master";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Description 3"; Rec."Description 3")
                {
                }
                field("Description 4"; Rec."Description 4")
                {
                }
                field("Seach Name"; Rec."Seach Name")
                {
                }
                field(Category; Rec.Category)
                {
                }
                field("Category Name"; Rec."Category Name")
                {
                }
                field("Sub Category"; Rec."Sub Category")
                {
                }
                field("Sub Category Name"; Rec."Sub Category Name")
                {
                }
                field("Sub Sub Category"; Rec."Sub Sub Category")
                {
                }
                field("Sub Sub Category Name"; Rec."Sub Sub Category Name")
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field("Base UOM"; Rec."Base UOM")
                {
                }
                field("Special Conditions"; Rec."Special Conditions")
                {
                }
                field("Default Cost Center Code"; Rec."Default Cost Center Code")
                {
                }
                field("Default Cost Center Name"; Rec."Default Cost Center Name")
                {
                }
                field("G/L Code"; Rec."G/L Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(General1)
            {
                action(Vendor)
                {
                    RunObject = Page "Product Vendors";
                    RunPageLink = Type = FILTER('Job Master'),
                                  "No." = FIELD(Code);
                }
            }
        }
    }
}

