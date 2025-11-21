pageextension 50076 "BBG Workflow Templates Ext" extends "Workflow Templates"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Description)
        {
            field("Workflow Code"; Rec."Workflow Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("New Workflow from Template")
        {
            group(Process)
            {
                Caption = 'Process';
                action(ExportWorkflow)
                {
                    Caption = 'Export to File';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        Workflow: Record Workflow;
                        //TempBlob: Record TempBlob;
                        FileManagement: Codeunit "File Management";
                        "Filter": Text;
                    begin
                        Filter := GetFilterFromSelection;
                        IF Filter = '' THEN
                            EXIT;
                        Workflow.SETFILTER(Code, Filter);
                        // Workflow.ExportToBlob(TempBlob);
                        // FileManagement.BLOBExport(TempBlob, '*.xml', TRUE);
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
        WorkflowSetup: Codeunit "Workflow Setup";

    trigger OnOpenPage()
    begin
        //WorkflowSetup.InitWorkflowDTS; //Alle
    end;

    LOCAL PROCEDURE GetFilterFromSelection() Filter: Text;
    VAR
        TempWorkflowBuffer: Record "Workflow Buffer" TEMPORARY;
    BEGIN
        TempWorkflowBuffer.COPY(Rec, TRUE);
        CurrPage.SETSELECTIONFILTER(TempWorkflowBuffer);

        IF TempWorkflowBuffer.FINDSET THEN
            REPEAT
                IF TempWorkflowBuffer."Workflow Code" <> '' THEN
                    IF Filter = '' THEN
                        Filter := TempWorkflowBuffer."Workflow Code"
                    ELSE
                        Filter := STRSUBSTNO('%1|%2', Filter, TempWorkflowBuffer."Workflow Code");
            UNTIL TempWorkflowBuffer.NEXT = 0;
    END;
}