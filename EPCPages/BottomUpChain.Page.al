page 50026 "Bottom Up Chain"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Associate Hierarcy with App.";
    SourceTableView = WHERE(Status = CONST(Active));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Application Code"; Rec."Application Code")
                {
                    Editable = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                    Editable = false;
                }
                field("Region/Rank Code"; Rec."Region/Rank Code")
                {
                    Editable = false;
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = false;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                }
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecRankCode.RESET;
                        RecRankCode.SETRANGE(RecRankCode."Rank Batch Code", Rec."Region/Rank Code");
                        IF PAGE.RUNMODAL(0, RecRankCode) = ACTION::LookupOK THEN BEGIN
                            Rec."Rank Code" := RecRankCode.Code;
                        END;
                    end;
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field("Commission Rate/SQD"; Rec."Commission Rate/SQD")   //300425 Added new field
                {
                }
                field("Rank Description"; Rec."Rank Description")
                {
                }
                field("TA Exists"; Rec."TA Exists")
                {
                }
                field("Application DOJ"; Rec."Application DOJ")
                {
                }
                field("Entry Mark"; Rec."Entry Mark")
                {
                }
                field("Commission Base Amount BSP2"; Rec."Commission Base Amount BSP2")
                {
                }
                field("Commission Base Amount"; Rec."Commission Base Amount")
                {
                }
                field("Commission Amount BSP2"; Rec."Commission Amount BSP2")
                {
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                }
                field("Commission Base Amt"; Rec."Commission Base Amt")
                {
                }
                field("Travel Generated"; Rec."Travel Generated")
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
                action("Update Upline")
                {
                    Caption = 'Update Upline';

                    trigger OnAction()
                    begin
                        /*
                        CompanywiseAccount.RESET;
                        CompanywiseAccount.SETRANGE(CompanywiseAccount."MSC Company",TRUE);
                        IF CompanywiseAccount.FINDFIRST THEN BEGIN
                          IF COMPANYNAME = CompanywiseAccount."Company Code" THEN
                            ERROR('This functionality use from Respective company');
                        END;
                         */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User ID",USERID);
                        Memberof.SETRANGE(Memberof."Role ID",'A_COMMUPDATE');
                        IF NOT Memberof.FINDFIRST THEN
                          ERROR('You do not have permission of role :A_COMMUPDATE ');
                          */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        Amt := 0;
                        CLEAR(UplinePage);
                        UplinePage.SETTABLEVIEW(Rec);
                        UplinePage.RUNMODAL;

                    end;
                }
                action("Create Partially / Full RB on Old Application")
                {
                    Caption = 'Create Partially / Full RB on Old Application';

                    trigger OnAction()
                    begin
                        CompanywiseAccount.RESET;
                        CompanywiseAccount.SETRANGE(CompanywiseAccount."MSC Company", TRUE);
                        IF CompanywiseAccount.FINDFIRST THEN BEGIN
                            IF COMPANYNAME = CompanywiseAccount."Company Code" THEN
                                ERROR('This functionality use from Respective company');
                        END;
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User ID",USERID);
                        Memberof.SETRANGE(Memberof."Role ID",'A_COMMUPDATE');
                        IF NOT Memberof.FINDFIRST THEN
                          ERROR('You do not have permission of role :A_COMMUPDATE ');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                        IF NOT Bond.GET(Rec."Application Code") THEN
                            ERROR('Please check the Application No.');

                        IF Bond.GET(Rec."Application Code") THEN
                            IF Bond."Posting Date" > 20130301D THEN
                                ERROR('Application must be before March 2013');

                        RecAmt := 0;
                        APPEntry.RESET;
                        APPEntry.SETRANGE(APPEntry."Document No.", Rec."Application Code");
                        APPEntry.SETRANGE(APPEntry."Cheque Status", APPEntry."Cheque Status"::Cleared);
                        IF APPEntry.FINDSET THEN
                            REPEAT
                                RecAmt := RecAmt + APPEntry.Amount;
                            UNTIL APPEntry.NEXT = 0;

                        IF RecAmt < Bond.Amount THEN
                            ERROR('Application have not full Received Amount');


                        BaseAmount := 0;
                        PTLSales.RESET;
                        PTLSales.SETRANGE(PTLSales."Document No.", Rec."Application Code");
                        PTLSales.SETRANGE(PTLSales."Direct Associate", TRUE);
                        IF PTLSales.FINDFIRST THEN
                            BaseAmount := PTLSales."Criteria Value / Base Amount";

                        NoofRec := 0;
                        ExistCommEntry.RESET;
                        ExistCommEntry.SETRANGE("Application No.", Rec."Application Code");
                        IF ExistCommEntry.FINDSET THEN BEGIN
                            REPEAT
                                NoofRec := ExistCommEntry.COUNT;
                            UNTIL ExistCommEntry.NEXT = 0;
                            IF NoofRec > 2 THEN
                                ERROR('Commission already Generated');
                        END;

                        CLEAR(ExistCommEntry);
                        CommAmt := 0;
                        ExistCommEntry.RESET;
                        ExistCommEntry.SETRANGE("Application No.", Rec."Application Code");
                        ExistCommEntry.SETRANGE("Direct to Associate", TRUE);
                        IF ExistCommEntry.FINDSET THEN BEGIN
                            REPEAT
                                CommAmt := CommAmt + ExistCommEntry."Commission Amount";
                            UNTIL ExistCommEntry.NEXT = 0;
                        END;

                        IF (BaseAmount - CommAmt) > 0 THEN BEGIN
                            IF CONFIRM('Do you want to Create RB for Application No. ' + Rec."Application Code") THEN BEGIN
                                CommEntry.RESET;
                                IF CommEntry.FINDLAST THEN
                                    EntryNo := CommEntry."Entry No." + 1;

                                CommEntry.INIT;
                                CommEntry."Entry No." := EntryNo;
                                CommEntry.VALIDATE("Application No.", Rec."Application Code");
                                CommEntry."Posting Date" := Rec."Posting Date";
                                CommEntry."Associate Code" := Rec."Introducer Code";
                                CommEntry."Base Amount" := BaseAmount - CommAmt;
                                CommEntry."Commission Amount" := ROUND((BaseAmount - CommAmt), 1);
                                CommEntry."Direct to Associate" := TRUE;
                                CommEntry."Bond Category" := Bond."Bond Category";
                                CommEntry."Business Type" := CommEntry."Business Type"::SELF;
                                CommEntry."Introducer Code" := Rec."Introducer Code";
                                CommEntry."Scheme Code" := Bond."Scheme Code";
                                CommEntry."Project Type" := Bond."Project Type";
                                CommEntry."Shortcut Dimension 1 Code" := Rec."Project Code";  //ALLEDK 040113
                                CommEntry."First Year" := TRUE;
                                CommEntry.INSERT;
                                MESSAGE('%1', 'Commission Generated successfully');
                            END;
                        END ELSE
                            MESSAGE('Commission Entries already Exists');

                    end;
                }
            }
        }
    }

    var
        UplinePage: Page "UpLine Form";
        CommissionEntry: Record "Commission Entry";
        CommEntry: Record "Commission Entry";
        Amt: Decimal;
        EntryNo: Integer;
        BaseAmount: Decimal;
        Bond: Record "Confirmed Order";
        APPEntry: Record "Application Payment Entry";
        RecAmt: Decimal;
        ExistCommEntry: Record "Commission Entry";
        NoofRec: Integer;
        PTLSales: Record "Payment Terms Line Sale";
        CommAmt: Decimal;
        RecRankCode: Record "Rank Code";
        CompanywiseAccount: Record "Company wise G/L Account";
}

