table 97722 "Document Type Initiator"
{
    // //ALLESR-191107 : Field added
    // //ALLEAB003:  Added New Field for TO Receiving User Code
    // //ALLEAB013 Added New field & added also in Key
    // //ALLEAB: Added new option for Sub Document Type ,FA,Man Power,Leave,Travel,Others

    DrillDownPageID = "Document Type Setup";
    LookupPageID = "Document Type Setup";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Indent,Purchase Order,Purchase Order Amendment,GRN,Invoice,Leave,OD,Sale Order,Debit Note,Transfer Order,Credit Memo,Award Note,Job,Job Amendment,Enquiry,Service Invoice,Quote,Contract Quote,Sale quote,Sales Order Amendment';
            OptionMembers = Indent,"Purchase Order","Purchase Order Amendment",GRN,Invoice,Leave,OD,"Sale Order","Debit Note","Transfer Order","Credit Memo","Award Note",Job,"Job Amendment",Enquiry,"Service Invoice",Quote,"Contract Quote","Sale quote","Sales Order Amendment";
        }
        field(2; "Sub Document Type"; Option)
        {
            Description = 'ALLEAB';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO,GRN for PO,GRN for JSPL,GRN for Packages,GRN for Fabricated Material for WO,JES for WO,GRN-Direct Purchase,Freight Advice,Order,Invoice,Direct TO,Regular TO,Quote,FA,Man Power,Leave,Travel,Others,FA Sale,Hire';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice,"Direct TO","Regular TO",Quote,FA,"Man Power",Leave,Travel,Others,"FA Sale",Hire;
        }
        field(3; "User Code"; Code[20])
        {
            TableRelation = User;

            trigger OnValidate()
            begin
                //ALLESR-191107 >>

                IF "User Code" <> '' THEN BEGIN
                    IF UserSetup.GET("User Code") THEN
                        "User Responsibility Center" := UserSetup."Responsibility Center"
                    ELSE
                        "User Responsibility Center" := '';
                END ELSE
                    "User Responsibility Center" := '';
                //ALLESR-191107 <<
            end;
        }
        field(4; "Posting User Code"; Code[20])
        {
            TableRelation = User;

            trigger OnValidate()
            begin
                //ALLESR-191107 >>
                IF "Posting User Code" <> '' THEN BEGIN
                    IF UserSetup.GET("Posting User Code") THEN
                        "PostUser Responsibility Center" := UserSetup."Responsibility Center"
                    ELSE
                        "PostUser Responsibility Center" := '';
                END ELSE
                    "PostUser Responsibility Center" := '';
                //ALLESR-191107 <<
            end;
        }
        field(5; "CC Mail - User Code"; Code[20])
        {
            TableRelation = User;

            trigger OnValidate()
            begin
                //ALLESR-191107 >>
                IF "CC Mail - User Code" <> '' THEN BEGIN
                    IF UserSetup.GET("CC Mail - User Code") THEN
                        "CC User Responsibility Center" := UserSetup."Responsibility Center"
                    ELSE
                        "CC User Responsibility Center" := '';
                END ELSE
                    "CC User Responsibility Center" := '';
                //ALLESR-191107 <<
            end;
        }
        field(6; "User Responsibility Center"; Code[10])
        {
            Caption = 'User Responsibility Center';
            Description = 'ALLESR-191107 : Field added';
            Editable = true;
            TableRelation = "Responsibility Center 1";
        }
        field(7; "PostUser Responsibility Center"; Code[10])
        {
            Caption = 'Posting User Responsibility Center';
            Description = 'ALLESR-191107 : Field added';
            Editable = false;
            TableRelation = "Responsibility Center 1";
        }
        field(8; "CC User Responsibility Center"; Code[10])
        {
            Caption = 'CC Mail - User Responsibility Center';
            Description = 'ALLESR-191107 : Field added';
            Editable = false;
            TableRelation = "Responsibility Center 1";
        }
        field(9; "TO Receive USER Code"; Code[20])
        {
            Description = 'ALLEAB003';
            TableRelation = User;

            trigger OnValidate()
            begin
                IF "TO Receive USER Code" <> '' THEN BEGIN
                    IF User.GET("TO Receive USER Code") THEN
                        "TO Receive USER Name" := User."User Name";
                END;
            end;
        }
        field(10; "Key Responsibility Center"; Code[10])
        {
            Description = 'ALLEAB013';
            Editable = true;
            TableRelation = IF ("Document Type" = CONST("Transfer Order")) "Responsibility Center";
        }
        field(11; "TO Receive USER Name"; Text[50])
        {
            Description = 'added by DDS';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Sub Document Type", "User Code", "Key Responsibility Center")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserSetup: Record "User Setup";
        User: Record User;
}

