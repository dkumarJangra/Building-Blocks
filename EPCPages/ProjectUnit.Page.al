page 97778 "Project Unit"
{
    PageType = Card;
    SourceTable = "Job Master";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Project Code"; "Project Code")
                {
                    Caption = 'Project Code';
                }
                field("Sub Project Code"; "Sub Project Code")
                {
                    Caption = 'Sub Project Code';
                }
                field("Code"; "Project Unit".Code)
                {
                    Caption = 'Code';
                }
                field(Name; "Project Unit".Name)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Group)
            {
                action(Vendor)
                {
                    RunObject = Page "Product Vendors";
                    RunPageLink = Type = FILTER("Job Master"),
                                  "No." = FIELD(Code);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        JobSetup.GET;
        IF "Project Code" = '' THEN ERROR(Err2);
        IF "Project Code" <> '' THEN BEGIN

        END;
    end;

    var
        "Project Code": Code[20];
        GLSetUp: Record "General Ledger Setup";
        "Project Unit": Record "Dimension Value";
        Item: Record "Unit Master";
        "Item Dimension": Record "Default Dimension";
        ProjectPriceGroupCode: Code[20];
        ProjectPriceGroup: Record "Document Master";
        JobSetup: Record "Jobs Setup";
        ProjectPriceDtl: Record "Project Price Group Details";
        "Sub Project Code": Code[20];
        DimValRec: Record "Dimension Value";
        Type: Option " ",Flat,Plot,"Commercial Space",Villa,Shop,"Row House";
        Err1: Label 'Please Enter the Code';
        Err2: Label 'Project Code is Blank';


    procedure SetProjectCode(PProjectCode: Code[20])
    begin
        "Project Code" := PProjectCode;
    end;
}

