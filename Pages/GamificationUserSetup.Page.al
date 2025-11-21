page 50287 "Gamification User Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "User Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                }
                field("Gamification Start Date"; Rec."Gamification Start Date")
                {

                    trigger OnValidate()
                    begin
                        AccessControl.RESET;
                        AccessControl.SETRANGE("User Name", USERID);
                        AccessControl.SETRANGE("Role ID", 'GAMIFICATIONDATE');
                        IF NOT AccessControl.FINDFIRST THEN
                            ERROR('Contact Admin');

                        IF Rec."Gamification End Date" <> 0D THEN
                            IF Rec."Gamification Start Date" > Rec."Gamification End Date" THEN
                                ERROR('End Date can not be less than Start Date');
                    end;
                }
                field("Gamification End Date"; Rec."Gamification End Date")
                {

                    trigger OnValidate()
                    begin

                        AccessControl.RESET;
                        AccessControl.SETRANGE("User Name", USERID);
                        AccessControl.SETRANGE("Role ID", 'GAMIFICATIONDATE');
                        IF NOT AccessControl.FINDFIRST THEN
                            ERROR('Contact Admin');
                        IF Rec."Gamification Start Date" <> 0D THEN
                            IF Rec."Gamification Start Date" > Rec."Gamification End Date" THEN
                                ERROR('End Date can not be less than Start Date');
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        AccessControl: Record "Access Control";
}

