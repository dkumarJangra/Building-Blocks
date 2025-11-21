page 97986 "Incentive Unit Header Form"
{
    PageType = Card;
    SourceTable = "Incentive Unit Header";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Incentive Unit Code"; Rec."Incentive Unit Code")
                {

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("W.e.f. Date"; Rec."W.e.f. Date")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
            }
            part(""; "Incentive Unit Line Subform")
            {
                SubPageLink = "Incentive Unit Code" = FIELD("Incentive Unit Code");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("I&ncentive Unit")
            {
                Caption = 'I&ncentive Unit';
                group("Set Status")
                {
                    Caption = 'Set Status';
                    action(Open)
                    {
                        Caption = 'Open';
                        ShortCutKey = 'Return';

                        trigger OnAction()
                        begin
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
                            IF Rec.Status <> Rec.Status::Released THEN BEGIN
                                IF NOT CONFIRM(TEXT50001) THEN
                                    EXIT;
                                Rec.TESTFIELD("W.e.f. Date");
                                Rec.TESTFIELD("Responsibility Center");
                                IncentiveUnitLine.RESET;
                                IncentiveUnitLine.SETRANGE("Incentive Unit Code", Rec."Incentive Unit Code");
                                IF Rec.FINDFIRST THEN BEGIN
                                    REPEAT
                                        IncentiveUnitLine.TESTFIELD("Min. Extent");
                                        IncentiveUnitLine.TESTFIELD("Max. Extent");
                                        IncentiveUnitLine.TESTFIELD(UOM);
                                        IncentiveUnitLine.TESTFIELD("No. of Units");
                                    UNTIL (IncentiveUnitLine.NEXT = 0);
                                END ELSE
                                    ERROR(TEXT50005);
                                Rec.VALIDATE(Status, Rec.Status::Released);
                                CurrPage.EDITABLE := FALSE;
                                Rec.MODIFY;
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
        IF (Rec.Status = Rec.Status::Released) OR (Rec.Status = Rec.Status::"In-Active") THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            CurrPage.EDITABLE := TRUE;
    end;

    var
        TEXT50000: Label 'Status of Incentive is already released.';
        TEXT50001: Label 'Do you want to release this Incentive?';
        TEXT50002: Label 'Do you want to set the incentive as in-active?';
        TEXT50003: Label 'Do you want to open the incentive?';
        TEXT50004: Label 'Status of Incentive is already open.';
        TEXT50005: Label 'Status of Incentive is already in-active.';
        IncentiveUnitLine: Record "Incentive Unit Line";
        TEXT50006: Label 'There is nothing to release.';
}

