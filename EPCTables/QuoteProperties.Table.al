table 97785 "Quote Properties"
{
    // ALLESP BCL0003 14-08-2007: New Table create to store information for Quote Comparison
    // ALLEMD BCL0003 17-09-2007: Added Two new Fields "Installation & Commissoning" and "Support"


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; Model; Text[30])
        {
        }
        field(5; "Horse Power"; Decimal)
        {
            MinValue = 0;
        }
        field(6; RPM; Decimal)
        {
            MinValue = 0;
        }
        field(7; "Fuel Consumption/Mileage"; Decimal)
        {
            MinValue = 0;
        }
        field(8; "Bucket/Blade Capacity"; Decimal)
        {
            MinValue = 0;
        }
        field(9; "Capacity/Power"; Decimal)
        {
            MinValue = 0;
        }
        field(10; Make; Text[30])
        {
        }
        field(11; "No. of Cylinders"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            MinValue = 0;
        }
        field(12; Transmission; Decimal)
        {
            MinValue = 0;
        }
        field(13; Cabin; Decimal)
        {
            DecimalPlaces = 0 : 0;
            MinValue = 0;
        }
        field(14; "Payload Capacity"; Decimal)
        {
            MinValue = 0;
        }
        field(16; "Warranty/Guarantee in Months"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            MinValue = 0;
        }
        field(17; "After Sales Service"; Text[50])
        {
        }
        field(18; "Other Specifications"; Text[50])
        {
        }
        field(19; "Transit Insurance"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(20; "Loading Charges"; Decimal)
        {
            MinValue = 0;
        }
        field(21; "Un-Loading Charges"; Decimal)
        {
            MinValue = 0;
        }
        field(24; "Delivery Period"; Text[30])
        {
        }
        field(25; "Custom Duty"; Decimal)
        {
        }
        field(26; CTC; Decimal)
        {
        }
        field(50000; "Operational Weight"; Decimal)
        {
            MinValue = 0;
        }
        field(50001; "Bending/Cutting Charges"; Decimal)
        {
            MinValue = 0;
        }
        field(50002; "Transportation Charges"; Decimal)
        {
            MinValue = 0;
        }
        field(50003; "Installation and Commissoning"; Code[10])
        {
        }
        field(50004; Support; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

