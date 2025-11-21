codeunit 97771 "Check Mobile No for SMS"
{

    trigger OnRun()
    begin

        //CheckMobileNo('8888888788',TRUE);
    end;

    var
        pos: Integer;
        IsCharacter: Boolean;
        result: Text;
        MobileValid: Boolean;
        StartMobileNo: Text;


    procedure CheckMobileNo(MobileNo_: Text; ShowError: Boolean): Boolean
    var
        MobileNoLength: Integer;
    begin
        MobileValid := FALSE;
        pos := 0;
        IF MobileNo_ <> '' THEN BEGIN
            StartMobileNo := COPYSTR(MobileNo_, 1, 1);
            IF (StartMobileNo = '0') OR (StartMobileNo = '1') OR (StartMobileNo = '2') OR (StartMobileNo = '3') OR (StartMobileNo = '4') OR (StartMobileNo = '5') THEN BEGIN
                IF ShowError THEN
                    MESSAGE('Mobile No. not correct');
                EXIT(FALSE);
            END;
            pos := 1;
            WHILE (pos <= STRLEN(MobileNo_)) DO BEGIN
                IsCharacter := MobileNo_[pos] IN ['A' .. 'Z'];
                IF NOT IsCharacter THEN
                    IsCharacter := MobileNo_[pos] IN ['a' .. 'z'];
                IF IsCharacter THEN BEGIN
                    IF ShowError THEN
                        ERROR('Enter the correct mobile No.');
                    MobileValid := FALSE;
                    EXIT(MobileValid);
                END;
                pos += 1;
            END;

            MobileNoLength := STRLEN(MobileNo_);
            IF MobileNoLength = 10 THEN BEGIN
                IF (MobileNo_ = '1111111111') OR (MobileNo_ = '2222222222') OR (MobileNo_ = '3333333333') OR (MobileNo_ = '4444444444') OR
                  (MobileNo_ = '5555555555') OR (MobileNo_ = '6666666666') OR (MobileNo_ = '7777777777') OR (MobileNo_ = '8888888888') OR (MobileNo_ = '9999999999') THEN BEGIN
                    IF ShowError THEN
                        ERROR('Enter the correct mobile No.');
                    EXIT(FALSE);
                END;
                MobileValid := TRUE;
                EXIT(MobileValid);
            END ELSE BEGIN
                IF ShowError THEN
                    ERROR('Enter the correct mobile No.');
                EXIT(MobileValid);
            END;

        END;
    end;
}

