tableextension 50002 "BBG Location Ext" extends Location
{
    fields
    {
        // Add changes to table fields here
        field(50000; "BBG Address 3"; Text[30])
        {
            Caption = 'Address 3';
            DataClassification = ToBeClassified;
            Description = 'dds- added for additional address';
        }
        field(50001; "BBG Registered"; Boolean)
        {
            Caption = 'Registered';
            DataClassification = ToBeClassified;
            Description = 'ALLESR-231107';

            trigger OnValidate()
            begin
                IF "BBG Registered" THEN BEGIN
                    recLocation.RESET;
                    recLocation.SETRANGE("BBG Registered", TRUE);
                    IF recLocation.FINDFIRST THEN
                        ERROR(Text013, recLocation.Name);
                END
            end;
        }
        field(50002; "BBG Use As Main Store Location"; Boolean)
        {
            Caption = 'Use As Main Store Location';
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
        }

        field(50006; "BBG Food Court Location"; Boolean)
        {
            Caption = 'Food Court Location';
            DataClassification = ToBeClassified;
        }
        field(60000; "BBG Regional Office"; Code[10])
        {
            Caption = 'Regional Office';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Location;
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
        recLocation: Record Location;
        Text013: Label 'You cannot delete %1 because there are one or more ledger entries on this location.';

    trigger OnAfterModify()
    var
        Company: Record Company;
        v_Location: Record Location;
    begin
        //Migretion Code ALLE-AM
        //    Company.RESET;
        //    Company.SETFILTER(Name,'<>%1',COMPANYNAME);
        //    IF Company.FINDSET THEN
        //      REPEAT
        //        v_Location.RESET;
        //        v_Location.CHANGECOMPANY(Company.Name);
        //        IF v_Location.GET(Code) THEN BEGIN
        //          v_Location.TRANSFERFIELDS(Rec);
        //          v_Location.MODIFY;
        //          COMMIT;
        //        END;
        //      UNTIL Company.NEXT =0;
        //Migretion Code ALLE-AM
    end;
}
