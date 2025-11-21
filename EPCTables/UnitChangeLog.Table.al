table 97801 "Unit Change Log"
{

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(4; "Change Type"; Option)
        {
            Caption = 'Change Type';
            OptionCaption = 'Scheme,Investment Frequency,Return Frequency,Return Payment Mode,Bond Holder,Co Bond Holder,Marketing Member,Business Transfer';
            OptionMembers = Scheme,"Investment Frequency","Return Frequency","Return Payment Mode","Bond Holder","Co Bond Holder","Marketing Member","Business Transfer";
        }
        field(5; "Old Value"; Text[50])
        {
            Caption = 'Old Value';
        }
        field(6; "New Value"; Text[50])
        {
            Caption = 'New Value';
        }
        field(7; "Print Allowed"; Boolean)
        {
            Caption = 'Print Allowed';
            Description = 'Certificate Print';
        }
        field(8; Date; Date)
        {
        }
        field(9; Time; Time)
        {
        }
        field(10; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
        field(11; "Authorization Date"; Date)
        {
            Caption = 'Posting Date';
            Description = 'Caption changed to Posting Date';
        }
        field(12; Authorizer; Text[30])
        {
        }
        field(13; Remarks; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Unit No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetValueDescription(ChangeType: Option Scheme,"Investment Frequency","Return Frequency","Return Payment Mode","Bond Holder","Co Bond Holder","Marketing Member","Business Transfer"; ValueCode: Code[50]): Text[50]
    var
        GetDesc: Codeunit GetDescription;
        ValueInt: Integer;
        OK: Boolean;
    begin
        IF ChangeType IN [ChangeType::"Investment Frequency", ChangeType::"Return Frequency"] THEN BEGIN
            OK := EVALUATE(ValueInt, ValueCode);
            IF OK THEN
                EXIT(GetDesc.GetFrequencyDesc(ValueInt));
        END;

        IF ChangeType = ChangeType::"Return Payment Mode" THEN BEGIN
            OK := EVALUATE(ValueInt, ValueCode);
            IF OK THEN BEGIN
                //ValueInt += 1;
                EXIT(GetDesc.GetPaymentModeDesc(ValueInt));
            END;
        END;

        IF ChangeType IN [ChangeType::"Bond Holder", ChangeType::"Co Bond Holder"] THEN
            EXIT(GetDesc.GetCustomerName(ValueCode));

        IF ChangeType = ChangeType::"Marketing Member" THEN
            EXIT(GetDesc.GetVendorName(ValueCode));
    end;
}

