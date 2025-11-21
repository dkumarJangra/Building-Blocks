page 97983 "Incentive Header Form"
{
    PageType = Card;
    SourceTable = "Incentive Header";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Incentive Code"; Rec."Incentive Code")
                {
                    Editable = "Incentive CodeEditable";

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("W.e.f. Date"; Rec."W.e.f. Date")
                {
                    Caption = 'Start Date';
                    Editable = "W.e.f. DateEditable";
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = "End DateEditable";
                }
                field(Status; Rec.Status)
                {
                    Editable = StatusEditable;
                }
                field("No. of Units"; Rec."No. of Units")
                {
                    Editable = "No. of UnitsEditable";

                    trigger OnValidate()
                    begin
                        CurrPage."Incentive Subform".PAGE.EnableControls(Rec."No. of Units");
                    end;
                }
                field(Dimfilter1; Dimfilter1)
                {
                    Caption = 'Project Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        GLSetup.GET;
                        EXIT(LookUpDimFilter(GLSetup."Global Dimension 1 Code", Text));
                    end;
                }
            }
            part("Incentive Subform"; "Incentive Line Subform")
            {
                SubPageLink = "Incentive Code" = FIELD("Incentive Code");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("I&ncentive")
            {
                Caption = 'I&ncentive';
                action("Insert Data Setup")
                {
                    Caption = 'Insert Data Setup';

                    trigger OnAction()
                    begin
                        IF Dimfilter1 = '' THEN
                            ERROR('Please define Project filter');

                        CLEAR(IncentiveLine);
                        IncentiveLine.RESET;
                        IncentiveLine.SETRANGE("Incentive Code", Rec."Incentive Code");
                        IF IncentiveLine.FINDLAST THEN
                            LineNo := IncentiveLine."Line No."
                        ELSE
                            LineNo := 0;

                        Responsibilitycenter.RESET;
                        Responsibilitycenter.SETFILTER(Code, Dimfilter1);
                        IF Responsibilitycenter.FINDSET THEN
                            REPEAT
                                IncentiveLine1.RESET;
                                IncentiveLine1.SETRANGE("Incentive Code", Rec."Incentive Code");
                                IncentiveLine1.SETRANGE("Project Code", '');
                                IF IncentiveLine1.FINDSET THEN
                                    REPEAT
                                        IncentiveLine1.TESTFIELD("Incentive Type");
                                        IncentiveLine.INIT;
                                        IncentiveLine."Incentive Code" := Rec."Incentive Code";
                                        IncentiveLine."Line No." := LineNo + 10000;
                                        IncentiveLine."Extent Eligibilty" := IncentiveLine1."Extent Eligibilty";
                                        IncentiveLine."Plot Eligibility" := IncentiveLine1."Plot Eligibility";
                                        IncentiveLine.UOM := IncentiveLine1.UOM;
                                        IncentiveLine."Min. Required Collection" := IncentiveLine1."Min. Required Collection";
                                        IncentiveLine."Incentive Amount" := IncentiveLine1."Incentive Amount";
                                        IncentiveLine."Project Code" := Responsibilitycenter.Code;
                                        IncentiveLine."No. of Unit" := Rec."No. of Units";
                                        IncentiveLine."Project Name" := Responsibilitycenter.Name;
                                        IncentiveLine."Incentive Type" := IncentiveLine1."Incentive Type";
                                        IncentiveLine."Effective Date" := Rec."W.e.f. Date";
                                        IncentiveLine."End Date" := Rec."End Date";
                                        IncentiveLine.INSERT;
                                        LineNo := IncentiveLine."Line No.";
                                    UNTIL IncentiveLine1.NEXT = 0;
                            UNTIL Responsibilitycenter.NEXT = 0;

                        CLEAR(IncentiveLine);
                        IncentiveLine.RESET;
                        IncentiveLine.SETRANGE("Incentive Code", Rec."Incentive Code");
                        IncentiveLine.SETRANGE("Project Code", '');
                        IF IncentiveLine.FINDFIRST THEN
                            REPEAT
                                IncentiveLine.DELETE;
                            UNTIL IncentiveLine.NEXT = 0;

                        MESSAGE('Process Done');
                    end;
                }
                group("Set Status")
                {
                    Caption = 'Set Status';
                    action(Open)
                    {
                        Caption = 'Open';
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
                                CurrPage.EDITABLE := TRUE;
                                Rec.MODIFY;
                            END ELSE
                                ERROR(TEXT50004);
                        end;
                    }
                    action("In-active")
                    {
                        Caption = 'In-active';

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

                        trigger OnAction()
                        begin
                            UserSetup.RESET;
                            UserSetup.SETRANGE("User ID", USERID);
                            UserSetup.SETRANGE("Setups Approval", TRUE);
                            IF NOT UserSetup.FINDFIRST THEN
                                ERROR('Please contact Admin');

                            Rec.TESTFIELD("End Date");
                            IncentiveLine.RESET;
                            IncentiveLine.SETRANGE("Incentive Code", Rec."Incentive Code");
                            IncentiveLine.SETRANGE("End Date", 0D);
                            IF IncentiveLine.FINDSET THEN
                                REPEAT
                                    IncentiveLine."End Date" := Rec."End Date";
                                    IncentiveLine.MODIFY;
                                UNTIL IncentiveLine.NEXT = 0;

                            IF Rec."Incentive Type" = Rec."Incentive Type"::Individual THEN BEGIN
                                CLEAR(IncLine2);
                                IncLine2.RESET;
                                IncLine2.SETCURRENTKEY("Effective Date", "End Date", "Incentive Type", "No. of Unit");
                                IncLine2.SETRANGE("Effective Date", Rec."W.e.f. Date");
                                IncLine2.SETRANGE("End Date", Rec."End Date");
                                IncLine2.SETRANGE("Incentive Type", IncLine2."Incentive Type"::" ");
                                IF IncLine2.FINDSET THEN
                                    REPEAT
                                        CLEAR(IncentiveLine);
                                        IncentiveLine.RESET;
                                        IncentiveLine.SETRANGE("Incentive Code", Rec."Incentive Code");
                                        IncentiveLine.SETRANGE("Effective Date", Rec."W.e.f. Date");
                                        IncentiveLine.SETRANGE("Project Code", IncLine2."Project Code");
                                        IncentiveLine.SETRANGE("No. of Unit", IncLine2."No. of Unit");
                                        IncentiveLine.SETRANGE("Incentive Type", IncentiveLine."Incentive Type"::Individual);
                                        IF NOT IncentiveLine.FINDFIRST THEN
                                            ERROR('On this Team Incentive setup Project Code not Define-' + IncLine2."Project Code");
                                    UNTIL IncLine2.NEXT = 0;
                            END;

                            IF Rec.Status <> Rec.Status::Released THEN BEGIN
                                IF NOT CONFIRM(TEXT50001) THEN
                                    EXIT;
                                Rec.TESTFIELD("W.e.f. Date");
                                Rec.TESTFIELD("End Date");
                                CLEAR(IncentiveLine);
                                IncentiveLine.RESET;
                                IncentiveLine.SETRANGE("Incentive Code", Rec."Incentive Code");
                                IF IncentiveLine.FINDSET THEN BEGIN
                                    REPEAT
                                        IF Rec."No. of Units" THEN
                                            IF IncentiveLine."Incentive Type" = IncentiveLine."Incentive Type"::Individual THEN
                                                IncentiveLine.TESTFIELD("Min. Required Collection");
                                        //IncentiveLine.TESTFIELD("Incentive Amount");
                                        IF IncentiveLine."Incentive Type" = IncentiveLine."Incentive Type"::Team THEN
                                            IncentiveLine.TESTFIELD("Incentive Amount");

                                        IncentiveLine.TESTFIELD("Project Code");
                                        IF Rec."No. of Units" THEN
                                            IncentiveLine.TESTFIELD("Plot Eligibility")
                                        ELSE BEGIN
                                            IncentiveLine.TESTFIELD("Extent Eligibilty");
                                            IncentiveLine.TESTFIELD(UOM);
                                        END;


                                        IncentiveLine1.RESET;
                                        IncentiveLine1.SETFILTER("Incentive Code", '<>%1', Rec."Incentive Code");
                                        IncentiveLine1.SETRANGE("Project Code", IncentiveLine."Project Code");
                                        IncentiveLine1.SETRANGE("Effective Date", IncentiveLine."Effective Date", IncentiveLine."End Date");
                                        IncentiveLine1.SETRANGE("No. of Unit", IncentiveLine."No. of Unit");
                                        IncentiveLine1.SETRANGE("Incentive Type", IncentiveLine."Incentive Type");
                                        IF IncentiveLine1.FINDFIRST THEN
                                            ERROR('You have already defined incentive code for Project Code=' + IncentiveLine."Project Code" +
                                            'in between Start date and End Date');


                                        IncentiveLine1.RESET;
                                        IncentiveLine1.SETFILTER("Incentive Code", '<>%1', Rec."Incentive Code");
                                        IncentiveLine1.SETRANGE("Project Code", IncentiveLine."Project Code");
                                        IncentiveLine1.SETRANGE("End Date", IncentiveLine."Effective Date", IncentiveLine."End Date");
                                        IncentiveLine1.SETRANGE("Incentive Type", IncentiveLine."Incentive Type");
                                        IncentiveLine1.SETRANGE("No. of Unit", IncentiveLine."No. of Unit");
                                        IF IncentiveLine1.FINDFIRST THEN BEGIN
                                            IF IncentiveLine1."End Date" <> 0D THEN
                                                ERROR('You have already defined incentive code for Project Code=' + IncentiveLine."Project Code" +
                                                     'in between Start date and End Date');
                                        END;
                                    UNTIL (IncentiveLine.NEXT = 0);
                                END ELSE
                                    ERROR(TEXT50006);

                                IncentiveLine.RESET;
                                IncentiveLine.SETRANGE("Incentive Code", Rec."Incentive Code");
                                IncentiveLine.SETRANGE("Incentive Type", IncentiveLine."Incentive Type"::Individual);
                                IncentiveLine.SETFILTER("Incentive Amount", '%1', 0);
                                IF IncentiveLine.FINDFIRST THEN BEGIN
                                    IF NOT CONFIRM('The Incentive amount of the Project - ' + FORMAT(IncentiveLine."Project Code") + ' is = 0. ' +
                                    ' Do you want to Release?') THEN BEGIN
                                    END ELSE BEGIN
                                        Rec.VALIDATE(Status, Rec.Status::Released);
                                        CurrPage.EDITABLE := FALSE;
                                        Rec.MODIFY;
                                    END;
                                END ELSE BEGIN
                                    Rec.VALIDATE(Status, Rec.Status::Released);
                                    CurrPage.EDITABLE := FALSE;
                                    Rec.MODIFY;
                                END;
                            END ELSE
                                ERROR(TEXT50000);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage."Incentive Subform".PAGE.EnableControls(Rec."No. of Units");
        IF (Rec.Status = Rec.Status::Released) OR (Rec.Status = Rec.Status::"In-Active") THEN
            ControlUpdates(FALSE)
        ELSE
            ControlUpdates(TRUE);
        //  CurrPAGE.EDITABLE := FALSE
        //ELSE
        //  CurrPAGE.EDITABLE := TRUE;
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "End DateEditable" := TRUE;
        "No. of UnitsEditable" := TRUE;
        "W.e.f. DateEditable" := TRUE;
        "Incentive CodeEditable" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ControlUpdates(TRUE);
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IncentiveLine.RESET;
        IncentiveLine.SETRANGE("Incentive Code", Rec."Incentive Code");
        IF IncentiveLine.FINDFIRST THEN
            Rec.TESTFIELD(Status, Rec.Status::Released); //ALLEDK 030313
    end;

    var
        TEXT50000: Label 'Status of Incentive is already released.';
        TEXT50001: Label 'Do you want to release this Incentive?';
        TEXT50002: Label 'Do you want to set the incentive as in-active?';
        TEXT50003: Label 'Do you want to open the incentive?';
        TEXT50004: Label 'Status of Incentive is already open.';
        TEXT50005: Label 'Status of Incentive is already in-active.';
        IncentiveLine: Record "Incentive Line";
        TEXT50006: Label 'There is nothing to release.';
        IncentiveLine1: Record "Incentive Line";
        IncLine2: Record "Incentive Line";
        Dimfilter1: Text[1024];
        GLSetup: Record "General Ledger Setup";
        Responsibilitycenter: Record "Responsibility Center 1";
        LineNo: Integer;
        TEXT50007: Label 'The Incentive Amount of Project Code =%1 not defined.';
        UserSetup: Record "User Setup";

        "Incentive CodeEditable": Boolean;

        "W.e.f. DateEditable": Boolean;

        StatusEditable: Boolean;

        "No. of UnitsEditable": Boolean;

        "End DateEditable": Boolean;


    procedure ControlUpdates(ControlStatus: Boolean)
    begin
        "Incentive CodeEditable" := ControlStatus;
        "W.e.f. DateEditable" := ControlStatus;
        StatusEditable := ControlStatus;
        "No. of UnitsEditable" := ControlStatus;
        "End DateEditable" := ControlStatus;
    end;

    local procedure LookUpDimFilter(Dim: Code[20]; var Text: Text[250]): Boolean
    var
        DimVal: Record "Dimension Value";
        DimValList: Page "Dimension Value List";
    begin
        IF Dim = '' THEN
            EXIT(FALSE);
        DimValList.LOOKUPMODE(TRUE);
        DimVal.SETRANGE("Dimension Code", Dim);
        DimVal.SETRANGE("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
        DimValList.SETTABLEVIEW(DimVal);
        IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimValList.GETRECORD(DimVal);
            Text := DimValList.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE)
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Dimfilter1 := '';
    end;
}

