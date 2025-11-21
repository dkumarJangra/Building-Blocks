table 97813 "Travel Advance Entry"
{
    Caption = 'Travel Advance Entry';

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
        }
        field(2; "Order Ref. No."; Code[20])
        {
        }
        field(3; Rank; Integer)
        {
        }
        field(4; Name; Text[30])
        {
        }
        field(5; Rate; Decimal)
        {
        }
        field(6; "Comm. Amt."; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Associate Code", "Order Ref. No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        UpdateBond;
    end;

    trigger OnInsert()
    begin
        ERROR('');
    end;


    procedure UpdateBond()
    var
        ConfirmedBond: Record "Confirmed Order";
        TravelAdvEntry: Record "Travel Advance Entry";
    begin
        TravelAdvEntry.RESET;
        TravelAdvEntry.SETCURRENTKEY("Associate Code", "Order Ref. No.");
        TravelAdvEntry.SETRANGE("Order Ref. No.", "Order Ref. No.");
        IF TravelAdvEntry.ISEMPTY THEN BEGIN
            ConfirmedBond.RESET;
            IF ConfirmedBond.GET("Order Ref. No.") THEN BEGIN
                ConfirmedBond."Travel Calculated" := FALSE;
                ConfirmedBond.MODIFY;
            END;
        END;
    end;
}

