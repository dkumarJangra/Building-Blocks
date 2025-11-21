table 97723 "Document Type Approval"
{
    // //ALLESR-191107 : Field added
    // ALLEAB013: Added New Field & Added in Key
    // ALLEAB: Added New Option Sub Document Type: ,FA,Man Power,Leave,Travel,Others
    // ALLEPG 300409 : Created key "Document Type,Document No,Initiator,Line No"


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
        field(3; Initiator; Code[20])
        {
            TableRelation = User;
        }
        field(4; "Line No"; Integer)
        {
        }
        field(5; "Approvar ID"; Code[20])
        {
            TableRelation = User;

            trigger OnValidate()
            begin
                //ALLESR-191107 >>
                IF "Approvar ID" <> '' THEN BEGIN
                    IF UserSetup.GET("Approvar ID") THEN
                        "Approvar Responsibility Center" := UserSetup."Responsibility Center"
                    ELSE
                        "Approvar Responsibility Center" := '';
                END ELSE
                    "Approvar Responsibility Center" := '';
                //ALLESR-191107 <<
            end;
        }
        field(6; "Alternate Approvar ID"; Code[20])
        {
            TableRelation = User;

            trigger OnValidate()
            begin
                //ALLESR-191107 >>
                IF "Alternate Approvar ID" <> '' THEN BEGIN
                    IF UserSetup.GET("Alternate Approvar ID") THEN
                        "Alt. App Responsibility Center" := UserSetup."Responsibility Center"
                    ELSE
                        "Alt. App Responsibility Center" := '';
                END ELSE
                    "Alt. App Responsibility Center" := '';
                //ALLESR-191107 <<
            end;
        }
        field(7; "Min Amount Limit"; Decimal)
        {
        }
        field(8; "Max Amount Limit"; Decimal)
        {
        }
        field(9; "Document No"; Code[20])
        {
        }
        field(10; "Authorized Date"; Date)
        {
            Caption = 'Authorized Date';
        }
        field(11; "Authorized Time"; Time)
        {
            Caption = 'Authorized Time';
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Approved,Returned,Not Required,Rejected';
            OptionMembers = " ",Approved,Returned,"Not Required",Rejected;
        }
        field(13; "Approval Remarks"; Text[200])
        {
            Description = 'dds changed as per user reqd / 20Jan';
        }
        field(14; "Approvar Responsibility Center"; Code[10])
        {
            Caption = 'Approvar Responsibility Center';
            Description = 'ALLESR-191107 : Field added';
            Editable = true;
            TableRelation = "Responsibility Center 1";
        }
        field(15; "Alt. App Responsibility Center"; Code[10])
        {
            Caption = 'Alternate Approvar Responsibility Center';
            Description = 'ALLESR-191107 : Field added';
            Editable = false;
            TableRelation = "Responsibility Center 1";
        }
        field(16; "Document Responsibility Centre"; Code[10])
        {
            Description = 'ALLEAB';
        }
        field(17; "Document Resposibility Name"; Text[50])
        {
            Description = 'ALLEAB';
        }
        field(18; "Key Responsibility Center"; Code[10])
        {
            Description = 'ALLEAB013';
            TableRelation = "Responsibility Center 1";
        }
        field(19; "Authorized ID"; Code[20])
        {
            Description = 'dds-to record user who approved';
            TableRelation = User;
        }
        field(50003; "Initiator Remarks"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Sub Document Type", "Document No", Initiator, "Line No")
        {
        }
        key(Key3; "Document Type", "Sub Document Type", "Document No", Initiator, Status)
        {
        }
        key(Key4; "Document Type", "Document No", Initiator, "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        UserSetup: Record "User Setup";
}

