page 98010 "Unit Setup"
{
    // //ALLEDK 210921 Added new field -21.09  Minimum Allotement %

    PageType = Document;
    SourceTable = "Unit Setup";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Service Charge Amount"; Rec."Service Charge Amount")
                {
                    Caption = 'Service Charge Amount';
                }
                field("Cash Max. Amount"; Rec."Cash Max. Amount")
                {
                }
                field("Service Charge Account"; Rec."Service Charge Account")
                {
                    Caption = 'Service charge A/C';
                }
                field("Cash Amount Limit"; Rec."Cash Amount Limit")
                {
                }
                field("Discount Allowed on Bond A/C"; Rec."Discount Allowed on Bond A/C")
                {
                }
                field("Interest A/C"; Rec."Interest A/C")
                {
                    Caption = 'Appreciation A/C';
                }
                field("Interest Payable A/C"; Rec."Interest Payable A/C")
                {
                    Caption = 'Appreciation Payable A/C';
                }
                field("Cash A/c No."; Rec."Cash A/c No.")
                {
                }
                field("Bank A/C No."; Rec."Bank A/C No.")
                {
                }
                field("Cheque in Hand"; Rec."Cheque in Hand")
                {
                }
                field("DD in Hand"; Rec."DD in Hand")
                {
                }
                field("Bond Reversal Control A/c"; Rec."Bond Reversal Control A/c")
                {
                    Caption = 'Unit Reversal Control A/c';
                }
                field("Revenue A/C"; Rec."Revenue A/C")
                {
                }
                field("Transfer A/c"; Rec."Transfer A/c")
                {
                }
                field("Customer No Series"; Rec."Customer No Series")
                {
                }
                field("No. of Cheque Buffer Days"; Rec."No. of Cheque Buffer Days")
                {
                    Caption = 'Cheque Cl. Grace Days';
                }
                field("D.C./C.C./Net Banking A/c No."; Rec."D.C./C.C./Net Banking A/c No.")
                {
                    Caption = 'D.C./C.C./Net Banking A/c No.';
                }
                field("Last Incent. Calculation Date"; Rec."Last Incent. Calculation Date")
                {
                }
                field("Hierarchy Head"; Rec."Hierarchy Head")
                {
                }
                field("Unit R/O"; Rec."Unit R/O")
                {
                    Caption = 'UnitUpload R/O';
                }
                field("LD Account"; Rec."LD Account")
                {
                }
                field("Forfeit Account"; Rec."Forfeit Account")
                {
                }
                field("Excess Payment Account"; Rec."Excess Payment Account")
                {
                }
                field("BBG Discount Account"; Rec."BBG Discount Account")
                {
                }
                field("Application Cutoff Amount"; Rec."Application Cutoff Amount")
                {
                }
                field("Application Cutoff Period"; Rec."Application Cutoff Period")
                {
                }
                field("Application Cutoff Period 2"; Rec."Application Cutoff Period 2")
                {
                }
                field("Corpus %"; Rec."Corpus %")
                {
                    Caption = 'Club-9 Charge %';
                }
                field("Corpus A/C"; Rec."Corpus A/C")
                {
                    Caption = 'Club-9 Charge A/C';
                }
                field("Corpus Amt. Rounding Precision"; Rec."Corpus Amt. Rounding Precision")
                {
                    Caption = 'Club-9 Charge Amt. Rounding Precision';
                }
                field("Cheque Date Validity"; Rec."Cheque Date Validity")
                {
                    Caption = 'Chq. Dt. Before Days';
                }
                field("Ch. Dt. After Days"; Rec."Ch. Dt. After Days")
                {
                }
                field("Customer Template Code"; Rec."Customer Template Code")
                {
                }
                field("Bonus Calculation"; Rec."Bonus Calculation")
                {
                }
                field("Dr. Source Code"; Rec."Dr. Source Code")
                {
                }
                field("Cr. Source Code"; Rec."Cr. Source Code")
                {
                }
                field("Refund Cash A/C"; Rec."Refund Cash A/C")
                {
                }
                field("Refund Cheque A/C"; Rec."Refund Cheque A/C")
                {
                }
                field("Transfer Member Temp Name"; Rec."Transfer Member Temp Name")
                {
                }
                field("Transfer Member Batch Name"; Rec."Transfer Member Batch Name")
                {
                }
                field("Transfer Control Account"; Rec."Transfer Control Account")
                {
                }
                field("AJVM Transfer BankAccount Code"; Rec."AJVM Transfer BankAccount Code")
                {

                }
                field("Assoc. Recov. Temp Name"; Rec."Assoc. Recov. Temp Name")
                {
                }
                field("Assoc. Recov. Batch Name"; Rec."Assoc. Recov. Batch Name")
                {
                }
                field("Project Change JV Account"; Rec."Project Change JV Account")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("ARM Doc TA No."; Rec."ARM Doc TA No.")
                {
                }
                field("SMS Password"; Rec."SMS Password")
                {
                    ExtendedDatatype = Masked;
                }
                field("SMS Start Date"; Rec."SMS Start Date")
                {

                    trigger OnValidate()
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        Memberof.RESET;
                        Memberof.SETRANGE("User ID",USERID);
                        Memberof.SETRANGE("Role ID",'A_GOLDCOINSETUP');
                        IF NOT Memberof.FINDFIRST THEN
                          ERROR('Please contact Admin Department');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                    end;
                }
                field("Silver Coin Item No."; Rec."Silver Coin Item No.")
                {
                }
                field("Gold/Silver Voucher Item Code"; Rec."Gold/Silver Voucher Item Code")
                {
                }
                field("Gold/Silver Voucher Template"; Rec."Gold/Silver Voucher Template")
                {

                }
                field("Gold/Silver Voucher Batch"; Rec."Gold/Silver Voucher Batch")
                {

                }

                field("Gift Control A/c"; Rec."Gift Control A/c")
                {

                }
                field("Gift Vendor Rank Code"; Rec."Gift Vendor Rank Code")
                {

                }
                field("Perquisite to Associates Exp."; Rec."Perquisite to Associates Exp.")
                {
                }
                field("TDS Nature of Deducation 194R"; Rec."TDS Nature of Deducation 194R")
                {
                }
                field("Gift Inventory Account"; Rec."Gift Inventory Account")
                {
                }

                field("Incentive elegiblity App. AJVM"; Rec."Incentive elegiblity App. AJVM")
                {
                }
                field("Sales G/L Account"; Rec."Sales G/L Account")
                {
                }
                field("Customer Receipt Path"; Rec."Customer Receipt Path")
                {
                }
                field("Payment Link"; Rec."Payment Link")
                {
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                }
                field("GST Group Type"; Rec."GST Group Type")
                {
                }
                field("GST Place of Supply"; Rec."GST Place of Supply")
                {
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                }
                field("Development Charge A/C No."; Rec."Development Charge A/C No.")
                {
                }
                field("Varita Sales GL Account No."; Rec."Varita Sales GL Account No.")
                {
                }
                field("Verita Bank"; Rec."Verita Bank")
                {
                }
                field("Gold No. Series for Proj Chang"; Rec."Gold No. Series for Proj Chang")
                {
                }
                field("Sales Threshold Amount"; Rec."Sales Threshold Amount")
                {
                }
                field("Save Customer Receipt Path"; Rec."Save Customer Receipt Path")
                {
                }
                field("Associate Mail Image Path"; Rec."Associate Mail Image Path")
                {
                }
                field("Associate Document Path"; Rec."Associate Document Path")
                {
                }
                field("Plot Vacate minutes"; Rec."Plot Vacate minutes")
                {
                }
                field("Mobile URL Caption"; Rec."Mobile URL Caption")
                {
                }
                field("Mobile URL"; Rec."Mobile URL")
                {
                }
                field("Online Booking Single Plot"; Rec."Online Booking Single Plot")
                {
                    Editable = false;
                }
                field("Online Booking Double Plot"; Rec."Online Booking Double Plot")
                {
                    Editable = false;
                }
                field("Customer Welcome letter Path"; Rec."Customer Welcome letter Path")
                {
                }
                field("Transfer Days for Option A"; Rec."Transfer Days for Option A")
                {
                }
                field("Transfer Days for Option B"; Rec."Transfer Days for Option B")
                {
                }
                field("Transfer Days for Option C"; Rec."Transfer Days for Option C")
                {
                }
                field("Android Version"; Rec."Android Version")
                {
                }
                field("Allow No. of Associate Online"; Rec."Allow No. of Associate Online")
                {
                }
                field("Android Update Forcefully"; Rec."Android Update Forcefully")
                {
                }
                field("IOS Version"; Rec."IOS Version")
                {
                }
                field("IOS Update Forcefullt"; Rec."IOS Update Forcefullt")
                {
                }
                field("Start Process Date for A-B-C"; Rec."Start Process Date for A-B-C")
                {
                }
                field("Buffer Days for Food Court"; Rec."Buffer Days for Food Court")
                {
                }
                field("Android API URL"; Rec."Android API URL")
                {
                }
                field("Android Version Name"; Rec."Android Version Name")
                {
                }
                field("No. Entries show in Mobile App"; Rec."No. Entries show in Mobile App")
                {
                }
                field("Gamification Start Date"; Rec."Gamification Start Date")
                {
                }
                field("Gamification End Date"; Rec."Gamification End Date")
                {
                }
            }
            group("Land Agreement")
            {
                field("Land Refund Payment Template"; Rec."Land Refund Payment Template")
                {
                }
                field("Land Refund Payment Batch"; Rec."Land Refund Payment Batch")
                {
                }
                field("Land Agreement Exp. Template"; Rec."Land Agreement Exp. Template")
                {
                }
                field("Land Agreement Exp. Batch"; Rec."Land Agreement Exp. Batch")
                {
                }
                field("Land Agreement No.Series"; Rec."Land Agreement No.Series")
                {
                }
                field("Land Refund No. Series"; Rec."Land Refund No. Series")
                {
                }
            }
            group(Bonus)
            {
                Caption = 'Bonus';
                field("RoundingOff(Bonus)"; Rec."RoundingOff(Bonus)")
                {
                }
                field("Bonus Voucher Payment Period"; Rec."Bonus Voucher Payment Period")
                {
                }
                field("Bonus Dr. Source Code"; Rec."Bonus Dr. Source Code")
                {
                }
                field("Bonus Payable A/c"; Rec."Bonus Payable A/c")
                {
                    Caption = 'Perform Bonus Payable A/c';
                }
                field("Bonus A/c"; Rec."Bonus A/c")
                {
                    Caption = 'Performance Bonus A/c';
                }
                field("Bonus Reversal A/c"; Rec."Bonus Reversal A/c")
                {
                }
            }
            group(Commission)
            {
                Caption = 'Commission';
                field("Comm Voucher Payment Period"; Rec."Comm Voucher Payment Period")
                {
                }
                field("Commission Validate Period"; Rec."Commission Validate Period")
                {
                }
                field("TDS Nature of Deduction"; Rec."TDS Nature of Deduction")
                {
                }
                field("Comm. Voucher Threshold Amount"; Rec."Comm. Voucher Threshold Amount")
                {
                }
                field("Comm. Voucher Source Code"; Rec."Comm. Voucher Source Code")
                {
                }
                field("Commission Payable A/C"; Rec."Commission Payable A/C")
                {
                }
                field("Commission A/C"; Rec."Commission A/C")
                {
                }
                field("TDS Payable Commission A/c"; Rec."TDS Payable Commission A/c")
                {
                }
                field("Rounding Account(Commission)"; Rec."Rounding Account(Commission)")
                {
                }
                field("Club9 General Journal Template"; Rec."Club9 General Journal Template")
                {
                    ApplicationArea = all;
                }
                field("Club9 General Journal Batch"; Rec."Club9 General Journal Batch")
                {
                    ApplicationArea = all;
                }
            }
            group(Travel)
            {
                Caption = 'Travel';
                field("Travel Template Name"; Rec."Travel Template Name")
                {
                }
                field("Travel Template Batch Name"; Rec."Travel Template Batch Name")
                {
                }
                field("Travel A/C"; Rec."Travel A/C")
                {
                }
                field("TDS Nature of Deduction TA"; Rec."TDS Nature of Deduction TA")
                {
                }
            }
            group(Incentive)
            {
                Caption = 'Incentive';
                field("Incentive Voucher Source Code"; Rec."Incentive Voucher Source Code")
                {
                }
                field("Incentive A/C"; Rec."Incentive A/C")
                {
                }
                field("TDS Nature of Deduction INCT"; Rec."TDS Nature of Deduction INCT")
                {
                }
            }
            group("No. Series")
            {
                Caption = 'No. Series';
                field("Application Nos."; Rec."Application Nos.")
                {
                }
                field("Pmt Sch. Posting No. Series"; Rec."Pmt Sch. Posting No. Series")
                {
                }
                field("Registration No. Series"; Rec."Registration No. Series")
                {
                }
                field("Penalty No. Series"; Rec."Penalty No. Series")
                {
                }
                field("Voucher No. Series"; Rec."Voucher No. Series")
                {
                }
                field("Bank Voucher Template Name"; Rec."Bank Voucher Template Name")
                {
                }
                field("Bank Voucher Batch Name"; Rec."Bank Voucher Batch Name")
                {
                }
                field("Cash Voucher Template Name"; Rec."Cash Voucher Template Name")
                {
                }
                field("Cash Voucher Batch Name"; Rec."Cash Voucher Batch Name")
                {
                }
                field("Posting Voucher No. Series"; Rec."Posting Voucher No. Series")
                {
                    Caption = 'Associate Pmt Voucher No';
                }
                field("Travel No. Series"; Rec."Travel No. Series")
                {
                }
                field("Comm. No. Series"; Rec."Comm. No. Series")
                {
                }
                field("Comm. Payable No. Series"; Rec."Comm. Payable No. Series")
                {
                }
                field("Comm. No. Series (Full Chain)"; Rec."Comm. No. Series (Full Chain)")
                {
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("Bonus No. Series"; Rec."Bonus No. Series")
                {
                }
                field("Bonus Payable No. Series"; Rec."Bonus Payable No. Series")
                {
                }
                field("Bonus No. Series (Full Chain)"; Rec."Bonus No. Series (Full Chain)")
                {
                }
                field("Token No."; Rec."Token No.")
                {
                }
                field("Intercompany Sales NoSeries"; Rec."Intercompany Sales NoSeries")
                {
                }
                field("Intercompany Purchase NoSeries"; Rec."Intercompany Purchase NoSeries")
                {
                }
                field("Intercompany Purch. NoSeries"; Rec."Intercompany Purch. NoSeries")
                {
                }
                field("Intercompany Purch.Cr NoSeries"; Rec."Intercompany Purch.Cr NoSeries")
                {
                }
                field("Intercompany Sales Cr NoSeries"; Rec."Intercompany Sales Cr NoSeries")
                {
                }
                field("Incentive Setup No. Series"; Rec."Incentive Setup No. Series")
                {
                }
                field("Incentive No."; Rec."Incentive No.")
                {
                }
                field("Incentive Summary No."; Rec."Incentive Summary No.")
                {
                }
                field("Incentive Summary Buffer No."; Rec."Incentive Summary Buffer No.")
                {
                }
                field("Associate to Member No. Series"; Rec."Associate to Member No. Series")
                {
                }
                field("Member to Member No. Series"; Rec."Member to Member No. Series")
                {
                }
                field("Refund No. Series"; Rec."Refund No. Series")
                {
                }
                field("Discount No. Sereies"; Rec."Discount No. Sereies")
                {
                }
                field("Cheque Bounce JV No. Series"; Rec."Cheque Bounce JV No. Series")
                {
                }
                field("Adjustment Entry No. Series"; Rec."Adjustment Entry No. Series")
                {
                }
                field("Post Incentive No."; Rec."Post Incentive No.")
                {
                    Caption = 'Post Incentive Details No. Series';
                }
                field("Post Inct Summary No."; Rec."Post Inct Summary No.")
                {
                    Caption = 'Post Inct Summary No Series';
                }
                field("Asso. Pmt Voucher No. Series"; Rec."Asso. Pmt Voucher No. Series")
                {
                }
                field("Posted TA Credit Memo"; Rec."Posted TA Credit Memo")
                {
                }
                field("Bar Code no. Series"; Rec."Bar Code no. Series")
                {
                }
                field("Application Sales No. Series"; Rec."Application Sales No. Series")
                {
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                field("Excel File Save Path"; Rec."Excel File Save Path")
                {
                }
                field("Report Batch No. Series"; Rec."Report Batch No. Series")
                {
                }
                field("Report to CC"; Rec."Report to CC")
                {
                }
                group("Commission Batch Run")
                {
                    Caption = 'Commission Batch Run';
                    field("Commission Batch Run Date"; Rec."Commission Batch Run Date")
                    {
                    }
                }
                group("Filter for Report 50011_50082 (Commission Eligibility Report)")
                {
                    Caption = 'Filter for Report 50011_50082 (Commission Eligibility Report)';
                    field("Report Run Date"; Rec."Report Run Date")
                    {
                    }
                }
                group("Filter for Report 50041 (New Team CollectionDetail)")
                {
                    Caption = 'Filter for Report 50041 (New Team CollectionDetail)';
                    field("Report Run Start Date"; Rec."Report Run Start Date")
                    {
                    }
                    field("Report Run End Date"; Rec."Report Run End Date")
                    {
                    }
                    field("Collection Cutoff Date"; Rec."Collection Cutoff Date")
                    {
                    }
                    field("Direct/Team"; Rec."Direct/Team")
                    {
                    }
                    field("Incl. Uncleared Cheque"; Rec."Incl. Uncleared Cheque")
                    {
                    }
                }
                group("Filter for Report 50096 (New Booking/Allotment/TA)")
                {
                    Caption = 'Filter for Report 50096 (New Booking/Allotment/TA)';
                    field("Report Run Start Date_1"; Rec."Report Run Start Date_1")
                    {
                        Caption = 'Start Date';
                    }
                    field("Report Run End Date_1"; Rec."Report Run End Date_1")
                    {
                        Caption = 'End Date';
                    }
                    field("Collection Cutoff Date_1"; Rec."Collection Cutoff Date_1")
                    {
                        Caption = 'Collection Cutoff Date';
                    }
                    field("Direct/Team_1"; Rec."Direct/Team_1")
                    {
                        Caption = 'Direct/Team';
                    }
                    field("Incl. Uncleared Cheque_1"; Rec."Incl. Uncleared Cheque_1")
                    {
                        Caption = 'Incl. Uncleared Cheque';
                    }
                    field("Show All Applications_1"; Rec."Show All Applications_1")
                    {
                        Caption = 'Show All Applications';
                    }
                }
                group("Filter for Report 97782 (New Associate Drawing Ledger)")
                {
                    Caption = 'Filter for Report 97782 (New Associate Drawing Ledger)';
                    field("Report Run Start Date_2"; Rec."Report Run Start Date_2")
                    {
                        Caption = 'Start Date';
                    }
                    field("Report Run End Date_2"; Rec."Report Run End Date_2")
                    {
                        Caption = 'End Date';
                    }
                    field("Post Type Filter"; Rec."Post Type Filter")
                    {
                    }
                    field("Payment Filters"; Rec."Payment Filters")
                    {
                    }
                }
            }
            group(Intercompany)
            {
                Caption = 'Intercompany';
                field("Intercompany Purchase Account"; Rec."Intercompany Purchase Account")
                {
                }
                field("Intercompany Sales Account"; Rec."Intercompany Sales Account")
                {
                }
                field("Purchase_Sales Vendor No."; Rec."Purchase_Sales Vendor No.")
                {
                }
                field("Purchase_Sales Customer No."; Rec."Purchase_Sales Customer No.")
                {
                }
            }
            group(AssociateImageEmail)             //040225 Added new field
            {
                Caption = 'Associate Email Image';
                field("Associate Mail Image"; Rec."Associate Mail Image")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTip = 'Specifies the picture that has been set up for the company, such as a company logo.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }

            }

        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        Text19073926: Label 'Source Code';
        UserSetup: Record "User Setup";
}

