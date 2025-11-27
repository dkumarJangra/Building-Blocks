tableextension 50022 "BBG User Setup Ext" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50003; "Stop Back Date"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50004; "Back Date Margin Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }

        field(50006; "Certificate Print"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Dupl.Cert Print"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Rep. Cert Print"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Assn. cert print"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "ReAssn. cert print"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "TDS Report"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50013; "MM Joining"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; Reverse; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "MM Payable Management"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Voucher Reprint"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; Branch; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleCK';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('COLLCENTERS'));
        }
        field(50018; Multilogin; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Company.RESET;
                Company.SETFILTER(Name, '<>%1', COMPANYNAME);
                IF Company.FINDSET THEN
                    REPEAT
                        UserSetup.RESET;
                        UserSetup.CHANGECOMPANY(Company.Name);
                        UserSetup.SETRANGE("User ID", "User ID");
                        IF UserSetup.FINDFIRST THEN BEGIN
                            UserSetup.Multilogin := Multilogin;
                            UserSetup.MODIFY;
                        END;
                    UNTIL Company.NEXT = 0;
            end;
        }
        field(50100; "Flash LC/BG Message"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK For LC/BG Functionality';
        }
        field(50102; "Application Template BatchName"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50201; "Project Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50206; "Associate Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50207; "Associate Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50217; "Refund Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50218; "After Refund Rcpt Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }








        field(50228; "Vendor Delete Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50229; "Reserve Ass. Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50301; "Report ID - 50041 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50302; "Report ID - 50011 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50303; "Report ID - 97855 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50304; "Report ID - 97782 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50305; "Report ID - 97893 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50306; "Report ID - 97896 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50307; "Report ID - 50082 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50308; "Report ID - 50096 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50310; "Report ID - 50011 - Excel"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50312; "Report ID - 97782 - Excel"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50313; "Report ID - 50081 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50314; "Report ID - 50098 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50315; "Report ID - 50049 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50316; "Report ID - 50015 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50317; "Report ID - 97846 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50318; "Report ID - 50017 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50319; "Report ID - 97916 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50320; "Report ID - 97804 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50321; "Report ID - 50038 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50322; "Report ID - 50064 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50323; "Report ID - 50057 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50324; "Report ID - 97825 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50325; "Report ID - 97877 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50326; "Report ID - 16567 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50327; "Report ID - 50037 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50329; "Report ID - 97838 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50330; "Report ID - 50081 - Excel"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50331; "Report ID - 50049 - Excel"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50332; "Report ID - 97916 - Excel"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50334; "Report ID - 97877 - Excel"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50335; "Create Associate Manual"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50351; "Allow Plot Change From Mob.APP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50352; "Allow No.Series Delete"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50353; "Allow Users Modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }


        field(50356; "Allow Mobile App"; Boolean)
        {
            DataClassification = ToBeClassified;
        }


        field(50359; "Associate Payment Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }





        field(50367; "UTR No. Upload"; Boolean)
        {
            DataClassification = ToBeClassified;
        }






        field(50376; "Direct Refund"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50377; "Show Deactivate Associates"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50378; "Display Name in Jagriti"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50501; "Modify Comm/Refund Schedule"; Boolean)    //110525  added new field
        {
            Caption = 'Modify Commission/Refund Payment Schedule';
            DataClassification = ToBeClassified;
        }

        field(50502; "Asso/Cust. Notification Upload"; Boolean)    //110525  added new field
        {
            Caption = 'Associate/Customer Notification Upload';
            DataClassification = ToBeClassified;
        }

        field(50503; "Allow configurationPckg"; Boolean)    //110525  added new field
        {
            Caption = 'Allow configuration Package';
            Editable = false;
        }


        field(90000; "Branch Specific"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMSN01';
        }
        field(90001; "Default Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMSN01';

            trigger OnLookup()
            var
                GLSetup: Record "General Ledger Setup";
                DimValue: Record "Dimension Value";
            begin
                //ALLEMSN01 <<
                GLSetup.GET;
                DimValue.RESET;
                CASE GLSetup."Branch Is" OF
                    GLSetup."Branch Is"::"Global Dimension 1":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 1 Code");
                    GLSetup."Branch Is"::"Global Dimension 2":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 2 Code");
                    GLSetup."Branch Is"::"Shortcut Dimension 3":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    GLSetup."Branch Is"::"Shortcut Dimension 4":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                    GLSetup."Branch Is"::"Shortcut Dimension 5":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                    GLSetup."Branch Is"::"Shortcut Dimension 6":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                    GLSetup."Branch Is"::"Shortcut Dimension 7":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
                    GLSetup."Branch Is"::"Shortcut Dimension 8":
                        DimValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                END;

                IF PAGE.RUNMODAL(0, DimValue) = ACTION::LookupOK THEN
                    "Default Branch Code" := DimValue.Code;
                //ALLEMSN01 >>
            end;
        }


        field(51281; "Mail Printer Name"; Text[250])
        {
            Caption = 'Mail Printer Name';
            DataClassification = ToBeClassified;
        }
        field(51284; "Permission Group Code"; Code[20])
        {
            Caption = 'Permission Group Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // ALLE MM
                /*
                // WKFL.S
                IF NOT PermissionManagement.FunctionAdmissible('TEST PERMISSION',TRUE) THEN
                  ERROR(Text5128400,FIELDCAPTION("Permission Group Code"));
                // WKFL.E
                */
                // ALLE MM

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
        UserSetup: Record "User Setup";
        Company: Record Company;

    trigger OnAfterModify()
    var
        v_UserSetup: Record "User Setup";
    begin
        v_UserSetup.RESET;
        v_UserSetup.SETRANGE("User ID", USERID);
        v_UserSetup.SETRANGE(v_UserSetup."Allow User Setup Modify", TRUE);
        IF NOT v_UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;
}