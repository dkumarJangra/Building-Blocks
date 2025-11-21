table 60661 "Food Court Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));
        }
        field(3; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(5; "Location Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(6; "Coupon Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Coupon Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Team Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Food Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Coupon Req. Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Requested Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Actual Coupon Availed"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Fullfillment of Coupons" := "Requested Quantity" - "Actual Coupon Availed";
            end;
        }
        field(13; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Associate Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Coupon Name ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Coupon Name Master";
        }
        field(16; "Coupon Type ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Coupon Type Master";
        }
        field(17; "Food Type ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Food Type Master";
        }
        field(18; "Team Name ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Food Team Master";
        }
        field(19; "Fullfillment of Coupons"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Other Location Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

