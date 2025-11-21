table 97721 "Document Type Setup"
{
    // ALLEAB: Sub Document Type:Option Added for Indent ,FA,Man Power,Leave,Travel,Others
    // AlleBLK : New fields Added
    // ALLEAA - Field Added
    // //ALLEDK 231211 Added code for the No. Series change in case of FBW.

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
        field(3; "Approval Required"; Boolean)
        {
        }
        field(4; "Indent Required"; Boolean)
        {
        }
        field(5; "PO No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "GRN No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Posted GRN No Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Invoice No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Posted Invoice No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50000; "FBW PO No. Series"; Code[20])
        {
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50001; "FBW GRN No. Series"; Code[20])
        {
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50002; "FBW Posted GRN No Series"; Code[20])
        {
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50003; "FBW Invoice No. Series"; Code[20])
        {
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50004; "FBW Posted Invoice No. Series"; Code[20])
        {
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(70010; "Sales Tax Comments"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70011; "Excise Duty Comments"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70012; "Terms of Payments"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70013; "Service Tax"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70014; "Transit Insurance"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70015; "Inspection Remarks"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70016; "Packaging & Forwarding"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70017; "Price Basis"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70018; "Freight Terms"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70019; "DD Comm/Bank Charges"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70020; "Warranty/Guarantee Terms"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70021; "Gate Entry Required"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(70022; "Gate Entry Inward Type"; Option)
        {
            Description = 'AlleBLK';
            OptionCaption = 'Regular PO,Local Purchase,Packages/Work Orders,Returnable Out-Gatepass';
            OptionMembers = "Regular PO","Local Purchase","Packages/Work Orders","Returnable Out-Gatepass";
        }
        field(70023; "Entry Tax/Octroi Terms"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70024; "Installation Terms"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70025; "Service Tax-Installation"; Text[100])
        {
            Description = 'AlleBLK';
        }
        field(70026; "Job Allocation"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(70027; "Control GL Account"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "G/L Account";
        }
        field(70028; "Copy Employee Dept-CC"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(70029; "Def. Gen Prod Posting Group"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(70030; "Milestone Compulsory"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(70031; "Work Tax Applicable"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(70032; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'ALLEAA';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        key(Key1; "Document Type", "Sub Document Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

