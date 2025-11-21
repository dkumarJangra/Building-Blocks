table 97825 "App. Charge Code"
{
    // ALLE011215 This field is used for Default PPlan when upload unit master

    DataPerCompany = false;
    LookupPageID = "App. Charge List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[60])
        {
        }
        field(3; "Charge Type"; Option)
        {
            Description = 'ALLETDK';
            OptionCaption = ' ,60Ft,Corner,Corner+60Ft';
            OptionMembers = " ","60Ft",Corner,"Corner+60Ft";
        }
        field(50000; "Description 2"; Text[200])
        {
        }
        field(50001; "Sub Payment Plan"; Boolean)
        {
        }
        field(50002; "Default Payment Plan"; Boolean)
        {
            Description = 'ALLE011215';
        }
        field(50003; "Sub Sub Payment Plan Code"; Code[20])
        {

            trigger OnValidate()
            var
                AppChargeCode: Record "App. Charge Code";
            begin
                IF "Sub Sub Payment Plan Code" <> '' THEN BEGIN
                    AppChargeCode.RESET;
                    AppChargeCode.SETFILTER(Code, '<>%1', Code);
                    AppChargeCode.SETFILTER("Sub Sub Payment Plan Code", '<>%1', '');
                    IF AppChargeCode.FINDSET THEN
                        REPEAT
                            IF AppChargeCode."Sub Sub Payment Plan Code" = "Sub Sub Payment Plan Code" THEN
                                ERROR('This Sub Sub Payment Plan Code already assigned in another entry');
                        UNTIL AppChargeCode.NEXT = 0;
                END;
            end;
        }
        field(50004; "Show Payment Plan on Receipt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

