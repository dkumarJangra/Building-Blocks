table 60713 "Customer Coupon Details"
{
    DataCaptionFields = "No.";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Introducer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,,,,,,,,,,,,Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Booking Coupon"; Code[12])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckDuplicateCouponCode("Booking Coupon");
                IF ((Rec."Booking Coupon" = Rec."Allotment Coupon") OR (Rec."Booking Coupon" = Rec."Registration Coupon")) THEN
                    ERROR(CouponExistErr, Rec."No.", Rec."Line No.");
                //     "Creation Date" := TODAY;
                //      "Creation Time" := TIME;

            end;
        }
        field(10; "Allotment Coupon"; Code[12])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckDuplicateCouponCode("Allotment Coupon");
                IF ((Rec."Allotment Coupon" = Rec."Booking Coupon") OR (Rec."Allotment Coupon" = Rec."Registration Coupon")) THEN
                    ERROR(CouponExistErr, Rec."No.", Rec."Line No.");
                //    "Creation Date" := TODAY;
                //     "Creation Time" := TIME;

            end;
        }
        field(11; "Registration Coupon"; Code[12])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckDuplicateCouponCode("Registration Coupon");
                IF ((Rec."Registration Coupon" = Rec."Booking Coupon") OR (Rec."Registration Coupon" = Rec."Allotment Coupon")) THEN
                    ERROR(CouponExistErr, Rec."No.", Rec."Line No.");
                //  "Creation Date" := TODAY;
                //    "Creation Time" := TIME;

            end;
        }
        field(12; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Update Customer Coupon" THEN
            ERROR('You are not allowed to delete. Contact admin');
    end;

    trigger OnInsert()
    begin

        IF "No." <> '' THEN
            IF NewConfirmedOrder.GET("No.") THEN BEGIN
                "Customer No." := NewConfirmedOrder."Customer No.";
                "Introducer Code" := NewConfirmedOrder."Introducer Code";
                "Shortcut Dimension 1 Code" := NewConfirmedOrder."Shortcut Dimension 1 Code";
                Status := NewConfirmedOrder.Status;
                Amount := NewConfirmedOrder.Amount;
                "Posting Date" := NewConfirmedOrder."Posting Date";
                "Document Date" := NewConfirmedOrder."Document Date";
                "Creation Date" := TODAY;
                "Creation Time" := TIME;

            END;
    end;

    var
        NewConfirmedOrder: Record "New Confirmed Order";
        CouponExistErr: Label 'Coupon code already exists in Application No. %1 , Line No. %2. ';
        UserSetup: Record "User Setup";

    local procedure CheckDuplicateCouponCode(CoupounCode: Code[20])
    var
        LocalCustomerCouponDetails: Record "Customer Coupon Details";
        String: Integer;
    begin
        IF CoupounCode <> '' THEN BEGIN
            String := STRLEN(CoupounCode);
            IF String < 12 THEN
                ERROR('Coupon can not be less than 12 character.');
            LocalCustomerCouponDetails.SETFILTER("No.", '<>%1', Rec."No.");
            IF LocalCustomerCouponDetails.FINDSET THEN
                REPEAT
                    IF CoupounCode = LocalCustomerCouponDetails."Booking Coupon" THEN
                        ERROR(CouponExistErr, LocalCustomerCouponDetails."No.", LocalCustomerCouponDetails."Line No.");
                    IF CoupounCode = LocalCustomerCouponDetails."Allotment Coupon" THEN
                        ERROR(CouponExistErr, LocalCustomerCouponDetails."No.", LocalCustomerCouponDetails."Line No.");
                    IF CoupounCode = LocalCustomerCouponDetails."Registration Coupon" THEN
                        ERROR(CouponExistErr, LocalCustomerCouponDetails."No.", LocalCustomerCouponDetails."Line No.");
                UNTIL LocalCustomerCouponDetails.NEXT = 0;

            LocalCustomerCouponDetails.RESET;
            LocalCustomerCouponDetails.SETRANGE("No.", Rec."No.");
            LocalCustomerCouponDetails.SETFILTER("Line No.", '<>%1', Rec."Line No.");
            IF LocalCustomerCouponDetails.FINDSET THEN
                REPEAT
                    IF CoupounCode = LocalCustomerCouponDetails."Booking Coupon" THEN
                        ERROR(CouponExistErr, LocalCustomerCouponDetails."No.", LocalCustomerCouponDetails."Line No.");
                    IF CoupounCode = LocalCustomerCouponDetails."Allotment Coupon" THEN
                        ERROR(CouponExistErr, LocalCustomerCouponDetails."No.", LocalCustomerCouponDetails."Line No.");
                    IF CoupounCode = LocalCustomerCouponDetails."Registration Coupon" THEN
                        ERROR(CouponExistErr, LocalCustomerCouponDetails."No.", LocalCustomerCouponDetails."Line No.");
                UNTIL LocalCustomerCouponDetails.NEXT = 0;
        END;
    end;
}

