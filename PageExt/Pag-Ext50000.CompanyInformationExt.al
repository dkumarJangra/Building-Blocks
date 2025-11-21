pageextension 50000 "BBG Company Information Ext" extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter("SWIFT Code")
        {
            field("BBG IC Partner Code"; Rec."BBG IC Partner Code")
            {
                ApplicationArea = all;
            }
        }
        addafter(GLN)
        {
            field("Company Type"; Rec."Company Type")
            {
                ApplicationArea = all;
            }
            field("Development Company Name"; Rec."Development Company Name")
            {
                ApplicationArea = all;
            }
            field("Send LandVend Helpdesk Email"; Rec."Send LandVend Helpdesk Email")  //251124 new field
            {
                ApplicationArea = All;
            }
            field("Send New Land Request Email"; Rec."Send New Land Request Email")  //251124 new field
            {
                ApplicationArea = all;
            }
        }
        addafter(Picture)
        {
            field("Job Madetory On MRN"; Rec."Job Madetory On MRN")
            {
                ApplicationArea = all;
            }
            field("JV Fields Mandetory"; Rec."JV Fields Mandetory")
            {
                ApplicationArea = all;
            }
            field("Send SMS"; Rec."Send SMS")
            {
                ApplicationArea = all;
            }
            field("Send Welcome Customer Letter"; Rec."Send Welcome Customer Letter")
            {
                ApplicationArea = all;
            }
            field("Run Commission Batch"; Rec."Run Commission Batch")
            {
                ApplicationArea = all;
            }
            field("Double Plot Amount"; Rec."Double Plot Amount")
            {
                ApplicationArea = all;
            }
            field("Online Bank Account No."; Rec."Online Bank Account No.")
            {
                ApplicationArea = all;
            }
            field("Commission Threshold Amount"; Rec."Commission Threshold Amount")
            {
                ApplicationArea = all;
            }
            field("Incentive Threshold Amount"; Rec."Incentive Threshold Amount")
            {
                ApplicationArea = all;
            }
            field("Pmt. Threshold Time In Minutes"; Rec."Pmt. Threshold Time In Minutes")
            {
                ApplicationArea = all;
            }
            field("Payment E_Mail Address"; Rec."Payment E_Mail Address")
            {
                ApplicationArea = all;
            }
            field("Send mail for mobile login"; Rec."Send mail for mobile login")
            {
                ApplicationArea = all;
            }
            field("Start Day for Onboarding"; Rec."Start Day for Onboarding")
            {
                ApplicationArea = all;
            }
            field("End Day for Onboarding"; Rec."End Day for Onboarding")
            {
                ApplicationArea = all;
            }
            field("Send Customer Cheque BounceSMS"; Rec."Send Customer Cheque BounceSMS")
            {
                ApplicationArea = all;
                Caption = 'Send Customer Cheque Bounce SMS';
            }
        }
        addafter("Home Page")
        {
            field("Company Bank Account No."; Rec."Company Bank Account No.")
            {
                ApplicationArea = all;
            }
            field("Company Bank IFSC Code"; Rec."Company Bank IFSC Code")
            {
                ApplicationArea = all;
            }
            field("Company Branch Name"; Rec."Company Branch Name")
            {
                ApplicationArea = all;
            }

            field("Stop Data Push to WebApp"; Rec."Stop Data Push to WebApp")
            {
                ApplicationArea = all;
            }
        }
        addlast("User Experience")
        {
            group(Images)
            {
                field("Header Picture"; Rec."Header Picture")
                {
                    ApplicationArea = all;
                }
                field("Footer Picture"; Rec."Footer Picture")
                {
                    ApplicationArea = all;
                }
                field("Back Page Picture"; Rec."Back Page Picture")
                {
                    ApplicationArea = all;
                }
                field("Welcome Customer Letter"; Rec."Welcome Customer Letter")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Codes)
        {
            group(Picture)
            {
                Caption = 'Picture';
                action(Import)
                {
                    Caption = 'Import';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PictureExists := Rec.Picture.HASVALUE;
                        // IF Rec.Picture.IMPORT('*.BMP', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("E&xport")
                {
                    Caption = 'E&xport';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        // IF Rec.Picture.HASVALUE THEN
                        //     Rec.Picture.EXPORT('*.BMP', TRUE);
                    end;
                }
                action(Delete)
                {
                    Caption = 'Delete';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        IF Rec.Picture.HASVALUE THEN
                            IF CONFIRM(Text002, FALSE) THEN BEGIN
                                CLEAR(Rec.Picture);
                                CurrPage.SAVERECORD;
                            END;
                    end;
                }
                action("Gold Coin Import")
                {
                    Caption = 'Gold Coin Import';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PictureExists := Rec."Gold Coin Lable".HASVALUE;
                        // IF Rec."Gold Coin Lable".IMPORT('*.BMP', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("Gold Coin Import2")
                {
                    Caption = 'Gold Coin Import2';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //ALLECK 190313 START
                        PictureExists := Rec."Gold Coin Lable2".HASVALUE;
                        // IF Rec."Gold Coin Lable2".IMPORT('*.BMP', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                        //ALLECK 190313 END
                    end;
                }
                action("Receipt Header Import")
                {
                    Caption = 'Receipt Header Import';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PictureExists := Rec."Header Picture".HASVALUE;
                        // IF Rec."Header Picture".IMPORT('*.BMP', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("Receipt Footer Import")
                {
                    Caption = 'Receipt Footer Import';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PictureExists := Rec."Footer Picture".HASVALUE;
                        // IF Rec."Footer Picture".IMPORT('*.BMP', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("Receipt Back Page Import")
                {
                    Caption = 'Receipt Back Page Import';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PictureExists := Rec."Back Page Picture".HASVALUE;
                        // IF Rec."Back Page Picture".IMPORT('*.BMP', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("First Receipt Mail Picture")
                {
                    Caption = 'First Receipt Mail Picture';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PictureExists := Rec."Welcome Customer Letter".HASVALUE;
                        // IF Rec."Welcome Customer Letter".IMPORT('*.pdf', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                    end;
                }
            }

        }
    }

    var
        myInt: Integer;
        PictureExists: Boolean;
        Text001: Label 'ENU=Do you want to replace the existing picture?';
        Text002: Label 'ENU=Do you want to delete the picture?';

}