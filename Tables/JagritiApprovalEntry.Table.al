table 60705 "Jagriti Approval Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Ref. Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Request Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,GOLD / SILVER,CHANGE OF PAYMENT OPTION,RE-ALLOT / CHANGE OF PLOT,FUND TRANSFER,PLOT CANCELLATION / REFUND,CUSTOMER CORRECTIONS / RECTIFICATIONS,PLOT REGISTRATION,SITE DEVELOPMENT,IBA Enquiry,Associate ID Activation,Sales ID Change,Associate Bank Update,Enquiry,Bonanza,OTHER,LINK DOCUMENTS REQUEST,Special Plot Change,Special Option Change,Special Gold/Silver,Special Loan Files Price Update,Project Price Change,Unit Price Change';
            OptionMembers = " ","GOLD / SILVER","CHANGE OF PAYMENT OPTION","RE-ALLOT / CHANGE OF PLOT","FUND TRANSFER","PLOT CANCELLATION / REFUND","CUSTOMER CORRECTIONS / RECTIFICATIONS","PLOT REGISTRATION","SITE DEVELOPMENT","IBA Enquiry","Associate ID Activation","Sales ID Change","Associate Bank Update",Enquiry,Bonanza,OTHER,"LINK DOCUMENTS REQUEST","Special Plot Change","Special Option Change","Special Gold/Silver","Special Loan Files Price Update","Project Price Change","Unit Price Change";
        }
        field(4; "Approver ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Approver Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Approved / Rejected Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Approved / Rejected time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Associate ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Associate Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Time Sent for Approval"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Date Sent for Approval"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending,Approved,Rejected';
            OptionMembers = Pending,Approved,Rejected;
        }
        field(13; "Form Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,AssociateForm,CustomerForm,SpecialRequest';
            OptionMembers = " ",AssociateForm,CustomerForm,SpecialRequest;
        }
        field(14; "Status Comment"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "From Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "To Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "No. of Team Bonanza"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Extent Value"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Site Code"; Option)
        {
            Caption = 'Branch Office';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,South-HYD,East-HYD,West-HYD,VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,Mahabub Nagar';
            OptionMembers = " ","South-HYD","East-HYD","West-HYD",VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,"Mahabub Nagar";
        }
        field(34; "Mail Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Mail Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Mail Sent Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Mail Sent Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(39; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(41; "Requester ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Approved By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(43; "Status Comment 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Status Comment 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Status Comment 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        Field(46; "Ref. Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        Field(47; "Re-Open Document"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }

        Field(48; "Re-Open Document DT."; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }

        field(50; "Final Proj/Unit Price approver"; Code[50])
        {
            Editable = False;

        }

        field(51; "Allow Entry for Approval"; Boolean)
        {
            Editable = False;

        }
        Field(52; "Project Name"; Text[100])
        {
            Editable = False;

        }
        Field(53; "Project Id"; Code[20])
        {
            Editable = False;
        }



    }


    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Form Type", "Document Type", "Approver ID")
        {
        }
    }

    fieldgroups
    {
    }

}

