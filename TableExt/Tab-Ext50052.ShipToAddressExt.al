tableextension 50052 "BBG Ship-To Address Ext" extends "Ship-to Address"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'added by DDS for alt cust shipment loc and cals sales tax';
            TableRelation = State.Code;
        }
        field(50001; "T.I.N. No."; Code[11])
        {
            Caption = 'T.I.N. No.';
            DataClassification = ToBeClassified;
            Description = 'added by DDS';

            trigger OnValidate()
            begin
                /* //AlleBLK
                
                IF (STRLEN("T.I.N. No.") < 11) AND ("T.I.N. No." <> '') THEN
                  ERROR(Text16501);
                
                IF state.GET("State Code") THEN BEGIN
                  IF (COPYSTR((state."State Code for TIN"),1,2) <> COPYSTR(("T.I.N. No."),1,2)) AND  ("T.I.N. No." <> '')THEN
                    ERROR('The T.I.N. no. for the state %1 should be start with %2',"State Code",COPYSTR((state."State Code for TIN"),1,2));
                END;
                 */

            end;
        }
        field(50002; "Phone No. 2"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'added by DDS';
        }
        field(50003; "Mob No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'added by DDS';
        }
        field(50004; "Address 3"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'added by DDS';
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
}