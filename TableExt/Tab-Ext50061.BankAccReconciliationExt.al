tableextension 50061 "BBG Bank Acc. Reconction Ext" extends "Bank Acc. Reconciliation"
{
    fields
    {
        // Add changes to table fields here
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

    trigger OnAfterInsert()
    begin
        COMMIT; //281021
    end;
}