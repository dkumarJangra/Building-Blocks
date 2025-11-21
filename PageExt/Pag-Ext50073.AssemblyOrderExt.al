pageextension 50073 "BBG Assembly Order Ext" extends "Assembly Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            var
                UserSetup: Record "User Setup";
            Begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN BEGIN
                    IF UserSetup."Allow Back Date Posting" THEN BEGIN
                        IF Rec."Posting Date" > TODAY THEN
                            ERROR('Posting Date can not be greater than =' + FORMAT(TODAY));
                    END ELSE
                        IF Rec."Posting Date" <> TODAY THEN
                            ERROR('Posting Date can not be differ from Today Date =' + FORMAT(TODAY));
                END;
            End;
        }
        addafter(Description)
        {
            field("Agreement Document No."; Rec."Agreement Document No.")
            {
                ApplicationArea = All;

            }
            field("Total Area (in Sqyd)"; Rec."Total Area (in Sqyd)")
            {
                ApplicationArea = All;

            }
            field("Saleable Area %"; Rec."Saleable Area %")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("F&unctions")
        {
            action("Insert Land Agreement Lines")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(LandAgreementforAssembly);
                    LandAgreementforAssembly.SetDocumentNo(Rec."No.");
                    LandAgreementforAssembly.RUN;
                end;
            }
        }
    }

    var
        myInt: Integer;
        LandAgreementforAssembly: Page "Land Agreement for Assembly";
}