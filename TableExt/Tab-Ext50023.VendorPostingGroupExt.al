tableextension 50023 "BBG Vendor Posting Group Ext" extends "Vendor Posting Group"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Advance Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Travel Advance,Salary Advance,LTA Advance,Other Advance,Amex Corporate Card';
            OptionMembers = " ",Travel,Salary,LTA,Other,Amex;

            trigger OnValidate()
            begin
                VendPostingGrp.RESET;
                VendPostingGrp.SETFILTER(VendPostingGrp.Code, '<>%1', Code);
                VendPostingGrp.SETRANGE(VendPostingGrp."Advance Type", "Advance Type");
                IF (VendPostingGrp.FIND('-')) AND ("Advance Type" <> 0) THEN
                    ERROR('There can be only one account mapped with an Advance Type');
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
        VendPostingGrp: Record "Vendor Posting Group";
}