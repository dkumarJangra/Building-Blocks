page 97828 "Assocaite Web Staging Form"
{
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData "Associate Eligibility Staging" = rm;
    SourceTable = "Associate Eligibility Staging";
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
                field("Batch Code"; Rec."Batch Code")
                {
                }
                field("Batch Date"; Rec."Batch Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Associate P.A.N No."; Rec."Associate P.A.N No.")
                {
                }
                field("Publish Data"; Rec."Publish Data")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Mob. No."; Rec."Mob. No.")
                {
                }
                field("Error Message"; Rec."Error Message")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field("Date of Joining"; Rec."Date of Joining")
                {
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Error Message")
            {
                Caption = 'Update Error Message';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AssociateEligibilityStaging.RESET;
                    AssociateEligibilityStaging.SETFILTER("Batch Date", '<>%1', 0D);
                    IF AssociateEligibilityStaging.FINDLAST THEN BEGIN
                        AssElgStaging.RESET;
                        AssElgStaging.SETRANGE("Batch Date", AssociateEligibilityStaging."Batch Date");
                        AssElgStaging.SETFILTER("Error Message", '<>%1', '');
                        IF AssElgStaging.FINDSET THEN BEGIN
                            REPEAT
                                AssElgStaging."Error Message" := '';
                                AssElgStaging.MODIFY;
                            UNTIL AssElgStaging.NEXT = 0;
                        END;
                    END;
                end;
            }
            action("Push Data on Web")
            {
                Caption = 'Push Data on Web';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AssociateEligibilityStaging: Record "Associate Eligibility Staging";
                    OldAssociateEligibilityonWeb: Record "Associate Eligibility on Web";
                begin
                    //CLEAR(AssociateWebDataPush_1);
                    //AssociateWebDataPush_1.RUN;

                    AssociateEligibilityStaging.RESET;
                    AssociateEligibilityStaging.SETFILTER("Entry No.", '>%1', 4659718);
                    AssociateEligibilityStaging.SETRANGE("Publish Data", FALSE);
                    AssociateEligibilityStaging.SETFILTER(Amount, '<>%1', 0);
                    IF AssociateEligibilityStaging.FINDSET THEN
                        REPEAT
                            OldAssociateEligibilityonWeb.RESET;
                            IF OldAssociateEligibilityonWeb.FINDLAST THEN;
                            AssociateEligibilityonWeb.RESET;
                            AssociateEligibilityonWeb."Entry No." := OldAssociateEligibilityonWeb."Entry No." + 1;
                            AssociateEligibilityonWeb."Associate Code" := AssociateEligibilityStaging."Associate Code";
                            AssociateEligibilityonWeb."Commission_TA Amount" := AssociateEligibilityStaging.Amount;
                            AssociateEligibilityonWeb."Response Value" := 'Success';
                            AssociateEligibilityonWeb.Date := TODAY;
                            AssociateEligibilityonWeb.INSERT;
                            AssociateEligibilityStaging."Publish Data" := TRUE;
                            AssociateEligibilityStaging.MODIFY;
                        UNTIL AssociateEligibilityStaging.NEXT = 0;
                    MESSAGE('%1', 'Process Done');
                end;
            }
            action("Manual Push Data on Web")
            {
                Caption = 'Manual Push Data on Web';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AssociateEligibilityStaging: Record "Associate Eligibility Staging";
                    OldAssociateEligibilityonWeb: Record "Associate Eligibility on Web";
                begin
                    //CLEAR(AssociateWebDataPush_1);
                    //AssociateWebDataPush_1.RUN;

                    IF CONFIRM('Do you want to push the data for Associate -' + Rec."Associate Code") THEN BEGIN
                        AssociateEligibilityStaging.RESET;
                        AssociateEligibilityStaging.SETRANGE("Entry No.", Rec."Entry No.");
                        AssociateEligibilityStaging.SETRANGE("Publish Data", FALSE);
                        IF AssociateEligibilityStaging.FINDFIRST THEN BEGIN
                            OldAssociateEligibilityonWeb.RESET;
                            IF OldAssociateEligibilityonWeb.FINDLAST THEN;
                            AssociateEligibilityonWeb.RESET;
                            AssociateEligibilityonWeb."Entry No." := OldAssociateEligibilityonWeb."Entry No." + 1;
                            AssociateEligibilityonWeb."Associate Code" := AssociateEligibilityStaging."Associate Code";
                            AssociateEligibilityonWeb."Commission_TA Amount" := AssociateEligibilityStaging.Amount;
                            AssociateEligibilityonWeb."Response Value" := 'Success';
                            AssociateEligibilityonWeb.Date := TODAY;
                            AssociateEligibilityonWeb.INSERT;
                            AssociateEligibilityStaging."Publish Data" := TRUE;
                            AssociateEligibilityStaging.MODIFY;
                        END;
                        MESSAGE('%1', 'Process Done');
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow Associate Payment", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        MemberOf: Record "Access Control";
        //AssociateWebDataPush: Codeunit 50001;
        //AssociateWebDataPush_1: Codeunit 50001;
        AssociateEligibilityStaging: Record "Associate Eligibility Staging";
        AssElgStaging: Record "Associate Eligibility Staging";
        AssociateEligibilityonWeb: Record "Associate Eligibility on Web";
}

