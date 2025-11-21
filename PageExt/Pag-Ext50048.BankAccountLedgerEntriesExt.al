pageextension 50048 "BBG Bank Acc. Ledg Entries Ext" extends "Bank Account Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Cheque No.")
        {
            field("Cheque No.1"; Rec."Cheque No.1")
            {
                ApplicationArea = all;
            }
            field("Old Cheque No."; Rec."Old Cheque No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Currency Code")
        {
            field("UTR No."; Rec."UTR No.")
            {
                ApplicationArea = All;
            }
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
            field("TO Region Code"; Rec."TO Region Code")
            {
                ApplicationArea = All;
            }
            field("TO Region Name"; Rec."TO Region Name")
            {
                ApplicationArea = All;
            }
            field("User Branch Code"; Rec."User Branch Code")
            {
                ApplicationArea = All;
            }
            field("Application No."; Rec."Application No.")
            {
                ApplicationArea = All;
            }
            field("Statement Status"; Rec."Statement Status")
            {
                ApplicationArea = All;
            }
            field("Statement No."; Rec."Statement No.")
            {
                ApplicationArea = All;
            }
            field("Statement Line No."; Rec."Statement Line No.")
            {
                ApplicationArea = All;
            }
            field(Bounced; Rec.Bounced)
            {
                ApplicationArea = All;
            }
            field("Send SMS on Cheq bounce"; Rec."Send SMS on Cheq bounce")
            {
                ApplicationArea = All;
            }
        }
        addafter("Entry No.")
        {
            field("Value Date"; Rec."Value Date")
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
            action("Upload UTR No.")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    //ALLEDK 210521
                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("UTR No. Upload", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Çontact Admin');

                    CLEAR(UpdateUTRNo);
                    UpdateUTRNo.RUN;
                    //ALLEDK 210521
                end;
            }

        }
    }

    var
        myInt: Integer;
        Dimvalrec: Record "Dimension Value";
        UserSetup: Record "User Setup";
        UpdateUTRNo: XMLport "Update UTR No";

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("View of BALedger Entry", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            UserSetup.TESTFIELD("View of BALedger Entry");
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."TO Region Code" <> '' THEN BEGIN
            Dimvalrec.RESET;
            Dimvalrec.SETFILTER(Dimvalrec."Dimension Code", 'TO REGION');
            Dimvalrec.SETFILTER(Dimvalrec.Code, Rec."TO Region Code");
            IF Dimvalrec.FINDFIRST THEN
                Rec."TO Region Name" := Dimvalrec.Name;
        END;
    end;
}