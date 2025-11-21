page 97809 "BOQ Modification"
{
    PageType = Card;
    SourceTable = "BOQ Item";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("BOQ Modification")
            {
                Caption = 'BOQ Modification';
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field(Code; Rec.Code)
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Base UOM"; Rec."Base UOM")
                {
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    Editable = false;
                }
                field(ModType; ModType)
                {
                    Caption = 'New Type';
                }
                field(ModQuantity; ModQuantity)
                {
                    Caption = 'New Quantity';
                }
                field(ModUOM; ModUOM)
                {
                    Caption = 'New UOM';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF PAGE.RUNMODAL(Page::"Units of Measure", uom) = ACTION::LookupOK THEN BEGIN
                            ModUOM := uom.Code;
                        END;
                    end;
                }
                field("ModUnit Cost"; "ModUnit Cost")
                {
                    Caption = 'New Unit of Cost';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Confirm)
            {
                Caption = 'Confirm';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to modify the existing record') THEN BEGIN
                        IF ModType <> ModType::" " THEN BEGIN
                            Rec.Type := ModType;
                        END;
                        IF ModQuantity <> 0 THEN BEGIN
                            Rec.Quantity := ModQuantity;
                            Rec.VALIDATE(Quantity);
                            PhaseRec.RESET;
                            PhaseRec.SETFILTER(PhaseRec."Job No.", Rec."Project Code");
                            PhaseRec.SETRANGE(PhaseRec."Entry No.", Rec."Entry No.");
                            IF PhaseRec.FINDFIRST THEN BEGIN
                                PhaseRec."BOQ Qty." := ModQuantity;
                                PhaseRec."BOQ Amt." := Rec."Total Price";
                                PhaseRec."Pending Amt." := Rec."Total Price";
                                PhaseRec.MODIFY;
                            END;

                            JobBudgetLineRec.RESET;
                            JobBudgetLineRec.SETRANGE("Entry No.", Rec."Entry No.");
                            JobBudgetLineRec.SETFILTER(JobBudgetLineRec."Job No.", Rec."Project Code");
                            IF JobBudgetLineRec.FINDFIRST THEN BEGIN
                                JobBudgetLineRec.Quantity := ModQuantity;
                                JobBudgetLineRec.VALIDATE(Quantity);
                                JobBudgetLineRec.MODIFY;
                            END;

                            ProBudgetLineRec.RESET;
                            ProBudgetLineRec.SETRANGE("Entry No.", Rec."Entry No.");
                            ProBudgetLineRec.SETFILTER(ProBudgetLineRec."Job No.", Rec."Project Code");
                            IF ProBudgetLineRec.FINDFIRST THEN BEGIN
                                ProBudgetLineRec.Quantity := ModQuantity;
                                ProBudgetLineRec.VALIDATE(Quantity);
                                ProBudgetLineRec.MODIFY;
                            END;

                            //    JobBudgetEntryRec.RESET;
                            //    JobBudgetEntryRec.SETRANGE("Entry No.","Entry No.");
                            //    JobBudgetEntryRec.SETFILTER(JobBudgetEntryRec."Job No.","Project Code");
                            //    IF JobBudgetEntryRec.FINDFIRST THEN
                            //     BEGIN
                            //      JobBudgetEntryRec.Quantity:=ModQuantity;
                            //      JobBudgetEntryRec.VALIDATE(Quantity);
                            //      JobBudgetEntryRec.MODIFY;
                            //     END;

                        END;
                        IF ModUOM <> '' THEN BEGIN
                            Rec."Base UOM" := ModUOM;
                        END;
                        IF "ModUnit Cost" <> 0 THEN BEGIN
                            Rec."Unit Cost" := "ModUnit Cost";
                            Rec."Unit Price" := "ModUnit Cost";

                            Rec.VALIDATE("Unit Cost");
                            Rec.VALIDATE("Unit Price");


                            JobBudgetLineRec.RESET;
                            JobBudgetLineRec.SETRANGE("Entry No.", Rec."Entry No.");
                            JobBudgetLineRec.SETFILTER(JobBudgetLineRec."Job No.", Rec."Project Code");
                            IF JobBudgetLineRec.FINDFIRST THEN BEGIN
                                JobBudgetLineRec."Direct Unit Cost (LCY)" := Rec."Unit Price";
                                JobBudgetLineRec."Unit Price" := Rec."Unit Price";
                                JobBudgetLineRec.VALIDATE("Unit Price");
                                JobBudgetLineRec.MODIFY;
                            END;
                            PhaseRec.RESET;
                            PhaseRec.SETFILTER("Job No.", Rec."Project Code");
                            PhaseRec.SETRANGE(PhaseRec."Entry No.", Rec."Entry No.");
                            IF PhaseRec.FINDFIRST THEN BEGIN
                                PhaseRec."BOQ Amt." := "ModUnit Cost";
                                PhaseRec."Pending Amt." := Rec."Total Price";
                                PhaseRec."BOQ Amt." := Rec."Total Price";
                                PhaseRec.MODIFY;
                            END;


                            ProBudgetLineRec.RESET;
                            ProBudgetLineRec.SETRANGE("Entry No.", Rec."Entry No.");
                            ProBudgetLineRec.SETFILTER(ProBudgetLineRec."Job No.", Rec."Project Code");
                            IF ProBudgetLineRec.FINDFIRST THEN BEGIN
                                ProBudgetLineRec."Unit Price" := "ModUnit Cost";
                                ProBudgetLineRec.VALIDATE("Unit Price");
                                ProBudgetLineRec.MODIFY;
                            END;

                            /*
                             JobBudgetEntryRec.RESET;
                             JobBudgetEntryRec.SETRANGE("Entry No.","Entry No.");
                             JobBudgetEntryRec.SETFILTER(JobBudgetEntryRec."Job No.","Project Code");
                             IF JobBudgetEntryRec.FINDFIRST THEN
                              BEGIN
                               JobBudgetEntryRec."Total Cost":="ModUnit Cost";
                               JobBudgetEntryRec.VALIDATE("Total Cost");
                               JobBudgetEntryRec.MODIFY;
                              END;
                            */
                        END;
                        Rec.MODIFY;

                        MESSAGE('Task Successfully performed');
                    END;

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", '%1', 'BOQMOD');
        IF NOT Memberof.FINDFIRST THEN
            ERROR('Sorry, You are not authorised to perform this task');
    end;

    var
        PhaseRec: Record "Job Task";
        JobBudgetLineRec: Record "Job Planning Line";
        ProBudgetLineRec: Record "Project Budget Line Buffer";
        ModType: Option " ",,"G/L Account";
        ModQuantity: Decimal;
        ModUOM: Code[20];
        "ModUnit Cost": Decimal;
        uom: Record "Unit of Measure";
        Memberof: Record "Access Control";
}

