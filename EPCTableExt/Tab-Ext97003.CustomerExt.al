tableextension 97003 "EPC Customer Ext" extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(90029; "BBG Father's/Husband's Name"; Text[50])
        {
            Caption = 'Father"s/Husband"s Name';
            DataClassification = ToBeClassified;
        }
        field(50003; "BBG Posting Type Filter"; Option)
        {
            Caption = 'Posting Type Filter';
            Description = 'AlleDK 200308 For report Customer Ledger';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance";
        }
        field(50001; "BBG New Debit Amount (LCY)"; Decimal)
        {
            Caption = 'New Debit Amount (LCY)';
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                       "Entry Type" = FILTER(<> Application),
                                                                                       "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                       "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                       "Posting Date" = FIELD("Date Filter"),
                                                                                       "Currency Code" = FIELD("Currency Filter"),
                                                                                       "Posting Type" = FIELD("BBG Posting Type Filter")));
            Description = 'AlleDK 200308 For report Customer Ledger';
            FieldClass = FlowField;
        }
        field(50024; "BBG Aadhar No."; Code[15])   //Change Integer to Code 190325
        {
            Caption = 'Aadhar No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                AadharNoLength: integer;
            begin
                IF "BBG Aadhar No." <> '' THEN begin
                    AadharNoLength := 1;
                    AadharNoLength := StrLen("BBG Aadhar No.");
                    If AadharNoLength <> 12 THEN
                        Error('Aadhar No. should be 12 digits');


                    pos := 1;
                    WHILE (pos <= STRLEN("BBG Aadhar No.")) DO BEGIN
                        IsNumeric := "BBG Aadhar No."[pos] IN ['a' .. 'z', ',', '.', '-', '+'];
                        IF NOT IsNumeric THEN
                            IsNumeric := "BBG Aadhar No."[pos] IN ['A' .. 'Z', ',', '.', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Charactors not allow')
                        ELSE
                            result := result + FORMAT("BBG Aadhar No."[pos]);
                        pos += 1;
                    END;
                END;
            end;
        }
        field(90016; "BBG Cust. Posting Group-Advance"; Code[10])
        {
            Caption = 'Cust. Posting Group-Advance';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Customer Posting Group";
        }
        field(90017; "BBG Cust. Posting Group-Running"; Code[10])
        {
            Caption = 'Cust. Posting Group-Running';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Customer Posting Group";

            trigger OnValidate()
            begin
                //ALLEAS02 <<
                "Customer Posting Group" := "BBG Cust. Posting Group-Running";
                //ALLEAS02 >>
            end;
        }
        field(90018; "BBG Cust. Posting Group-Retention"; Code[10])
        {
            Caption = 'Cust. Posting Group-Retention';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Customer Posting Group";
        }
        field(50005; "BBG Mobile No."; Text[30])
        {
            Caption = 'Mobile No.';
            DataClassification = ToBeClassified;
            Description = 'AlleDK 190608';

            trigger OnValidate()
            begin
                //ALLEDK 100821
                IF "BBG Mobile No." <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN("BBG Mobile No.")) DO BEGIN
                        IsNumeric := "BBG Mobile No."[pos] IN ['a' .. 'z', ',', '.', '-', '+'];
                        IF NOT IsNumeric THEN
                            IsNumeric := "BBG Mobile No."[pos] IN ['A' .. 'Z', ',', '.', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Charactors not allow')
                        ELSE
                            result := result + FORMAT("BBG Mobile No."[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821
            end;
        }
        field(90026; "BBG Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "BBG Date of Birth" > TODAY THEN  //Alledk 100821
                    ERROR('Date Of Birth can not be greater than Today');  //Alledk 100821

                IF "BBG Date of Birth" = 0D THEN
                    "BBG Age" := 0
                ELSE BEGIN
                    "BBG Age" := ROUND(((TODAY - "BBG Date of Birth") / 365), 1);
                    MODIFY;
                END;
            end;
        }
        field(90027; "BBG Age"; Decimal)
        {
            Caption = 'Age';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90028; "BBG Sex"; Option)
        {
            Caption = 'Sex';
            DataClassification = ToBeClassified;
            OptionMembers = Male,Female;
        }

        field(90030; "BBG Date of Joining"; Date)
        {
            Caption = 'Date of Joining';
            DataClassification = ToBeClassified;
            Description = '03/10/12';
            Editable = true;

            trigger OnValidate()
            begin
                IF xRec."BBG Date of Joining" <> 0D THEN BEGIN
                    Memberof.RESET;
                    Memberof.SETRANGE("User Name", USERID);
                    Memberof.SETRANGE("Role ID", 'A_JOINDATE');
                    IF NOT Memberof.FINDFIRST THEN
                        ERROR('You are not authorised to change the Date');
                END;
            end;
        }
        field(90031; "BBG Old No."; Code[20])
        {
            Caption = 'Old No.';
            DataClassification = ToBeClassified;
            Description = '05/01/13';

            trigger OnValidate()
            begin
                IF "BBG Old No." <> '' THEN BEGIN
                    Cust.RESET;
                    Cust.SETCURRENTKEY("BBG Old No.");
                    Cust.SETRANGE("BBG Old No.", "BBG Old No.");
                    IF Cust.FINDFIRST THEN
                        ERROR('Member old no. already Exists');
                END;
            end;
        }
        field(90032; "BBG Customer Copy in Company"; Text[30])
        {
            Caption = 'Customer Copy in Company';
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(90033; "BBG Send for Approval"; Boolean)
        {
            Caption = 'Send for Approval';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90034; "BBG Send for Aproval Date"; Date)
        {
            Caption = 'Send for Aproval Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90035; "BBG Approval Status"; Option)
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
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
        RecRef: RecordRef;
        StartNo: Text[10];
        VarInteger: Integer;
        Cust: Record Customer;
        Memberof: Record "Access Control";
        "--------------------": Integer;
        pos: Integer;
        result: Text;
        IsNumeric: Boolean;
}