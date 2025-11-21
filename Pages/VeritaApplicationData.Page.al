page 50154 "Verita Application Data"
{
    PageType = List;
    SourceTable = "Verita Application Data";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Tally Document No."; Rec."Tally Document No.")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Total Developmnt Charge Amount"; Rec."Total Developmnt Charge Amount")
                {
                }
                field("Development Receipt Amount"; Rec."Development Receipt Amount")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                }
                field("Ch. Clearance / Bounce Date"; Rec."Ch. Clearance / Bounce Date")
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                }
                field("Project code"; Rec."Project code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                }
                field("GST Group Type"; Rec."GST Group Type")
                {
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                }
                field("GST Base mount"; Rec."GST Base mount")
                {
                }
                field("CGST Amount"; Rec."CGST Amount")
                {
                }
                field("SGST Amount"; Rec."SGST Amount")
                {
                }
                field("IGST Amount"; Rec."IGST Amount")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Receipt Lines")
            {

                trigger OnAction()
                var
                    ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
                    VeritaApplicationData: Record "Verita Application Data";
                    LineNo: Integer;
                    NewConfirmedOrder: Record "New Confirmed Order";
                    Cust: Record Customer;
                    OldApplicationDevelopmentLine: Record "New Application DevelopmntLine";
                    Customer: Record Customer;
                begin
                    VeritaApplicationData.RESET;
                    VeritaApplicationData.SETRANGE("Create Charge Lines", FALSE);
                    VeritaApplicationData.SETRANGE("Posting Date", 20180305D, 20180330D);
                    IF VeritaApplicationData.FINDSET THEN
                        REPEAT
                            VeritaApplicationData.TESTFIELD("Application No.");
                            VeritaApplicationData.TESTFIELD("Customer No.");
                            VeritaApplicationData.TESTFIELD("Development Receipt Amount");
                            VeritaApplicationData.TESTFIELD("Total Developmnt Charge Amount");
                            NewConfirmedOrder.GET(VeritaApplicationData."Application No.");
                            NewConfirmedOrder.TESTFIELD("Customer No.");
                            IF NewConfirmedOrder."Customer No." <> VeritaApplicationData."Customer No." THEN
                                ERROR('Customer no. differ to Confirmed order for application No.' + VeritaApplicationData."Application No.");
                            OldApplicationDevelopmentLine.RESET;
                            OldApplicationDevelopmentLine.SETRANGE("Application No.", VeritaApplicationData."Application No.");
                            IF OldApplicationDevelopmentLine.FINDLAST THEN
                                LineNo := OldApplicationDevelopmentLine."Line No."
                            ELSE
                                LineNo := 0;
                            ApplicationDevelopmentLine.INIT;
                            ApplicationDevelopmentLine."Document Type" := ApplicationDevelopmentLine."Document Type"::BOND;
                            ApplicationDevelopmentLine."Document No." := VeritaApplicationData."Application No.";
                            ApplicationDevelopmentLine."Line No." := LineNo + 10000;
                            ApplicationDevelopmentLine."Unit Code" := VeritaApplicationData."Unit Code";
                            ApplicationDevelopmentLine."Payment Method" := 'Cheque';
                            ApplicationDevelopmentLine.Description := '';
                            ApplicationDevelopmentLine.Amount := VeritaApplicationData."Development Receipt Amount";
                            ApplicationDevelopmentLine."Cheque No./ Transaction No." := COPYSTR(VeritaApplicationData."Cheque No.", 1, 20);
                            ApplicationDevelopmentLine."Cheque Date" := VeritaApplicationData."Cheque Date";
                            ApplicationDevelopmentLine."Cheque Bank and Branch" := VeritaApplicationData."Cheque Bank and Branch";
                            ApplicationDevelopmentLine."Cheque Status" := ApplicationDevelopmentLine."Cheque Status"::Cleared;
                            ApplicationDevelopmentLine."Chq. Cl / Bounce Dt." := VeritaApplicationData."Ch. Clearance / Bounce Date";
                            ApplicationDevelopmentLine."Application No." := VeritaApplicationData."Application No.";
                            ApplicationDevelopmentLine."Payment Mode" := ApplicationDevelopmentLine."Payment Mode"::Bank;
                            ApplicationDevelopmentLine."Bank Type" := ApplicationDevelopmentLine."Bank Type"::VeritaCompany;
                            ApplicationDevelopmentLine."Shortcut Dimension 1 Code" := VeritaApplicationData."Project code";
                            ApplicationDevelopmentLine."Document Date" := VeritaApplicationData."Posting Date";
                            ApplicationDevelopmentLine."Posting date" := VeritaApplicationData."Posting Date";
                            ApplicationDevelopmentLine."User Branch Code" := '110700';
                            ApplicationDevelopmentLine."User ID" := USERID;
                            ApplicationDevelopmentLine."Company Name" := NewConfirmedOrder."Company Name";
                            ApplicationDevelopmentLine."Create from MSC Company" := TRUE;
                            ApplicationDevelopmentLine."GST Group Code" := VeritaApplicationData."GST Group Code";
                            ApplicationDevelopmentLine."HSN/SAC Code" := VeritaApplicationData."HSN/SAC Code";
                            ApplicationDevelopmentLine."Location Code" := VeritaApplicationData."Project code";
                            ApplicationDevelopmentLine.VALIDATE("Deposit/Paid Bank", VeritaApplicationData."Deposit/Paid Bank");
                            ApplicationDevelopmentLine."Verita Data upload" := TRUE;
                            ApplicationDevelopmentLine.Posted := TRUE;
                            ApplicationDevelopmentLine.INSERT;
                            VeritaApplicationData."Create Charge Lines" := TRUE;
                            VeritaApplicationData.MODIFY;
                        UNTIL VeritaApplicationData.NEXT = 0;
                    MESSAGE('%1', 'Process Done');
                end;
            }
            action("Update Customer")
            {

                trigger OnAction()
                var
                    v_Customer: Record Customer;
                    VeritaApplicationData: Record "Verita Application Data";
                    NewConfirmedOrder: Record "New Confirmed Order";
                begin
                    VeritaApplicationData.RESET;
                    VeritaApplicationData.SETRANGE("Posting Date", 20180305D, 20180331D);
                    IF VeritaApplicationData.FINDSET THEN
                        REPEAT
                            NewConfirmedOrder.GET(VeritaApplicationData."Application No.");
                            NewConfirmedOrder.TESTFIELD("Customer No.");
                            v_Customer.RESET;
                            v_Customer.CHANGECOMPANY('BUILDING BLOCKS PROPERTIES LLP');
                            IF v_Customer.GET(VeritaApplicationData."Customer No.") THEN BEGIN
                                IF v_Customer."State Code" = '' THEN
                                    v_Customer."State Code" := 'TG';
                                IF v_Customer."GST Customer Type" = v_Customer."GST Customer Type"::" " THEN
                                    v_Customer."GST Customer Type" := v_Customer."GST Customer Type"::Unregistered;
                                v_Customer.MODIFY;
                            END;
                        UNTIL VeritaApplicationData.NEXT = 0;
                    MESSAGE('%1', 'Customer updated');
                end;
            }
        }
    }
}

