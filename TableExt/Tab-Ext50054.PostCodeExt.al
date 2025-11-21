tableextension 50054 "BBG Post Code Ext" extends "Post Code"
{
    fields
    {
        // Add changes to table fields here
        modify(Code)
        {
            trigger OnBeforeValidate()
            begin
                IF STRLEN(Code) > 6 THEN  //ALLEDK 100821
                    ERROR('Code can not be greater than 6 Digits');   //ALLEDK 100821

            end;
        }
        field(50000; NO; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
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

    PROCEDURE LookUpCity(VAR City: Text[30]; VAR PostCode: Code[20]; ReturnValues: Boolean);
    VAR
        PostCodeRec: Record "Post Code";
    BEGIN
        IF NOT GUIALLOWED THEN
            EXIT;
        PostCodeRec.SETCURRENTKEY(City, Code);
        PostCodeRec.Code := PostCode;
        PostCodeRec.City := City;
        IF (PAGE.RUNMODAL(PAGE::"Post Codes", PostCodeRec, PostCodeRec.City) = ACTION::LookupOK) AND ReturnValues THEN BEGIN
            PostCode := PostCodeRec.Code;
            City := PostCodeRec.City;
        END;
    END;

    PROCEDURE LookUpPostCode(VAR City: Text[30]; VAR PostCode: Code[20]; ReturnValues: Boolean);
    VAR
        PostCodeRec: Record "Post Code";
    BEGIN
        IF NOT GUIALLOWED THEN
            EXIT;
        PostCodeRec.SETCURRENTKEY(Code, City);
        PostCodeRec.Code := PostCode;
        PostCodeRec.City := City;
        IF (PAGE.RUNMODAL(PAGE::"Post Codes", PostCodeRec, PostCodeRec.Code) = ACTION::LookupOK) AND ReturnValues THEN BEGIN
            PostCode := PostCodeRec.Code;
            City := PostCodeRec.City;
        END;
    END;
}