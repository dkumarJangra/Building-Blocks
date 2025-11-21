tableextension 50049 "BBG Res. Journal Line Ext" extends "Res. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Work Type Code")
        {
            trigger OnAfterValidate()
            begin
                IF WorkType.GET("Work Type Code") THEN
                    "Work Type Description" := WorkType.Description
                ELSE
                    "Work Type Description" := '';

                //ALLEND 191107
                IF RecUserSetup.GET(USERID) THEN
                    IF RecRespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN BEGIN
                        VALIDATE("Shortcut Dimension 1 Code", RecRespCenter."Global Dimension 1 Code");
                    END;
                //ALLEND 191107


                ResLedgEntry.RESET;
                ResLedgEntry.SETRANGE(ResLedgEntry."Posting Date", "Posting Date");
                ResLedgEntry.SETRANGE(ResLedgEntry."Work Type Code", "Work Type Code");
                ResLedgEntry.SETRANGE(ResLedgEntry."Global Dimension 1 Code", RecRespCenter."Global Dimension 1 Code");
                IF ResLedgEntry.FINDFIRST THEN BEGIN
                    IF CONFIRM('Entry already exists for same Posting Date Work Type Code & Region code Do you still want to continue', TRUE) THEN BEGIN
                    END ELSE BEGIN
                        "Work Type Code" := '';
                    END;
                END;
            end;
        }
        field(50001; Remark; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';
        }
        field(50002; Verified; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';

            trigger OnValidate()
            begin
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETFILTER("Role ID", '%1', 'EHSVERIFY');
                IF Memberof.FIND('-') THEN BEGIN
                    IF Verified = TRUE THEN BEGIN
                        "Verified By" := USERID;
                        TESTFIELD("Work Type Code");
                        TESTFIELD(Quantity);
                    END ELSE
                        "Verified By" := '';
                END ELSE
                    ERROR('SORRY YOU ARE NOT AUTHORISED TO PERFORM THIS TASK');
            end;
        }
        field(50003; "Verified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';
        }
        field(50008; "Work Type Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        Memberof: Record "Access Control";
        RecUserSetup: Record "User Setup";
        ResLedgEntry: Record "Res. Ledger Entry";
        RecRespCenter: Record "Responsibility Center 1";
        WorkType: Record "Work Type";
}