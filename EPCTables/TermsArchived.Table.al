table 97762 "Terms Archived"
{
    // NDALLE 051207

    DrillDownPageID = "Terms list Archived";
    LookupPageID = "Terms list Archived";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[30])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Term Type"; Option)
        {
            OptionCaption = ',Sales Tax Comments,Excise Duty Comments,Terms of Payments,Service Tax,Transit Insurance,Inspection Remarks,Packaging & Forwarding,Price Basis,Freight Terms,DD Comm/Bank Charges,Warranty/Guarantee Terms,Entry Tax/Octroi Terms,Installation Terms,Service Tax-Installation';
            OptionMembers = ,"Sales Tax Comments","Excise Duty Comments","Terms of Payments","Service Tax","Transit Insurance","Inspection Remarks","Packaging & Forwarding","Price Basis","Freight Terms","DD Comm/Bank Charges","Warranty/Guarantee Terms","Entry Tax/Octroi Terms","Installation Terms","Service Tax-Installation";
        }
        field(5; Narration; Text[250])
        {

            trigger OnLookup()
            begin
                st.RESET;
                st.SETRANGE(st."BBG Term Type", "Term Type");
                IF PAGE.RUNMODAL(Page::"Standard Text Codes", st) = ACTION::LookupOK THEN
                    Narration := Narration + ' ' + st.Description;
            end;
        }
        field(6; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Term Type", "Line No.", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        st: Record "Standard Text";
}

