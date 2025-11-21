tableextension 50010 "BBG Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }

        field(50006; "Indent No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Header"."Document No." WHERE("Document Type" = FILTER(Indent),
                                                                            Approved = FILTER(true));
        }
        field(50007; "Indent Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Line"."Line No." WHERE("Document Type" = FILTER(Indent),
                                                                      "Document No." = FIELD("Indent No"),
                                                                      Approved = FILTER(true));

            trigger OnLookup()
            var
                POLineRec: Record "Purchase Line";
            begin
            end;
        }
        field(50008; "Return Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'SC Added--JPL';
        }

        field(50015; "Reference No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50019; "Mfg/sold Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Ver001';
            Editable = true;
        }

        field(50021; "Application Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 161012';
        }
        field(50028; "BBG Product Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(80000; Capacity; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab-Fa';
        }
        field(80001; "FA SubClass Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab-Fa';
        }
        field(80002; "FA Sub Group"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab-Fa';
        }
        field(80010; "Item-FA"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab-Fa';
        }
        field(80011; Leased; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDDS01June - added by dds for leased FA';
            Editable = false;
        }
        field(80012; "Item-FA Code"; Code[10])
        {
            Caption = 'Item-FA Code';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            Editable = false;
            TableRelation = "Fixed Asset Sub Group"."FA Code";
        }
        field(80013; "Fixed Asset No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }

        field(80031; "Land Agreement No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80032; "Land Agreement Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80033; "R194_Application No."; Text[500])
        {
            DataClassification = ToBeClassified;
            Editable = false;

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