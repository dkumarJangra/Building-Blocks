tableextension 50053 "BBG Order Address Ext" extends "Order Address"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'added by DDS for alt vendor shipment loc and cals sales tax';
            TableRelation = State.Code;
        }
        field(50001; "T.I.N. No."; Code[11])
        {
            Caption = 'T.I.N. No.';
            DataClassification = ToBeClassified;
            Description = 'added by DDS';

            trigger OnValidate()
            begin
                IF (STRLEN("T.I.N. No.") < 11) AND ("T.I.N. No." <> '') THEN
                    ERROR(Text16501);

                IF state1.GET("State Code") THEN BEGIN
                    // IF (COPYSTR((state1."State Code for TIN"), 1, 2) <> COPYSTR(("T.I.N. No."), 1, 2)) AND ("T.I.N. No." <> '') THEN
                    //     ERROR('The T.I.N. no. for the state %1 should be start with %2', "State Code", COPYSTR((state1."State Code for TIN"), 1, 2));
                END;
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
        field(50005; "L.S.T. No."; Code[20])
        {
            Caption = 'L.S.T. No.';
            DataClassification = ToBeClassified;
        }
        field(50006; "C.S.T. No."; Code[20])
        {
            Caption = 'C.S.T. No.';
            DataClassification = ToBeClassified;
        }
        field(50007; "P.A.N. No."; Code[20])
        {
            Caption = 'P.A.N. No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF "P.A.N. No." <> xRec."P.A.N. No." THEN
                //  UpdateDedPAN;
            end;
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
        Text16501: Label 'ENU=T.I.N. no. should not be less then 11 characters.';
        state1: Record State;
}