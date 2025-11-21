page 97925 "Commission Structure"
{
    // //AD BBG1.00/ 110213: CAPTION STARTING DATE CHANGED TO EFFECTIVE DATE
    Caption = 'Commission Structure List';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Commission Structure";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Commission Type"; Rec."Commission Type")
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field("Rank Description"; Rec."Rank Description")
                {
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Effective Date';
                }
                field("Investment Type"; Rec."Investment Type")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field("TDS Applicable"; Rec."TDS Applicable")
                {
                }
                field("Year Code"; Rec."Year Code")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                    Editable = false;
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action("Re-Open")
                {
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Setups Creation", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');
                        Commstructure.RESET;
                        Commstructure.SETRANGE(Status, Commstructure.Status::Release);
                        IF Commstructure.FINDSET THEN
                            REPEAT
                                Commstructure.Status := Commstructure.Status::Open;
                                Commstructure.MODIFY;
                            UNTIL Commstructure.NEXT = 0;
                    end;
                }
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Setups Approval", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');
                        Commstructure.RESET;
                        Commstructure.SETRANGE(Status, Commstructure.Status::Open);
                        IF Commstructure.FINDSET THEN
                            REPEAT
                                Commstructure.Status := Commstructure.Status::Release;
                                Commstructure.MODIFY;
                            UNTIL Commstructure.NEXT = 0;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        UserSetup: Record "User Setup";
        Commstructure: Record "Commission Structure";
}

