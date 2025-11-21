page 50099 "Associate Report details"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = Vendor;
    SourceTableView = WHERE("No." = FILTER('IBA*'));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("Report 50011 Run for Associate"; Rec."BBG Report 50011 Run for Associate")
                {
                    Caption = 'Commission Eleg. 50011';
                }
                field("Report 50041 Run for Associate"; Rec."BBG Report 50041 Run for Associate")
                {
                    Caption = 'Team CollectionDetail 50041';
                }
                field("Report 50082 Run for Associate"; Rec."BBG Report 50082 Run for Associate")
                {
                    Caption = 'Commission Eligibility 50082';
                }
                field("Report 57782 Run for Associate"; Rec."BBG Report 57782 Run for Associate")
                {
                    Caption = 'Associate Drawing 97782';
                }
                field("Report 50096 Run for Associate"; Rec."BBG Report 50096 Run for Associate")
                {
                    Caption = 'Booking/Allotment/TA50096';
                }
            }
        }
    }

    actions
    {
    }
}

