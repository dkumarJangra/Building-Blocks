page 50027 "UpLine Form"
{
    PageType = Card;
    SourceTable = "Associate Hierarcy with App.";
    SourceTableView = SORTING("Rank Code", "Application Code");
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Application Code"; Rec."Application Code")
                {

                    trigger OnValidate()
                    begin
                        Rec."Not Update in MSCompany" := TRUE;
                    end;
                }
                field("Introducer Code"; Rec."Introducer Code")
                {

                    trigger OnValidate()
                    begin
                        Rec."Not Update in MSCompany" := TRUE;
                    end;
                }
                field("Associate Code"; Rec."Associate Code")
                {

                    trigger OnValidate()
                    begin
                        Rec."Not Update in MSCompany" := TRUE;
                    end;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Region/Rank Code"; Rec."Region/Rank Code")
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Commission %"; Rec."Commission %")
                {

                    trigger OnValidate()
                    begin
                        Rec."Not Update in MSCompany" := TRUE;
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {

                    trigger OnValidate()
                    begin
                        Rec."Not Update in MSCompany" := TRUE;
                    end;
                }
                field("Rank Code"; Rec."Rank Code")
                {

                    trigger OnValidate()
                    begin
                        Rec."Not Update in MSCompany" := TRUE;
                    end;
                }
                field("Rank Description"; Rec."Rank Description")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update in MS Comp.")
            {
                Caption = 'Update in MS Comp.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AssociateHierwithApp.RESET;
                    AssociateHierwithApp.SETRANGE("Application Code", Rec."Application Code");
                    IF AssociateHierwithApp.FINDFIRST THEN
                        REPEAT
                            NewAssociateHierwithAppl.RESET;
                            NewAssociateHierwithAppl.SETRANGE("Application Code", AssociateHierwithApp."Application Code");
                            NewAssociateHierwithAppl.SETRANGE("Line No.", AssociateHierwithApp."Line No.");
                            IF NewAssociateHierwithAppl.FINDFIRST THEN BEGIN
                                NewAssociateHierwithAppl.TRANSFERFIELDS(AssociateHierwithApp);
                                NewAssociateHierwithAppl.MODIFY;
                            END ELSE BEGIN
                                NewAssociateHierwithAppl.INIT;
                                NewAssociateHierwithAppl.TRANSFERFIELDS(AssociateHierwithApp);
                                NewAssociateHierwithAppl.INSERT;
                            END;
                            AssociateHierwithApp."Not Update in MSCompany" := FALSE;
                            AssociateHierwithApp.MODIFY;
                        UNTIL AssociateHierwithApp.NEXT = 0;
                    MESSAGE('%1', 'Update successfully');
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        Memberof.RESET;
        Memberof.SETRANGE(Memberof."User ID",USERID);
        Memberof.SETRANGE(Memberof."Role ID",'A_COMMUPDATE');
        IF NOT Memberof.FINDFIRST THEN
          ERROR('You do not have permission of role :A_COMMUPDATE ');
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec."Not Update in MSCompany" := TRUE;
    end;

    trigger OnOpenPage()
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        Memberof.RESET;
        Memberof.SETRANGE(Memberof."User ID",USERID);
        Memberof.SETRANGE(Memberof."Role ID",'A_COMMUPDATE');
        IF NOT Memberof.FINDFIRST THEN
          ERROR('You do not have permission of role :A_COMMUPDATE ');
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;

    var
        NewAssociateHierwithAppl: Record "New Associate Hier with Appl.";
        AssociateHierwithApp: Record "Associate Hierarcy with App.";
}

