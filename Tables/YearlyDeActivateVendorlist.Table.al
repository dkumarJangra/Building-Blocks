table 60805 "Yearly De-Activate Vendor list"
{
    // version NAVW19.00.00.52055,NAVIN9.00.00.52055,TDS-REGEF-194Q

    Caption = 'Pre- De-activate Vendors';
    DataCaptionFields = "No.", Name;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            var
                v_RegionwiseVendor: Record "Region wise vendor";
            begin
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(21; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'County';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(13706; "T.I.N. No."; Code[11])
        {
            Caption = 'T.I.N. No.';
        }
        field(13712; "P.A.N. No."; Code[20])
        {
            Caption = 'P.A.N. No.';
        }
        field(13717; "State Code"; Code[10])
        {
            Caption = 'State Code';
            TableRelation = State;
        }
        field(13718; "Excise Bus. Posting Group"; Code[10])
        {
            Caption = 'Excise Bus. Posting Group';
            // TableRelation = "Excise Bus. Posting Group";
        }
        field(16500; "P.A.N. Reference No."; Code[20])
        {
            Caption = 'P.A.N. Reference No.';
        }
        field(16501; "P.A.N. Status"; Option)
        {
            Caption = 'P.A.N. Status';
            OptionCaption = ' ,PANAPPLIED,PANINVALID,PANNOTAVBL';
            OptionMembers = " ",PANAPPLIED,PANINVALID,PANNOTAVBL;
        }
        field(50007; "Address 3"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50009; "Phone No. 2"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50010; "Mob. No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';

            trigger OnValidate()
            var
                OldVendor: Record "Vendor";
            begin
            end;
        }
        field(50012; "Vendor Category"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,Supplier,Consultant,Sub-Contractor,Transporter,Other Vendor,IBA(Associates),Land Owners,Contractor,Land Vendor';
            OptionMembers = " ",Supplier,Consultant,"Sub-Contractor",Transporter,"Other Vendor","IBA(Associates)","Land Owners",Contractor,"Land Vendor";
        }
        field(50018; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 040712';
            Editable = false;
        }
        field(50031; "Vendor Card Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(50103; "Cluster Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Hyderabad,Vizag,Vijaywada,Shadnagar,Yadagiri Gutta,Nellore,Srikakulam';
            OptionMembers = " ",Hyderabad,Vizag,Vijaywada,Shadnagar,"Yadagiri Gutta",Nellore,Srikakulam;
        }
        field(50106; "Cluster Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Reporting Office Master";
        }
        field(50304; "Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Team Master";
        }
        field(50305; "Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Leader Master";
        }
        field(50306; "Sub Team Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Team Master";
        }
        field(90033; "Date of Joining"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(91230; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Black List,Delete';
            OptionMembers = " ","Black List",Delete;
        }
        field(91231; Selected; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(91232; "Batch Run Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(91233; "Batch Run By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(91234; "Batch Run Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(91235; "Sent SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Vendor Posting Group")
        {
        }
        key(Key4; Name)
        {
        }
        key(Key5; City)
        {
        }
        key(Key6; "Post Code")
        {
        }
        key(Key7; "Phone No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, City, "Post Code", "Phone No.")
        {
        }

    }

}

