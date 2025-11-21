tableextension 50003 "BBG G/L Account Ext" extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                //ALLECK 220313 START

                DebitVAccount.SETRANGE("Account No.", "No.");
                IF DebitVAccount.FINDSET THEN
                    REPEAT
                        DebitVAccount."Account Name" := Name;
                        MODIFY;
                    UNTIL DebitVAccount.NEXT = 0;
                //ALLECK 220313 END

                CreditVAccount.SETRANGE("Account No.", "No.");
                IF CreditVAccount.FINDSET THEN
                    REPEAT
                        CreditVAccount."Account Name" := Name;
                        MODIFY;
                    UNTIL CreditVAccount.NEXT = 0;
                //ALLECK 220313 END

                //Need to check the code in UAT

            end;
        }
        field(50000; "BBG Analysis Account Type"; Option)
        {
            Caption = 'Analysis Account Type';
            DataClassification = ToBeClassified;
            Description = 'ALLE-SR-131107:IBT';
            OptionCaption = ' ,EBT,Inter Accounting Location';
            OptionMembers = " ",EBT,IAL;
        }
        field(50001; "BBG Employee Account Balance"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "BBG Employee No." = FIELD("BBG Employee Filter"),
                                                        "Posting Date" = FIELD("Date Filter")));
            Caption = 'Employee Account Balance';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "BBG Name 2"; Text[40])
        {
            Caption = 'Name 2';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50003; "BBG Opening Not Req."; Boolean)
        {
            Caption = 'Opening Not Req.';
            DataClassification = ToBeClassified;
            Description = 'AlleDK 210708';
        }

        field(50100; "BBG posting"; Boolean)
        {
            Caption = 'posting';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90096; "BBG Employee Account"; Boolean)
        {
            Caption = 'Employee Account';
            DataClassification = ToBeClassified;
            Description = 'Alleas01--JPL';
        }

        field(90098; "BBG Employee Filter"; Code[20])
        {
            Caption = 'Employee Filter';
            Description = '--JPL';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(90099; "BBG Resource Filter"; Code[20])
        {
            Caption = 'Resource Filter';
            Description = '--JPL';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(90100; "BBG Vendor No."; Code[250])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(90102; "BBG Vendor Net Change (LCY)"; Decimal)
        {
            Caption = 'Vendor Net Change (LCY)';
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FILTER(<> ''),
                                                                                  "Vendor No." = FIELD(FILTER("BBG Vendor No.")),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CALCFIELDS("BBG Vendor Net Change (LCY)");
            end;
        }
        field(90103; "BBG Budget Line"; Boolean)
        {
            Caption = 'Budget Line';
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90104; "BBG Budget Base Amount"; Decimal)
        {
            Caption = 'Budget Base Amount';
            CalcFormula = Sum("G/L Budget Entry"."Budget Base Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                             "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                             "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                             "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                             Date = FIELD("Date Filter"),
                                                                             "Budget Name" = FIELD("Budget Filter")));
            Description = '--JPL';
            FieldClass = FlowField;
        }
        field(90105; "BBG Budget Taxes Amount"; Decimal)
        {
            Caption = 'Budget Taxes Amount';
            CalcFormula = Sum("G/L Budget Entry"."Budget Taxes Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              Date = FIELD("Date Filter"),
                                                                              "Budget Name" = FIELD("Budget Filter")));
            Description = '--JPL';
            FieldClass = FlowField;
        }
        field(90106; "BBG Vendor No. 2"; Code[250])
        {
            Caption = 'Vendor No. 2';
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(90107; "BBG Vendor Net Change 2"; Decimal)
        {
            Caption = 'Vendor Net Change 2';
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FILTER(<> ''),
                                                                                  "Vendor No." = FIELD(FILTER("BBG Vendor No. 2")),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CALCFIELDS("BBG Vendor Net Change (LCY)");
            end;
        }
        field(90108; "BBG Direct Posting Dummy"; Boolean)
        {
            Caption = 'Direct Posting Dummy';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90109; "BBG TempBlocked"; Boolean)
        {
            Caption = 'TempBlocked';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
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
        collbranch: Record Location;
        GLAcc: Record "G/L Account";
        // VAccount: Record 16547;//Need to check the code in UAT
        VLE: Codeunit Email;
        DebitVAccount: Record "Voucher Posting Debit Account";
        CreditVAccount: Record "Voucher Posting Credit Account";
        Memberof: Record "Access Control";

    trigger OnAfterInsert()
    begin
        //NDALLE
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'CHANGE ACCOUNTS');
        IF NOT Memberof.FIND('-') THEN
            ERROR('You dont have permission to Modify Records');

        HistoryFunction(0, 'INSERT');
    end;

    trigger OnAfterModify()
    begin
        //NDALLE
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'CHANGE ACCOUNTS');
        IF NOT Memberof.FIND('-') THEN
            ERROR('You dont have permission to Modify Records');

        HistoryFunction(0, 'MODIFY');
    end;

    trigger OnAfterDelete()
    begin
        //NDALLE
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'CHANGE ACCOUNTS');
        IF NOT Memberof.FIND('-') THEN
            ERROR('You dont have permission to Modify Records');
        //NDALLE
        HistoryFunction(0, 'DELETE');
    end;

    trigger OnAfterRename()
    begin
        //ERROR('You dont have permission'); KJA
        HistoryFunction(0, 'RENAME');
    end;

    PROCEDURE HistoryFunction(FunctionNo: Integer; Comment: Text[30]);
    BEGIN
        //HistoryRec.HistoryFunction(Rec,FunctionNo,Comment);
    END;
}