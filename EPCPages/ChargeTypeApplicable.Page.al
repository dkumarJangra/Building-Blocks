page 97824 "Charge Type Applicable"
{
    DataCaptionExpression = FORMAT(Rec."Document Type") + ' ' + Rec.Code;
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Applicable Charges";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Code; Rec.Code)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("App. Charge Code"; Rec."App. Charge Code")
                {
                }
                field("App. Charge Name"; Rec."App. Charge Name")
                {
                    Editable = false;
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                    Editable = false;
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Rate Not Allowed"; Rec."Rate Not Allowed")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Rate/UOM", 0);
                        Rec.TESTFIELD("Fixed Price", 0);
                    end;
                }
                field("Rate/UOM"; Rec."Rate/UOM")
                {
                    BlankZero = true;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Rate Not Allowed", FALSE);
                        Rec.TESTFIELD("Fixed Price", 0);
                    end;
                }
                field("Fixed Price"; Rec."Fixed Price")
                {
                    BlankZero = true;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Rate Not Allowed", FALSE);
                        Rec.TESTFIELD("Rate/UOM", 0);
                    end;
                }
                field(Applicable; Rec.Applicable)
                {
                }
                field("Discount %"; Rec."Discount %")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Fixed Discount Amount"; Rec."Fixed Discount Amount")
                {
                    Caption = 'Fixed Discount Amount Rate/UOM';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Update)
            {
                Caption = 'Update';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to update the info in Sales ', TRUE) THEN BEGIN
                        TotAmt := 0;
                        Rec.RESET;
                        Rec.SETRANGE("Document No.", Rec."Document No.");
                        Rec.SETRANGE(Applicable, TRUE);
                        IF Rec.FINDFIRST THEN
                            REPEAT
                                TotAmt := TotAmt + Rec."Net Amount";
                            UNTIL Rec.NEXT = 0;

                        IF TotAmt <> 0 THEN BEGIN
                            Shrec.GET(Rec."Document No.");
                            Shrec."Investment Amount" := TotAmt;
                            Shrec.MODIFY;
                        END;

                    END;
                end;
            }
            action(Refresh)
            {
                Caption = 'Refresh';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Project Code");
                    Rec.TESTFIELD("Item No.");
                    IF CONFIRM('Do you want to update the Charge Types for this Order', TRUE) THEN BEGIN

                        Shrec.RESET;
                        Shrec.GET(Rec."Document No.");

                        DocMaster.RESET;
                        DocMaster.SETRANGE(DocMaster."Document Type", DocMaster."Document Type"::Charge);
                        DocMaster.SETFILTER(DocMaster."Project Code", Rec."Project Code");
                        IF Shrec."Sub Document Type" = Shrec."Sub Document Type"::Lease THEN
                            DocMaster.SETRANGE(DocMaster."Sale/Lease", DocMaster."Sale/Lease"::Lease);
                        IF Shrec."Sub Document Type" = Shrec."Sub Document Type"::Sales THEN
                            DocMaster.SETRANGE(DocMaster."Sale/Lease", DocMaster."Sale/Lease"::Sale);

                        IF DocMaster.FINDFIRST THEN
                            REPEAT
                                Rec.RESET;
                                Rec.INIT;
                                Rec."Document Type" := DocMaster."Document Type"::Charge;
                                Rec.Code := DocMaster.Code;

                                Rec.Description := DocMaster.Description;
                                IF DocMaster."Project Price Dependency Code" <> '' THEN BEGIN
                                    Shrec.RESET;
                                    Shrec.GET(Rec."Document No.");
                                    PPGD.RESET;
                                    PPGD.SETFILTER(PPGD."Project Code", Rec."Project Code");
                                    PPGD.SETRANGE(PPGD."Project Price Group", DocMaster."Project Price Dependency Code");
                                    PPGD.SETFILTER(PPGD."Starting Date", '<=%1', Shrec."Document Date");
                                    IF PPGD.FINDLAST THEN BEGIN
                                        IF DocMaster."Sale/Lease" = DocMaster."Sale/Lease"::Sale THEN
                                            Rec."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                                        IF DocMaster."Sale/Lease" = DocMaster."Sale/Lease"::Lease THEN
                                            Rec."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                                    END;
                                END
                                ELSE
                                    Rec."Rate/UOM" := DocMaster."Rate/Sq. Yd";

                                Rec."Project Code" := DocMaster."Project Code";
                                Rec."Fixed Price" := DocMaster."Fixed Price";
                                Rec."BP Dependency" := DocMaster."BP Dependency";
                                Rec."Rate Not Allowed" := DocMaster."Rate Not Allowed";
                                Rec."Project Price Dependency Code" := DocMaster."Project Price Dependency Code";
                                IF Rec."Rate/UOM" <> 0 THEN BEGIN
                                    Itemrec.GET(Rec."Item No.");
                                    Rec."Net Amount" := Itemrec."Saleable Area" * Rec."Rate/UOM";
                                END
                                ELSE
                                    Rec."Net Amount" := Rec."Fixed Price";
                                Rec.Sequence := DocMaster.Sequence;
                                IF Rec.Code = 'PLC' THEN BEGIN
                                    PLCRec.SETFILTER("Item Code", Rec."Item No.");
                                    PLCRec.SETFILTER("Job Code", Rec."Project Code");
                                    IF PLCRec.FINDFIRST THEN
                                        REPEAT
                                            Rec."Fixed Price" := Rec."Fixed Price" + PLCRec.Amount;
                                            Rec."Net Amount" := Rec."Fixed Price";
                                        UNTIL PLCRec.NEXT = 0;
                                END;
                                Rec."Commision Applicable" := DocMaster."Commision Applicable";
                                Rec."Direct Associate" := DocMaster."Direct Associate";
                                Rec.INSERT;
                            UNTIL DocMaster.NEXT = 0;
                    END;
                    Rec.SETRANGE("Document No.", Rec."Document No.");
                end;
            }
        }
    }

    var
        DocMaster: Record "Document Master";
        Itemrec: Record "Unit Master";
        PLCRec: Record "PLC Details";
        SLineRec: Record "Sales Line";
        ApplicableCharges: Record "Applicable Charges";
        TotAmt: Decimal;
        PPGD: Record "Project Price Group Details";
        Shrec: Record Application;
        Text001: Label 'Delete the existing Applicable Charges.';
}

