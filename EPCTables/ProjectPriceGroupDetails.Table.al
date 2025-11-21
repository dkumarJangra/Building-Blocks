table 97754 "Project Price Group Details"
{

    fields
    {
        field(1; "Project Price Group"; Code[20])
        {
            Editable = false;
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(2; "Starting Date"; Date)
        {
        }
        field(3; "Ending Date"; Date)
        {
        }
        field(4; "Sales Rate (per sq ft)"; Decimal)
        {

            trigger OnValidate()
            begin
                IF CONFIRM('The Change in Rate will effect in Charge Type, PLC & UNIT Masters', TRUE) THEN BEGIN
                    DocMasRec.RESET;
                    DocMasRec.SETFILTER(DocMasRec."Project Price Dependency Code", "Project Price Group");
                    DocMasRec.SETFILTER("Project Code", "Project Code");
                    IF DocMasRec.FINDFIRST THEN BEGIN
                        DocMasRec."Rate/Sq. Yd" := "Sales Rate (per sq ft)";
                        DocMasRec.MODIFY;
                    END;

                    PLCRec.RESET;
                    PLCRec.SETFILTER("Job Code", "Project Code");
                    PLCRec.SETFILTER("PLC Dependency Code", "Project Price Group");
                    IF PLCRec.FINDFIRST THEN
                        REPEAT
                            PLCRec.TESTFIELD(PLCRec."PLC %");
                            PLCRec."PLC % Amount" := "Sales Rate (per sq ft)" * PLCRec."PLC %" / 100;
                            PLCRec.MODIFY;
                        UNTIL PLCRec.NEXT = 0;

                    ItemRec.RESET;
                    ItemRec.SETFILTER("Project Code", "Project Code");
                    ItemRec.SETRANGE("Property Unit", TRUE);
                    IF ItemRec.FINDFIRST THEN
                        REPEAT
                            SHeadRec.RESET;
                            SHeadRec.SETRANGE("Document Type", SHeadRec."Document Type"::Order);
                            SHeadRec.SETFILTER("Item Code", ItemRec."No.");
                            IF SHeadRec.FINDFIRST THEN BEGIN
                            END
                            ELSE BEGIN
                                PLCDetails.RESET;
                                PLCDetails.SETFILTER("Job Code", "Project Code");
                                PLCDetails.SETFILTER(Code, '<>%1', '');
                                PLCDetails.SETFILTER("Item Code", ItemRec."No.");
                                IF PLCDetails.FINDFIRST THEN
                                    REPEAT
                                        PLCRec.RESET;
                                        PLCRec.SETFILTER(Code, PLCDetails.Code);
                                        PLCRec.SETFILTER(PLCRec."PLC Dependency Code", '<>%1', '');
                                        IF PLCRec.FINDFIRST THEN
                                            PLCDetails.Amount := ItemRec."Saleable Area (sq ft)" * PLCRec."PLC % Amount";
                                        PLCDetails.MODIFY;
                                    UNTIL PLCDetails.NEXT = 0;
                            END;
                        UNTIL ItemRec.NEXT = 0;
                    MESSAGE('Task Performed Successfuly');
                END;
            end;
        }
        field(5; "Lease Rate (per sq ft)"; Decimal)
        {

            trigger OnValidate()
            begin
                IF CONFIRM('The Change in Rate will effect in Charge Type, PLC & UNIT Masters', TRUE) THEN BEGIN

                    DocMasRec.RESET;
                    DocMasRec.SETFILTER(DocMasRec."Project Price Dependency Code", "Project Price Group");
                    DocMasRec.SETFILTER("Project Code", "Project Code");
                    IF DocMasRec.FINDFIRST THEN BEGIN
                        DocMasRec."Rate/Sq. Yd" := "Lease Rate (per sq ft)";
                        DocMasRec.MODIFY;
                    END;

                    PLCRec.RESET;
                    PLCRec.SETFILTER("Job Code", "Project Code");
                    PLCRec.SETFILTER("PLC Dependency Code", "Project Price Group");
                    IF PLCRec.FINDFIRST THEN
                        REPEAT
                            PLCRec.TESTFIELD(PLCRec."PLC %");
                            PLCRec."PLC % Amount" := "Lease Rate (per sq ft)" * PLCRec."PLC %" / 100;
                            PLCRec.MODIFY;
                        UNTIL PLCRec.NEXT = 0;

                    ItemRec.RESET;
                    ItemRec.SETFILTER("Project Code", "Project Code");
                    ItemRec.SETRANGE("Property Unit", TRUE);
                    IF ItemRec.FINDFIRST THEN
                        REPEAT
                            SHeadRec.RESET;
                            SHeadRec.SETRANGE("Document Type", SHeadRec."Document Type"::Order);
                            SHeadRec.SETFILTER("Item Code", ItemRec."No.");
                            IF SHeadRec.FINDFIRST THEN BEGIN
                            END
                            ELSE BEGIN
                                PLCDetails.RESET;
                                PLCDetails.SETFILTER("Job Code", "Project Code");
                                PLCDetails.SETFILTER(Code, '<>%1', '');
                                PLCDetails.SETFILTER("Item Code", ItemRec."No.");
                                IF PLCDetails.FINDFIRST THEN
                                    REPEAT
                                        PLCRec.RESET;
                                        PLCRec.SETFILTER(Code, PLCDetails.Code);
                                        PLCRec.SETFILTER(PLCRec."PLC Dependency Code", '<>%1', '');
                                        IF PLCRec.FINDFIRST THEN
                                            PLCDetails.Amount := ItemRec."Saleable Area (sq ft)" * PLCRec."PLC % Amount";
                                        PLCDetails.MODIFY;
                                    UNTIL PLCDetails.NEXT = 0;
                            END;
                        UNTIL ItemRec.NEXT = 0;
                    MESSAGE('Task Performed Successfuly');
                END;
            end;
        }
        field(6; "Project Code"; Code[20])
        {
            Editable = false;
            TableRelation = Job;
        }
    }

    keys
    {
        key(Key1; "Project Code", "Project Price Group", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DocMasRec: Record "Document Master";
        PLCRec: Record PLC;
        ItemRec: Record Item;
        SHeadRec: Record "Sales Header";
        PLCDetails: Record "PLC Details";
}

