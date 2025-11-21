tableextension 50004 "BBG G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "BBG Issuing Bank"; Text[30])
        {
            Caption = 'Issuing Bank';
            Description = 'AlleBLK';
        }
        field(50001; "BBG Amount Including Excise"; Decimal)
        {
            Caption = 'Amount Including Excise';
            Description = 'AlleBLK';
        }
        field(50002; "BBG TDS Nature of Deduction"; Code[10])
        {
            Caption = 'TDS Nature of Deduction';
            Description = 'AlleBLK';
            TableRelation = "TDS Section".Code; // "TDS Nature of Deduction".Code; //Table Change ALLE-AM
        }
        field(50012; "BBG Project Code"; Code[20])
        {
            Caption = 'Project Code';
            Description = 'ALLESP BCL0014 10-09-2007-LoginProjectCode BBG';
            TableRelation = Job;
        }
        field(50014; "BBG Item Code"; Code[20])
        {
            Caption = 'Item Code';
            Description = 'Alle PS Added field for Item No';
        }
        field(50016; "BBG Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            Description = 'MPS1.0';
            Editable = true;
            TableRelation = "TDS Section";// "TDS Nature of Deduction"; //Change Table ALLE-AM
        }


        field(50022; "BBG Loan Code"; Code[20])
        {
            Caption = 'Loan Code';
            Description = 'MPS1.0';
        }
        field(50023; "BBG Bond Posting Group"; Code[20])
        {
            Caption = 'Bond Posting Group';
            Description = 'MPS1.0';
        }

        field(50025; "BBG Installment No."; Integer)
        {
            Caption = 'Installment No.';
            Description = 'MPS1.0';
        }
        field(50100; "BBG Insurance No."; Code[20])
        {
            Caption = 'Insurance No.';
            TableRelation = Insurance;
        }
        field(55006; "BBG Verified By"; Code[20])
        {
            Caption = 'Verified By';
            Description = 'NDALLE 310108';
        }
        field(55007; "BBG Created By"; Code[20])
        {
            Caption = 'Created By';
            Description = 'NDALLE 310108';
        }
        field(55008; "BBG Work Type"; Code[10])
        {
            Caption = 'Work Type';
            Description = 'AlleDK030708';
        }
        field(55009; "BBG TDS Exists"; Boolean)
        {
            Caption = 'TDS Exists';
        }
        field(55010; "BBG Tranasaction Type"; Option)
        {
            Caption = 'Tranasaction Type';
            OptionCaption = ' ,Trading';
            OptionMembers = " ",Trading;
        }
        field(55011; "BBG Payment Trasnfer from Other"; Boolean)
        {
            Caption = 'Payment Trasnfer from Other';
            Editable = false;
        }
        field(60025; "BBG LC/BG No."; Code[20])
        {
            Caption = 'LC/BG No.';
            //TableRelation = "LC Detail";
        }
        field(60026; "BBG BG Charges Type"; Option)
        {
            Caption = 'BG Charges Type';
            OptionCaption = ' ,Handling Charges,Stamp Charges,Courier Charges,Service Tax,Commision';
            OptionMembers = " ","Handling Charges","Stamp Charges","Courier Charges","Service Tax",Commision;
        }
        field(70030; "BBG Provisional Bill"; Boolean)
        {
            Caption = 'Provisional Bill';
            Description = '--JPL';
        }
        field(80004; "BBG Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            Description = 'IN094 ALLE MG - 01/08/05 - mployee Code and Department code print on Voucher--JPL';
        }
        field(50101; "BBG G/L Account No."; Code[20])
        {

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
}