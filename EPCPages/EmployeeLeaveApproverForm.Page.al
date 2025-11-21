page 97852 "Employee Leave Approver Form"
{
    PageType = ListPart;
    SourceTable = "Dimension Value";
    SourceTableView = WHERE("Dimension Code" = FILTER('REGION'),
                            "Dimension Value Type" = FILTER(Standard));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    Visible = false;
                }
                field("Dimension Value Type"; Rec."Dimension Value Type")
                {
                    Visible = false;
                }
                field(Code; Rec.Code)
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("Leave Approver"; Rec."Leave Approver")
                {

                    trigger OnValidate()
                    begin
                        Memberof.RESET;
                        Memberof.SETRANGE("User Name", USERID);
                        Memberof.SETFILTER("Role ID", 'LEAVEAPP');
                        IF NOT Memberof.FINDFIRST THEN BEGIN
                            ERROR('You are not Authorised to perform this action');
                        END;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        Memberof: Record "Access Control";
}

