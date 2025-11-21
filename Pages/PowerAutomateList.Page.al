page 50301 "Power Automat List"
{

    PageType = List;
    SourceTable = "Power Automat Path Details";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Folder Name"; Rec."Folder Name")
                {
                }
                field("Path"; Rec."Path")
                {
                }

            }
        }
    }

    actions
    {

    }

    var

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        If UserId <> 'BCUSER' then
            Error('Please contact Admin');
    end;


}

