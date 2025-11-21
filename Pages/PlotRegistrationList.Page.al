page 60684 "Plot Registration List"
{
    CardPageID = "Plot Registration Details Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Plot Registration Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("User Code"; Rec."User Code")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Open Stage"; Rec."Open Stage")
                {
                    Caption = 'Status';
                }
                field("Current Remarks"; Rec."Current Remarks")
                {
                }
                field("Current Days"; Rec."Current Days")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        UpdateDays;
    end;

    var
        v_PlotRegistrationDetails: Record "Plot Registration Details";

    local procedure UpdateDays()
    begin
        v_PlotRegistrationDetails.RESET;
        IF v_PlotRegistrationDetails.FINDSET THEN
            REPEAT

                IF (v_PlotRegistrationDetails."Open Stage" = '') OR (v_PlotRegistrationDetails."Open Stage" = 'STAGE 1') THEN BEGIN
                    IF v_PlotRegistrationDetails."Document Date" <> 0D THEN BEGIN
                        v_PlotRegistrationDetails."Ageing Days 1" := FORMAT(TODAY - v_PlotRegistrationDetails."Document Date") + 'D';
                        v_PlotRegistrationDetails."Current Days" := v_PlotRegistrationDetails."Ageing Days 1";
                        v_PlotRegistrationDetails."Current Remarks" := v_PlotRegistrationDetails."Remarks 1";
                    END;
                END ELSE
                    IF (v_PlotRegistrationDetails."Open Stage" = 'STAGE 2') THEN BEGIN
                        IF v_PlotRegistrationDetails."Approved Date (Stage-1)" <> 0D THEN BEGIN
                            v_PlotRegistrationDetails."Ageing Days 2" := FORMAT(TODAY - v_PlotRegistrationDetails."Approved Date (Stage-1)") + 'D';
                            v_PlotRegistrationDetails."Current Days" := v_PlotRegistrationDetails."Ageing Days 2";
                            v_PlotRegistrationDetails."Current Remarks" := v_PlotRegistrationDetails."Remarks 2";
                        END;
                    END ELSE
                        IF (v_PlotRegistrationDetails."Open Stage" = 'STAGE 3') THEN BEGIN
                            IF v_PlotRegistrationDetails."Approved Date (Stage-2)" <> 0D THEN BEGIN
                                v_PlotRegistrationDetails."Ageing Days 3" := FORMAT(TODAY - v_PlotRegistrationDetails."Approved Date (Stage-2)") + 'D';
                                v_PlotRegistrationDetails."Current Days" := v_PlotRegistrationDetails."Ageing Days 3";
                                v_PlotRegistrationDetails."Current Remarks" := v_PlotRegistrationDetails."Remarks 3";
                            END;
                        END ELSE
                            IF (v_PlotRegistrationDetails."Open Stage" = 'STAGE 4') THEN BEGIN
                                IF v_PlotRegistrationDetails."Approved Date (Stage-3)" <> 0D THEN BEGIN
                                    v_PlotRegistrationDetails."Ageing Days 4" := FORMAT(TODAY - v_PlotRegistrationDetails."Approved Date (Stage-3)") + 'D';
                                    v_PlotRegistrationDetails."Current Days" := v_PlotRegistrationDetails."Ageing Days 4";
                                    v_PlotRegistrationDetails."Current Remarks" := v_PlotRegistrationDetails."Remarks 4";
                                END;
                            END ELSE
                                IF (v_PlotRegistrationDetails."Open Stage" = 'STAGE 5') THEN BEGIN
                                    IF v_PlotRegistrationDetails."Approved Date (Stage-4)" <> 0D THEN BEGIN
                                        v_PlotRegistrationDetails."Ageing Days 5" := FORMAT(TODAY - v_PlotRegistrationDetails."Approved Date (Stage-4)") + 'D';
                                        v_PlotRegistrationDetails."Current Days" := v_PlotRegistrationDetails."Ageing Days 5";
                                        v_PlotRegistrationDetails."Current Remarks" := v_PlotRegistrationDetails."Remarks 5";
                                    END;
                                END ELSE
                                    IF (v_PlotRegistrationDetails."Open Stage" = 'STAGE 6') THEN BEGIN
                                        IF v_PlotRegistrationDetails."Approved Date (Stage-5)" <> 0D THEN BEGIN
                                            v_PlotRegistrationDetails."Ageing Days 6" := FORMAT(TODAY - v_PlotRegistrationDetails."Approved Date (Stage-5)") + 'D';
                                            v_PlotRegistrationDetails."Current Days" := v_PlotRegistrationDetails."Ageing Days 6";
                                            v_PlotRegistrationDetails."Current Remarks" := v_PlotRegistrationDetails."Remarks 6";
                                        END;
                                    END ELSE
                                        IF (v_PlotRegistrationDetails."Open Stage" = 'STAGE 7') THEN BEGIN
                                            IF v_PlotRegistrationDetails."Approved Date (Stage-6)" <> 0D THEN BEGIN
                                                v_PlotRegistrationDetails."Ageing Days 7" := FORMAT(TODAY - v_PlotRegistrationDetails."Approved Date (Stage-6)") + 'D';
                                                v_PlotRegistrationDetails."Current Days" := v_PlotRegistrationDetails."Ageing Days 7";
                                                v_PlotRegistrationDetails."Current Remarks" := v_PlotRegistrationDetails."Remarks 7";
                                            END;
                                        END;
                v_PlotRegistrationDetails.MODIFY;
            UNTIL v_PlotRegistrationDetails.NEXT = 0;

        CurrPage.UPDATE;
    end;
}

