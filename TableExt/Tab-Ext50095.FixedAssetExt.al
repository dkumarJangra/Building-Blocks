tableextension 50095 "BBG Fixed Asset Ext" extends "Fixed Asset"
{
    fields
    {
        // Add changes to table fields here
        modify(Description)
        {
            trigger OnAfterValidate()
            begin
                ItemRec.GET("No.");
                ItemRec.Description := Description;
                //ALLERP 30-11-2010:Start:
                ItemRec."Search Description" := "Search Description";
                //ALLERP 30-11-2010:End:
                ItemRec.MODIFY;

                RecResource.GET("No.");
                RecResource.Name := Description;
                //ALLERP 30-11-2010:Start:
                RecResource."Search Name" := "Search Description";
                //ALLERP 30-11-2010:End:
                RecResource.MODIFY;
            end;
        }
        modify("FA Subclass Code")
        {
            trigger OnAfterValidate()
            begin
                //alleab
                ItemRec.GET("No.");
                ItemRec."FA SubClass Code" := "FA Subclass Code";
                ItemRec.MODIFY;
                //alleab
            end;
        }
        field(50001; "Model No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMD BCL0022 20-09-2007';
        }
        field(50002; Make; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMD BCL0022 20-09-2007';
        }
        field(50003; Capacity; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMD BCL0022 20-09-2007';
            Editable = false;
        }
        field(50004; "Reg. No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMD BCL0022 20-09-2007';
        }
        field(50005; "Engine No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMD BCL0022 20-09-2007';
        }
        field(50006; "Chassis No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMD BCL0022 20-09-2007';
        }
        field(50007; "FA Sub Group"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds';
            Editable = false;
        }
        field(50008; "Description 3"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds';
        }
        field(50009; "Description 4"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds';
        }
        field(50010; Item; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds';
            Editable = false;
        }
        field(50011; "FA Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds';
            TableRelation = "Fixed Asset Sub Group"."FA Code";

            trigger OnValidate()
            begin
                //dds - added
                FAItem.RESET;
                Item := '';

                FAItem.SETRANGE(FAItem."FA Code", "FA Code");
                IF FAItem.FIND('-') THEN BEGIN
                    Item := FAItem.Item;
                    Capacity := FAItem.Capacity;
                    "FA Sub Group" := FAItem."FA Sub Group";

                    //alleab
                    ItemRec.GET("No.");
                    ItemRec."FA Sub Group" := FAItem."FA Sub Group";
                    ItemRec."Item-FA" := FAItem.Item;
                    ItemRec.Capacity := FAItem.Capacity;
                    ItemRec."Item-FA Code" := "FA Code"; //ALLEAA
                    ItemRec.MODIFY;
                    //alleab
                END;
            end;
        }
        field(50012; Link; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds-as per BLK reqd';
            InitValue = true;
        }
        field(50013; Year; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50014; "FA Opening"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50015; Leased; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds-as per BLK reqd';

            trigger OnValidate()
            begin

                //ALLEDDS01July - added by dds for leased FA
                TESTFIELD(Rec.Blocked);
                IF Rec.Leased = TRUE THEN BEGIN
                    FALedgEntry.RESET;
                    FALedgEntry.LOCKTABLE;
                    FALedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "FA Posting Date");
                    FALedgEntry.SETRANGE("FA No.", Rec."No.");
                    IF FALedgEntry.FIND('-') THEN
                        ERROR(Text80000);

                    ItemRec.GET("No.");
                    ItemRec.Leased := Rec.Leased;
                    ItemRec.MODIFY;
                END ELSE BEGIN
                    ILE.RESET;
                    ILE.LOCKTABLE;
                    ILE.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
                    ILE.SETRANGE("Item No.", Rec."No.");
                    IF ILE.FIND('-') THEN
                        ERROR(Text80001);

                    ItemRec.GET("No.");
                    ItemRec.Leased := Rec.Leased;
                    ItemRec.MODIFY;

                END;
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
        RecResource: Record Resource;
        ItemRec: Record Item;
        uomrec: Record "Item Unit of Measure";
        FAItem: Record "Fixed Asset Sub Group";
        FALedgEntry: Record "FA Ledger Entry";
        ILE: Record "Item Ledger Entry";
        Item: Code[20];
        Text80000: Label 'Cannot change Leased Status to TRUE for FA with FA Ledger entries';
        Text80001: Label 'Cannot change Leased Status to FALSE for FA with Item Ledger entries';

    trigger OnAfterInsert()
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');


        //ND
        RecResource.RESET;
        RecResource.INIT;
        RecResource."No." := "No.";
        RecResource.Type := RecResource.Type::Machine;
        RecResource."FA ID" := "No.";
        RecResource.Name := Description;
        RecResource.INSERT;

        //ALLEAB001 Start
        ItemRec.RESET;
        ItemRec.INIT;
        ItemRec."No." := "No.";
        ItemRec."FA Item" := TRUE;
        ItemRec.Blocked := TRUE;
        // ALLEPG 151111 Start
        ItemRec."Gen. Prod. Posting Group" := 'FA';
        ItemRec."Inventory Posting Group" := 'INVENTORY';
        // ALLEPG 151111 End
        ItemRec."Inventory Value Zero" := TRUE;
        //ALLEDDS01July
        ItemRec.Leased := Leased;
        //ALLEDDS01July
        ItemRec.INSERT;

        uomrec.RESET;
        uomrec.INIT;
        uomrec."Item No." := "No.";
        uomrec.Code := 'PCS';
        uomrec."Qty. per Unit of Measure" := 1;
        uomrec.INSERT;

        ItemRec.GET("No.");
        ItemRec."Base Unit of Measure" := 'PCS';
        ItemRec.VALIDATE("Base Unit of Measure");
        ItemRec.MODIFY;
        //ALLEAB001 END
    end;
}