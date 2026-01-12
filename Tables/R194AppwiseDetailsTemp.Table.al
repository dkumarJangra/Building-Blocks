table 50459 "R194 Appl. wiseReport Data"
{


    DataPerCompany = false;


    fields
    {
        field(1; "Entry No."; Integer)
        {

        }
        field(2; "Application No."; Text[200])
        {

        }
        field(3; "DOJ"; Date)
        {
        }
        field(4; "Item Issued"; Boolean)
        {
        }
        field(5; "Item No."; Code[20])
        {
        }
        field(6; "Item Description"; Text[100])
        {
        }
        field(7; "Actual Extent"; Decimal)
        {
        }
        field(8; "Eleg. Extent"; Decimal)
        {
        }
        field(9; "Issued Amount"; Decimal)
        {
        }
        field(10; "Issued Comulative"; Decimal)
        {
        }
        field(11; "Average Comulative"; Decimal)
        {
        }

        field(12; "A"; Decimal)
        {
        }
        field(13; "B"; Decimal)
        {
        }
        field(14; "C"; Decimal)
        {
        }
        field(15; "D"; Decimal)
        {
        }
        field(16; "E"; Decimal)
        {
        }
        field(17; "F"; Decimal)
        {
        }
        field(18; "G"; Decimal)
        {
        }
        field(19; "H"; Decimal)
        {
        }
        field(20; "I"; Decimal)
        {
        }
        field(21; "Gift Issue Date"; Date)
        {
        }
        field(22; "Company Name"; Text[30])
        {
            Editable = false;
        }

        field(23; "Issued Date"; Date)
        {
            Editable = false;
        }

        field(24; "Issued By"; Code[50])
        {
            Editable = false;
        }
        field(25; "Associate No."; Code[20])
        {

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

