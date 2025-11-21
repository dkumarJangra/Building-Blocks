page 97863 "Job Allocation"
{
    AutoSplitKey = true;
    PageType = Card;
    SourceTable = "Job Allocation";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field("GL Account No."; Rec."GL Account No.")
                {

                    trigger OnValidate()
                    begin

                        IF Rec."GL Account No." <> '' THEN BEGIN
                            //Get Default Cost Center
                            DefDim.RESET;
                            DefDim.SETRANGE(DefDim."Table ID", 15);
                            DefDim.SETFILTER("No.", Rec."GL Account No.");
                            DefDim.SETFILTER("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
                            IF DefDim.FIND('-') THEN BEGIN
                                IF DefDim."Dimension Value Code" <> '' THEN
                                    Rec."Shortcut Dimension 1 Code" := DefDim."Dimension Value Code";
                            END;
                            //Get Default Cost Center
                            DefDim.RESET;
                            DefDim.SETRANGE(DefDim."Table ID", 15);
                            DefDim.SETFILTER("No.", Rec."GL Account No.");
                            DefDim.SETFILTER("Dimension Code", GLSetup."Shortcut Dimension 2 Code");
                            IF DefDim.FIND('-') THEN BEGIN
                                IF DefDim."Dimension Value Code" <> '' THEN
                                    Rec."Shortcut Dimension 2 Code" := DefDim."Dimension Value Code";
                            END;

                            //Get Default Cost Center
                            DefDim.RESET;
                            DefDim.SETRANGE(DefDim."Table ID", 15);
                            DefDim.SETFILTER("No.", Rec."GL Account No.");
                            DefDim.SETFILTER("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                            IF DefDim.FIND('-') THEN BEGIN
                                IF DefDim."Dimension Value Code" <> '' THEN
                                    Rec."Shortcut Dimension 3 Code" := DefDim."Dimension Value Code";
                            END;


                            //Get Default Cost Center
                            DefDim.RESET;
                            DefDim.SETRANGE(DefDim."Table ID", 15);
                            DefDim.SETFILTER("No.", Rec."GL Account No.");
                            DefDim.SETFILTER("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                            IF DefDim.FIND('-') THEN BEGIN
                                IF DefDim."Dimension Value Code" <> '' THEN
                                    Rec."Shortcut Dimension 4 Code" := DefDim."Dimension Value Code";
                            END;

                        END;
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                            ERROR('You can not select DUMMY cost center..');

                        dimvalue.RESET;
                        dimvalue.SETRANGE(dimvalue."Dimension Code", 'COST CENTER');
                        dimvalue.SETRANGE(dimvalue.Code, Rec."Shortcut Dimension 1 Code");
                        IF dimvalue.FIND('-') THEN
                            IF dimvalue.Blocked = TRUE THEN
                                ERROR('This cost center is blocked....');
                    end;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PAmt: Decimal;
        JLine: Record "Job Allocation";
    begin
        GLSetup.GET;
        IF Rec."Line No." <> 0 THEN BEGIN
            POLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.");

            JLine.RESET;
            JLine.SETRANGE("Document Type", Rec."Document Type");
            JLine.SETRANGE("Document No.", Rec."Document No.");
            JLine.SETRANGE("Line No.", Rec."Line No.");
            IF JLine.FIND('-') THEN
                REPEAT
                    PAmt := PAmt + JLine.Amount;
                UNTIL JLine.NEXT = 0;

            Rec.Amount := POLine."Line Amount" - PAmt;
            Rec."Shortcut Dimension 1 Code" := POLine."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := POLine."Shortcut Dimension 2 Code";

            // ALLE MM Code Commented
            /*
            DocDim.RESET;
            DocDim.SETRANGE(DocDim."Table ID",39  );
            DocDim.SETRANGE("Document Type",POLine."Document Type");
            DocDim.SETRANGE("Document No.",POLine."Document No.");
            DocDim.SETRANGE("Line No.",POLine."Line No.");
            DocDim.SETRANGE("Dimension Code",GLSetup."Shortcut Dimension 3 Code");
            IF DocDim.FIND('-') THEN
              "Shortcut Dimension 3 Code":=DocDim."Dimension Value Code";

            DocDim.SETRANGE("Dimension Code",GLSetup."Shortcut Dimension 4 Code");
            IF DocDim.FIND('-') THEN
              "Shortcut Dimension 4 Code":=DocDim."Dimension Value Code";
            */
            // ALLE MM Code Commented
            // ALLE MM Code Added
            DimSetEntry.RESET;
            DimSetEntry.SETRANGE("Dimension Set ID", POLine."Dimension Set ID");
            DimSetEntry.SETRANGE("Dimension Code", 'EMPLOYEES');
            IF DimSetEntry.FINDFIRST THEN
                Rec."Shortcut Dimension 3 Code" := DimSetEntry."Dimension Value Code";

            DimSetEntry.RESET;
            DimSetEntry.SETRANGE("Dimension Set ID", POLine."Dimension Set ID");
            DimSetEntry.SETRANGE("Dimension Code", 'TO PROJECT');
            IF DimSetEntry.FINDFIRST THEN
                Rec."Shortcut Dimension 4 Code" := DimSetEntry."Dimension Value Code";
            // ALLE MM Code Added
        END;

    end;

    trigger OnOpenPage()
    begin
        GLSetup.GET;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Amt := 0;
        IF POLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.") THEN;
        JobAllocation.RESET;
        JobAllocation.SETRANGE("Document Type", Rec."Document Type");
        JobAllocation.SETRANGE("Document No.", Rec."Document No.");
        JobAllocation.SETRANGE("Line No.", Rec."Line No.");
        IF JobAllocation.FIND('-') THEN BEGIN
            REPEAT
                Amt := Amt + JobAllocation.Amount;
            UNTIL JobAllocation.NEXT = 0;
        END;

        IF Amt <> POLine."Line Amount" THEN BEGIN
            IF CONFIRM('Line Amount does not match with amounts entered.Do you want to continue?', TRUE) THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    end;

    var
        POHdr: Record "Purchase Header";
        POLine: Record "Purchase Line";
        JobAllocation: Record "Job Allocation";
        Amt: Decimal;
        DefDim: Record "Default Dimension";
        GLSetup: Record "General Ledger Setup";
        dimvalue: Record "Dimension Value";
        DimSetEntry: Record "Dimension Set Entry";
}

