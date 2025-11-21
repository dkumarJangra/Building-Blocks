page 98002 "Gold Coin Hdr"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Gold Coin Hdr";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Plot Size"; Rec."Plot Size")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
            part(GoldSubForm; "Gold Coin Line")
            {
                SubPageLink = "Plot Size" = FIELD("Plot Size");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Gold")
            {
                Caption = '&Gold';
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
                            UserSetup.RESET;
                            UserSetup.SETRANGE("User ID", USERID);
                            UserSetup.SETRANGE("Setups Approval", TRUE);
                            IF NOT UserSetup.FINDFIRST THEN
                                ERROR('Please contact Admin');

                            IF Rec.Status <> Rec.Status::Released THEN BEGIN
                                IF NOT CONFIRM(TEXT50001) THEN
                                    EXIT;
                                Rec.VALIDATE(Status, Rec.Status::Released);
                                //  CurrPAGE.EDITABLE := FALSE;
                                Rec.MODIFY;
                            END ELSE
                                ERROR(TEXT50000);
                        end;
                    }
                }
            }
        }
    }

    var
        TEXT50000: Label 'Status of Gold is already released.';
        TEXT50001: Label 'Do you want to release this Gold?';
        TEXT50002: Label 'Do you want to set the Gold as in-active?';
        TEXT50003: Label 'Do you want to open the Gold?';
        TEXT50004: Label 'Status of Gold is already open.';
        TEXT50005: Label 'Status of Gold is already in-active.';
        TEXT50006: Label 'There is nothing to release.';
        GoldCoinLine: Record "Gold Coin Line";
        UserSetup: Record "User Setup";


    procedure ControlUpdates(ControlStatus: Boolean)
    begin
    end;
}

