tableextension 97027 "EPC Company Information Ext" extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "Send SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 130713';

            trigger OnValidate()
            begin
                /*
                CompanyAccount.RESET;
                CompanyAccount.SETRANGE(CompanyAccount."MSC Company",TRUE);
                IF CompanyAccount.FINDFIRST THEN BEGIN
                  IF CompanyAccount."Company Code" = COMPANYNAME THEN BEGIN
                    RecCompany.RESET;
                    IF RecCompany.FINDSET THEN
                      REPEAT
                        RecCompinfo.RESET;
                        RecCompinfo.CHANGECOMPANY(RecCompany.Name);
                        IF RecCompinfo.FINDFIRST THEN BEGIN
                          RecCompinfo."Send SMS" := FALSE;
                          RecCompinfo.MODIFY;
                        END;
                      UNTIL RecCompany.NEXT =0;
                  END;
                END;
                 */

            end;
        }
        field(50001; "Job Madetory On MRN"; Boolean)
        {
            Caption = 'Job Madetory On MRN';
            DataClassification = ToBeClassified;
            Description = 'AlleDK 020909';
        }
        field(50356; "Send Welcome Customer Letter"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50338; "Development Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Company;

            trigger OnValidate()
            begin
                IF UserSetup.GET(USERID) THEN BEGIN
                    IF NOT UserSetup."Development Company Change" THEN
                        ERROR('Contact Admin Department');


                END;
            end;
        }
        field(50009; "Back Page Picture"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50007; "Header Picture"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50008; "Footer Picture"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50011; "Company Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Company Branch Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Company Bank IFSC Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50337; "Send mail for mobile login"; Boolean)
        {
            DataClassification = ToBeClassified;
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
        UserSetup: Record "User Setup";
}