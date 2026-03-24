tableextension 50118 "TDS JournalLine Ext" extends "TDS Journal Line"
{
    fields
    {
        // Add changes to table fields here

        field(50001; "BBG Posting Type"; Option)
        {
            Caption = 'Posting Type';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",,Incentive,CommAndTA;
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
        GLAc: Record "G/L Account";
        BankAcc: Record "Bank Account";
}