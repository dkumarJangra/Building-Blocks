xmlport 97722 "Upload Sale BOQ Master"
{
    // ALLESP BCL0011 20-08-2007: New Dataport Created for Importing of BOQ Items
    // ALLEAA - Flow BOQ Type in All Tables
    // //RAHEE1.00 170412 Added code and Datafields
    // 
    // //RAHEE 1.00 020512 Check the Job must not be Approved or Amended Approved. and in Extended Text Line contain all Description.
    // 
    // //RAHEE1.00  030512 Added for Entry no. in Job Planning Lines


    schema
    {
        textelement(Root)
        {
            tableelement("BOQ Item"; "BOQ Item")
            {
                XmlName = 'BOQItem';
                fieldelement(PhaseCode; "BOQ Item"."Phase Code")
                {
                }
                fieldelement(Code; "BOQ Item".Code)
                {
                }
                fieldelement(Type; "BOQ Item".Type)
                {
                }
                fieldelement(Desc; "BOQ Item".Description)
                {
                }
                fieldelement(ValueType; "BOQ Item"."Value Type")
                {
                }
                fieldelement(BaseUOM; "BOQ Item"."Base UOM")
                {
                }
                fieldelement(Quantity; "BOQ Item".Quantity)
                {
                }
                fieldelement(UnitPrice1; "BOQ Item"."Unit Price")
                {
                }
                fieldelement(BOQRate; "BOQ Item"."BOQ Rate")
                {
                }
                fieldelement(PercentChange; "BOQ Item"."Percent Change")
                {
                }
                fieldelement(BOQTenderRate; "BOQ Item"."BOQ Tender Rate")
                {
                }
                fieldelement(BOQTenderAmount; "BOQ Item"."BOQ Tender Amount")
                {
                }
                textelement(ContractPrice)
                {
                }
                textelement(Remark)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    EntryNo += 1;
                    "BOQ Item".Description := '';
                    "BOQ Item"."Description 2" := '';
                    DescLength := 0;
                    Desc1Length := 0;

                    "BOQ Item"."Project Code" := PCode;
                    "BOQ Item"."Entry No." := EntryNo;
                    "BOQ Item".Description := COPYSTR(Desc, 1, 50);
                    "BOQ Item"."Description 2" := COPYSTR(Desc, 51, 50);
                    "BOQ Item".VALIDATE("Unit Price");
                    "BOQ Item".VALIDATE(Quantity);
                    "BOQ Item"."BOQ Type" := "BOQ Item"."BOQ Type"::Sale; //ALLEAA


                    LineNo := 0;
                    DescLength := STRLEN(Desc);

                    IF DescLength > 0 THEN BEGIN       //RAHEE1.00  020512
                        ExtendedTextHdr.INIT;
                        ExtendedTextHdr."Table Name" := ExtendedTextHdr."Table Name"::"BOQ Item";
                        ExtendedTextHdr."No." := "BOQ Item"."Project Code";
                        ExtendedTextHdr."Text No." := EntryNo;
                        ExtendedTextHdr."BOQ Type" := ExtendedTextHdr."BOQ Type"::Sale; //ALLEAA
                        ExtendedTextHdr.INSERT;

                        ExtendedTextLine.RESET;
                        ExtendedTextLine.SETRANGE("Table Name", ExtendedTextHdr."Table Name");
                        ExtendedTextLine.SETRANGE("No.", ExtendedTextHdr."No.");
                        ExtendedTextLine.SETRANGE("Text No.", ExtendedTextHdr."Text No.");
                        ExtendedTextLine."BOQ Type" := ExtendedTextLine."BOQ Type"::Sale; //ALLEAA
                        IF ExtendedTextLine.FIND('-') THEN
                            ExtendedTextLine.DELETEALL;

                        //DescLength := DescLength-100;  //RAHEE1.00  020512
                        i := 1;                           //RAHEE1.00  020512
                        REPEAT
                            ExtendedTextLine.Text := '';
                            LineNo += 10000;
                            ExtendedTextLine."Table Name" := ExtendedTextLine."Table Name"::"BOQ Item";
                            ExtendedTextLine."No." := "BOQ Item"."Project Code";
                            ExtendedTextLine."Text No." := ExtendedTextHdr."Text No.";
                            // i += 50;                     //RAHEE1.00  020512
                            DescLength := DescLength - 50;
                            ExtendedTextLine."Line No." := LineNo;
                            ExtendedTextLine.Text := COPYSTR(Desc, 51 + i, 50);
                            ExtendedTextLine."BOQ Type" := ExtendedTextLine."BOQ Type"::Sale; //ALLEAA
                            ExtendedTextLine.INSERT;
                            i += 50;                       //RAHEE1.00  020512
                        UNTIL DescLength <= 0;
                    END;

                    JobTask.VALIDATE("Job No.", PCode);
                    JobTask.VALIDATE("Job Task No.", "BOQ Item"."Phase Code");
                    IF "BOQ Item"."Value Type" = "BOQ Item"."Value Type"::Posting THEN
                        JobTask.VALIDATE("Job Task Type", "BOQ Item"."Value Type")
                    ELSE
                        JobTask.VALIDATE("Job Task Type", "BOQ Item"."Value Type");
                    JobTask.Description := COPYSTR(Desc, 1, 50);
                    JobTask."Phase Desc" := COPYSTR(Desc, 51, 150);
                    JobTask."BOQ Code" := "BOQ Item".Code;
                    //JobTask."BOQ Qty.":=Quantity;
                    //JobTask."BOQ Amt.":= "Unit Price" * Quantity;
                    JobTask."Entry No." := "BOQ Item"."Entry No.";
                    JobTask."BOQ Type" := JobTask."BOQ Type"::Sale;  //ALLEAA
                    JobTask.Remark := Remark;  //RAHEE1.00 170412
                    JobTask.INSERT(TRUE);

                    IF "BOQ Item".Type = "BOQ Item".Type::"G/L Account" THEN
                        IF NOT UOMREC.GET("BOQ Item"."Base UOM") THEN
                            ERROR('The Unit of Measure %1 does not exist in the BOQ Sheet', "BOQ Item"."Base UOM");

                    IF ("BOQ Item"."Value Type" = "BOQ Item"."Value Type"::Posting) OR ("BOQ Item"."Value Type" = "BOQ Item"."Value Type"::"Begin-Total") THEN BEGIN
                        IF ("BOQ Item"."Value Type" = "BOQ Item"."Value Type"::Posting) OR ("BOQ Item"."Value Type" = "BOQ Item"."Value Type"::"Begin-Total") THEN BEGIN
                            Project.GET(PCode);
                            ProjectBudgetLineBuff."Job No." := PCode;
                            ProjectBudgetLineBuff."Phase Code" := "BOQ Item"."Phase Code";
                            IF "BOQ Item".Type = "BOQ Item".Type::"G/L Account" THEN BEGIN
                                ProjectBudgetLineBuff.Type := "BOQ Item".Type::"G/L Account";
                                ProjectBudgetLineBuff.Bold := FALSE;
                            END ELSE BEGIN
                                ProjectBudgetLineBuff.Type := 3;
                                ProjectBudgetLineBuff.Bold := TRUE;
                            END;
                            ProjectBudgetLineBuff."BOQ Code" := "BOQ Item".Code;
                            ProjectBudgetLineBuff."Entry No." := "BOQ Item"."Entry No.";
                            ProjectBudgetLineBuff.Description := "BOQ Item".Description;
                            ProjectBudgetLineBuff."Description 2" := "BOQ Item"."Description 2";
                            ProjectBudgetLineBuff."Unit of Measure" := "BOQ Item"."Base UOM";
                            ProjectBudgetLineBuff."Starting Date" := Project."Starting Date";
                            ProjectBudgetLineBuff."Direct Unit Cost" := "BOQ Item"."Unit Price";
                            ProjectBudgetLineBuff."Unit Price" := "BOQ Item"."Unit Price";
                            ProjectBudgetLineBuff.Quantity := "BOQ Item".Quantity;
                            ProjectBudgetLineBuff."BOQ Type" := ProjectBudgetLineBuff."BOQ Type"::Sale; //ALLEAA
                            ProjectBudgetLineBuff."BOQ Tender Rate" := "BOQ Item"."BOQ Tender Rate";
                            ProjectBudgetLineBuff."BOQ Tender Amount" := "BOQ Item"."BOQ Tender Amount";
                            ProjectBudgetLineBuff.INSERT;

                            JobsSetup.GET;
                            //  JobPlanningLine.TRANSFERFIELDS(ProjectBudgetLineBuff);
                            IF "BOQ Item".Type = "BOQ Item".Type::"G/L Account" THEN BEGIN
                                JobPlanningLine.VALIDATE("Job No.", ProjectBudgetLineBuff."Job No.");
                                JobPlanningLine.VALIDATE("Job Task No.", ProjectBudgetLineBuff."Phase Code");
                                JobPlanningLine."Line No." := 10000;
                                JobPlanningLine."Line Type" := JobPlanningLine."Line Type"::Contract;
                                JobPlanningLine.INSERT(TRUE);
                                JobPlanningLine.Type := JobPlanningLine.Type::"G/L Account";
                                JobPlanningLine.VALIDATE("No.", JobsSetup."Job G/L Account");
                                JobPlanningLine.VALIDATE(Quantity, ProjectBudgetLineBuff.Quantity);
                                JobPlanningLine.VALIDATE("Direct Unit Cost (LCY)", ProjectBudgetLineBuff."Unit Price");
                                JobPlanningLine.VALIDATE("Unit Price", ProjectBudgetLineBuff."Unit Price");
                                JobPlanningLine."Location Code" := PCode;
                                JobPlanningLine."Unit of Measure Code" := "BOQ Item"."Base UOM";
                                JobPlanningLine."Schedule Line" := FALSE;
                                JobPlanningLine."Contract Line" := TRUE;
                                //    JobPlanningLine.TRANSFERFIELDS(ProjectBudgetLineBuff);
                                JobPlanningLine."BOQ Type" := JobPlanningLine."BOQ Type"::Sale; //ALLEAA
                                JobPlanningLine."Tender Rate" := ProjectBudgetLineBuff."BOQ Tender Rate";
                                JobPlanningLine."BOQ Tender Amount" := ProjectBudgetLineBuff."BOQ Tender Amount";
                                IF ContractPrice <> '' THEN
                                    EVALUATE(ContractPrice1, ContractPrice);
                                JobPlanningLine."Contract Price" := ContractPrice1; //RAHEE1.00 160412
                                JobPlanningLine.Remark := Remark; //RAHEE1.00 300412
                                JobPlanningLine."BOQ Rate" := "BOQ Item"."BOQ Rate";
                                JobPlanningLine."Entry No." := EntryNo;  //RAHEE1.00  030512
                                JobPlanningLine.MODIFY;
                            END;
                        END;
                    END;
                    "BOQ Item".Indent(PCode);
                end;

                trigger OnBeforeInsertRecord()
                begin
                    Desc := '';
                    "BOQ Item"."Unit Price" := 0;
                    "BOQ Item".Quantity := 0;
                    "BOQ Item".Code := '';
                    "BOQ Item"."BOQ Tender Rate" := 0;
                    "BOQ Item"."BOQ Tender Amount" := 0;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        ExtendedTextHdr: Record "Extended Text Header";
        ExtendedTextLine: Record "Extended Text Line";
        BOQItem: Record "BOQ Item";
        JobTask: Record "Job Task";
        ProjectBudgetLineBuff: Record "Project Budget Line Buffer";
        Project: Record "Job";
        JobPlanningLine: Record "Job Planning Line";
        ProjectBudgetLineBuff1: Record "Project Budget Line Buffer";
        VPProjectBudget1: Record "Job Planning Line";
        UOMREC: Record "Unit of Measure";
        Memberof: Record "Access Control";
        RecJobTask: Record "Job Task";
        JobsSetup: Record "Jobs Setup";
        //CDM: Codeunit "SMTP Test Mail";
        //CDM1: Codeunit "SMTP Test Mail";
        EntryNo: Integer;
        Desc: Text[1024];
        Desc1: Text[1024];
        LineNo: Integer;
        i: Integer;
        PCode: Code[20];
        FileName_2: Text[100];
        DescLength: Integer;
        Desc1Length: Integer;
        Path: Text[100];
        Action1: Option Open,Save;
        BOQItem1: Record "BOQ Item";
        ContractPrice1: Decimal;
        Remark1: Text[50];
        job: Record "Job";
}

