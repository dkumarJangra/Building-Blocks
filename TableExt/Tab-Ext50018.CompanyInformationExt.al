tableextension 50018 "BBG Company Information Ext" extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1".Code;
        }
        field(50000; "Address 3"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'dds -added for additonal address';
        }

        field(50002; "JV Fields Mandetory"; Boolean)
        {
            Caption = 'JV Fields Mandetory';
            DataClassification = ToBeClassified;
            Description = 'ALLE 141209';
        }
        field(50003; "Gold Coin Lable"; BLOB)
        {
            Caption = 'Gold Coin Lable';
            DataClassification = ToBeClassified;
            Description = 'ALLECK 301212';
            SubType = Bitmap;
        }
        field(50004; "Gold Coin Lable2"; BLOB)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLECK 190313';
        }

        field(50006; "SMS Password"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 180714';
        }



        field(50010; "Run Commission Batch"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETRANGE("Role ID", 'RUNCOMM');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('YOU ARE NOT AUTHORISED');
            end;
        }



        field(50021; "Single Plot Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Double Plot Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50332; "Online Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(50333; "Commission Threshold Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50334; "Incentive Threshold Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50335; "Pmt. Threshold Time In Minutes"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50336; "Payment E_Mail Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }


        field(50339; "Company Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Development Company,Sale and Development Company';
            OptionMembers = " ","Development Company","Sale and Development Company";

            trigger OnValidate()
            var
                CompanywiseGLAccount: Record "Company wise G/L Account";
            begin
                IF "Company Type" = "Company Type"::"Development Company" THEN BEGIN
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Development Company", TRUE);
                    IF CompanywiseGLAccount.FINDFIRST THEN
                        "Development Company Name" := CompanywiseGLAccount."Company Code";
                END ELSE IF "Company Type" = "Company Type"::"Sale and Development Company" THEN BEGIN
                    "Development Company Name" := COMPANYNAME;
                END;
            end;
        }
        field(50353; "Start Day for Onboarding"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "End Day for Onboarding" <> 0 THEN
                    IF "Start Day for Onboarding" > "End Day for Onboarding" THEN
                        ERROR('Start Day can not be greater than End Day');
            end;
        }
        field(50354; "End Day for Onboarding"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "End Day for Onboarding" <> 0 THEN BEGIN
                    TESTFIELD("Start Day for Onboarding");

                    IF "Start Day for Onboarding" > "End Day for Onboarding" THEN
                        ERROR('Start Day can not be greater than End Day');

                    IF "End Day for Onboarding" > 31 THEN
                        ERROR('End Day can not be greater than 31');
                END;

            end;
        }
        field(50355; "Welcome Customer Letter"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }

        field(50357; "Send Customer Cheque BounceSMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50358; "Send LandVend Helpdesk Email"; Boolean)  //251124 
        {
            DataClassification = ToBeClassified;
        }

        field(50359; "Send New Land Request Email"; Boolean)  //251124
        {
            DataClassification = ToBeClassified;
        }
        field(50360; "BBG IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
        }

        field(50361; "Stop Data Push to WebApp"; Boolean)
        {
            Caption = 'Stop Data Push to WebApp or Third party';

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
        Memberof: Record "Access Control";
        UserSetup: Record "User Setup";
        CompanywiseGLAccount: Record "Company wise G/L Account";
}