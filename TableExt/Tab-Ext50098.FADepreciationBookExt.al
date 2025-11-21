tableextension 50098 "BBG FA Depreciation Book Ext" extends "FA Depreciation Book"
{
    fields
    {
        // Add changes to table fields here
        modify("FA Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                //alleab to check FA subclass code
                FA.GET("FA No.");
                IF UPPERCASE("FA Posting Group") <> UPPERCASE(FA."FA Subclass Code") THEN
                    ERROR('Please check FA Posting Group Should be FA Sub Class code');
                //alleab
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
}