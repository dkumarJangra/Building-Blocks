table 97739 "PO Terms & Conditions"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(70010; "Sales Tax Comments"; Text[230])
        {
        }
        field(70011; "Excise Duty Comments"; Text[230])
        {
        }
        field(70012; "Terms of Payments"; Text[230])
        {
        }
        field(70013; "Service Tax"; Text[230])
        {
        }
        field(70014; "Transit Insurance"; Text[230])
        {
        }
        field(70015; "Inspection Remarks"; Text[230])
        {
        }
        field(70016; "Packaging & Forwarding"; Text[230])
        {
        }
        field(70017; "Price Basis"; Text[230])
        {
        }
        field(70018; "Freight Terms"; Text[230])
        {
        }
        field(70019; "DD Comm/Bank Charges"; Text[230])
        {
        }
        field(70020; "Warranty/Guarantee Terms"; Text[230])
        {
        }
        field(70021; "Entry Tax/Octroi Terms"; Text[230])
        {
        }
        field(70022; "Installation Terms"; Text[230])
        {
        }
        field(70023; "Service Tax-Installation"; Text[230])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

