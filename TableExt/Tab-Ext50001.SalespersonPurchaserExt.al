tableextension 50001 "BBG Salesperson/Purchaser Ext" extends "Salesperson/Purchaser"
{
    fields
    {
        // Add changes to table fields here
        field(51279; "BBG Default Attach. Doc. Directory"; Text[250])
        {
            Caption = 'Default Attachment Document Directory';
            DataClassification = ToBeClassified;
        }
        field(51281; "BBG Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = ToBeClassified;
            TableRelation = Language;
        }
        field(51282; "BBG Navision User ID"; Code[20])
        {
            Caption = 'Navision User ID';
            DataClassification = ToBeClassified;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
                Salesperson: Record "Salesperson/Purchaser";
            begin
                // // WKF50004.S
                // IF LoginMgt.LookupUserID(Salesperson."Navision User ID") THEN
                //  VALIDATE("Navision User ID",Salesperson."Navision User ID");
                // // WKF50004.E
            end;

            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                // WKF50004.S
                //LoginMgt.ValidateUserID("Navision User ID");

                IF ("BBG Navision User ID" <> '') THEN BEGIN
                    Salesperson.SETRANGE(Salesperson."BBG Navision User ID", "BBG Navision User ID");
                    IF Salesperson.FINDFIRST THEN BEGIN
                        "BBG Navision User ID" := '';
                        ERROR(Text5128101, FIELDCAPTION("BBG Navision User ID"), Salesperson."BBG Navision User ID");
                    END;
                END;
                MODIFY(TRUE);
                // WKF50004.E
            end;
        }
        field(51283; "BBG Notify about Team To-do Chgs."; Boolean)
        {
            Caption = 'Notify about Team To-do Chgs.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // WKF50004.S
                IF ("BBG Notify about Team To-do Chgs." = TRUE) AND ("E-Mail" = '') THEN
                    ERROR(Text5128102)
                // WKF50004.e
            end;
        }
        field(51284; "BBG Automatic Status Level"; Boolean)
        {
            Caption = 'Automatic Status Level on start';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        Text5128101: Label 'DEU=%1 %2 ist bereits vergeben.;ENU=%1 %2 already in use.;ESP=%1 %2 ya est  en uso.;NLD=%1 %2 is reeds in gebruik';
        Text5128102: Label 'DEU=Damit der aktuelle Verk„ufer Benachrichtigungen empfangen kann, mssen Sie eine E-Mail-Adresse angeben.;ENU=You must provide an e-mail address for the current salesperson to be able to receive notifications.;ESP=Debe facilitar una direcci¢n de correo electr¢nico para notificar al vendedor.;NLD=U moet een e-mailadres opgeven voor deze contactpersoon om berichten te kunnen ontvangen';
}