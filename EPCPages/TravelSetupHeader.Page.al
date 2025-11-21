page 97963 "Travel Setup Header"
{
    // //BBG1.2 191213 Added code for update ARM TA Code
    // //BBG1.2 231213 Added code for Update End DAte on line level

    PageType = Card;
    SourceTable = "Travel Setup Header";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    Caption = 'Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
            }
            part(TASubform; "Travel Setup Line")
            {
                SubPageLink = "Associate Code" = FIELD("Associate Code"),
                              "Effective Date" = FIELD("Effective Date");
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
                group("Set Status")
                {
                    Caption = 'Set Status';
                    action(Open)
                    {
                        Caption = 'Open';
                        Image = ReOpen;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'Return';

                        trigger OnAction()
                        begin
                            UserSetup.RESET;
                            UserSetup.SETRANGE("User ID", USERID);
                            UserSetup.SETRANGE("Setups Creation", TRUE);
                            IF NOT UserSetup.FINDFIRST THEN
                                ERROR('Please contact Admin');

                            IF Rec.Status <> Rec.Status::Open THEN BEGIN
                                IF NOT CONFIRM(TEXT50003) THEN
                                    EXIT;
                                Rec.VALIDATE(Status, Rec.Status::Open);
                                // CurrPAGE.EDITABLE := TRUE;
                                Rec.MODIFY;
                            END ELSE
                                ERROR(TEXT50004);
                        end;
                    }
                    action("In-active")
                    {
                        Caption = 'In-active';
                        Image = InactivityDescription;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            UserSetup.RESET;
                            UserSetup.SETRANGE("User ID", USERID);
                            UserSetup.SETRANGE("Setups Approval", TRUE);
                            IF NOT UserSetup.FINDFIRST THEN
                                ERROR('Please contact Admin');

                            IF Rec.Status <> Rec.Status::"In-Active" THEN BEGIN
                                IF NOT CONFIRM(TEXT50002) THEN
                                    EXIT;
                                Rec.VALIDATE(Status, Rec.Status::"In-Active");
                                Rec.MODIFY;
                            END ELSE
                                ERROR(TEXT50005);
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
                            //BBG1.2 191213
                            UserSetup.RESET;
                            UserSetup.SETRANGE("User ID", USERID);
                            UserSetup.SETRANGE("Setups Approval", TRUE);
                            IF NOT UserSetup.FINDFIRST THEN
                                ERROR('Please contact Admin');

                            TARate := 0;
                            ARMNo := '';
                            ARMNo1 := '';
                            TravelSetupLine.RESET;
                            TravelSetupLine.SETCURRENTKEY("Associate Code", "Effective Date", Rate);
                            TravelSetupLine.SETRANGE("Associate Code", Rec."Associate Code");
                            TravelSetupLine.SETRANGE("Effective Date", Rec."Effective Date");
                            TravelSetupLine.SETRANGE("TA Code", '');
                            IF TravelSetupLine.FINDSET THEN
                                REPEAT
                                    IF TARate <> TravelSetupLine.Rate THEN BEGIN
                                        TARate := TravelSetupLine.Rate;
                                        TSLine.RESET;
                                        TSLine.SETCURRENTKEY("TA Code");
                                        IF TSLine.FINDLAST THEN BEGIN
                                            ARMNo := TSLine."TA Code";
                                            IF ARMNo = '' THEN BEGIN
                                                UnitSetup.GET;
                                                UnitSetup.TESTFIELD("ARM Doc TA No.");
                                                TravelSetupLine."TA Code" := UnitSetup."ARM Doc TA No.";
                                            END;
                                        END;
                                        TravelSetupLine."TA Code" := INCSTR(ARMNo);
                                        ARMNo1 := INCSTR(ARMNo);
                                    END ELSE
                                        TravelSetupLine."TA Code" := ARMNo1;
                                    IF ARMNo = '' THEN BEGIN
                                        UnitSetup.GET;
                                        UnitSetup.TESTFIELD("ARM Doc TA No.");
                                        TravelSetupLine."TA Code" := UnitSetup."ARM Doc TA No.";
                                    END;
                                    TravelSetupLine.MODIFY;
                                UNTIL TravelSetupLine.NEXT = 0;
                            //BBG1.2 191213


                            IF Rec.Status <> Rec.Status::Released THEN BEGIN
                                IF NOT CONFIRM(TEXT50001) THEN
                                    EXIT;
                                Rec.TESTFIELD("Effective Date");
                                Rec.VALIDATE(Status, Rec.Status::Released);
                                //  CurrPAGE.EDITABLE := FALSE;
                                Rec.MODIFY;
                            END ELSE
                                ERROR(TEXT50000);
                            //BBG1.2 231213
                            TravelSetupHdr.RESET;
                            TravelSetupHdr.SETRANGE("Associate Code", Rec."Associate Code");
                            TravelSetupHdr.SETFILTER("Effective Date", '<%1', Rec."Effective Date");
                            TravelSetupHdr.SETRANGE("End Date", 0D);
                            IF TravelSetupHdr.FINDFIRST THEN BEGIN
                                TravelSetupHdr."End Date" := CALCDATE('-1D', Rec."Effective Date");
                                TravelSetupHdr.MODIFY;
                                TravelSetupLine.RESET;
                                TravelSetupLine.SETRANGE("Associate Code", Rec."Associate Code");
                                TravelSetupLine.SETRANGE("Effective Date", TravelSetupHdr."Effective Date");
                                IF TravelSetupLine.FINDSET THEN
                                    REPEAT
                                        TravelSetupLine."End Date" := TravelSetupHdr."End Date";
                                        TravelSetupLine.MODIFY;
                                    UNTIL TravelSetupLine.NEXT = 0;
                            END;
                            //BBG1.2 231213
                        end;
                    }
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        TravelSetupLine.RESET;
        TravelSetupLine.SETRANGE("Associate Code", Rec."Associate Code");
        IF TravelSetupLine.FINDFIRST THEN
            Rec.TESTFIELD(Status, Rec.Status::Released); //ALLEDK 030313
    end;

    var
        TEXT50000: Label 'Status of Travel is already released.';
        TEXT50001: Label 'Do you want to release this Travel?';
        TEXT50002: Label 'Do you want to set the Travel as in-active?';
        TEXT50003: Label 'Do you want to open the Travel?';
        TEXT50004: Label 'Status of Travel is already open.';
        TEXT50005: Label 'Status of Travel is already in-active.';
        TEXT50006: Label 'There is nothing to release.';
        TravelSetupLine: Record "Travel Setup Line New";
        TARate: Decimal;
        ARMNo: Code[20];
        TSLine: Record "Travel Setup Line New";
        UnitSetup: Record "Unit Setup";
        ARMNo1: Code[20];
        TravelSetupHdr: Record "Travel Setup Header";
        UserSetup: Record "User Setup";
}

