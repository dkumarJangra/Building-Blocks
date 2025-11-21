table 97751 "New Document Tracking"
{

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ',Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ';
            OptionMembers = ,Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Job No."; Code[20])
        {
        }
        field(6; "Job Description"; Text[50])
        {
        }
        field(7; "Document Code"; Code[20])
        {
            NotBlank = true;
        }
        field(8; "Document Description"; Text[100])
        {
        }
        field(9; Recieved; Boolean)
        {
            CalcFormula = Exist(Document WHERE("Table No." = CONST(50074),
                                                "Reference No. 1" = FIELD("Job No."),
                                                "Reference No. 2" = FIELD("Document Code")));
            FieldClass = FlowField;
        }
        field(10; Status; Code[20])
        {
            TableRelation = "Document Tracking status".Code;
        }
        field(50000; "Purchase Doc No."; Code[30])
        {
        }
        field(50001; "Sales Doc  No."; Code[30])
        {
        }
        field(50002; CC1; Text[50])
        {
        }
        field(50003; "CC1 Designation"; Text[50])
        {
            Caption = 'Designation';
        }
        field(50004; CC2; Text[50])
        {
        }
        field(50005; "CC2 Designation"; Text[50])
        {
            Caption = 'Designation';
        }
        field(50006; CC3; Text[50])
        {
        }
        field(50007; "CC3 Designation"; Text[50])
        {
            Caption = 'Designation';
        }
        field(50008; CC4; Text[50])
        {
        }
        field(50009; "CC4 Designation"; Text[50])
        {
            Caption = 'Designation';
        }
        field(50010; "Client Contact"; Text[50])
        {
        }
        field(50011; "Client Contact Designation"; Text[50])
        {
            Caption = 'Designation';
        }
        field(50012; Subject; Text[80])
        {
            Caption = 'Transmittal Subject';
        }
        field(50013; "CC1 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
        }
        field(50014; "CC2 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
        }
        field(50015; "CC3 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
        }
        field(50016; "CC4 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
        }
        field(50017; "Transmittal Sender"; Code[20])
        {
            TableRelation = User."User Name";
        }
        field(50018; "Remarks : Enclosed"; Text[100])
        {
        }
        field(50019; "Remarks : Body"; Text[250])
        {
        }
        field(50020; Version; Integer)
        {
            Editable = false;
        }
        field(50021; "A/I"; Option)
        {
            OptionCaption = 'A,I';
            OptionMembers = A,I;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Line No.", "Document Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Job: Record Job;
        DocTrackingEntry: Record "New Document Tracking Log";
        EntryNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentTrackingLog: Record "New Document Tracking Log";
        VersionNo: Integer;
        DocumentTracking: Record "New Document Tracking";
        DocTrackstatus: Record "Document Tracking status";


    procedure CreateLog() EntryNo: Integer
    begin
        // ALLEAA Start
        IF Status <> '' THEN
            DocTrackstatus.GET("Table ID", Status);

        Job.GET("Document No.");

        IF DocTrackstatus."Generate Transmittal Nos" THEN BEGIN
            Job.TESTFIELD(Job."Transmittal No. Series");
            TESTFIELD(Subject);
            TESTFIELD("Client Contact");
            TESTFIELD("Client Contact Designation");
            TESTFIELD("Transmittal Sender");
            TESTFIELD("Remarks : Enclosed");
        END;

        IF DocTrackstatus."Update Versions" THEN BEGIN
            DocumentTrackingLog.RESET;
            DocumentTrackingLog.SETRANGE("Document No.", "Document No.");
            DocumentTrackingLog.SETRANGE("Document code", "Document Code");
            //DocumentTrackingLog.SETRANGE("Job No.","Job No.");
            //DocumentTrackingLog.SETRANGE("New Status",DocumentTrackingLog."New Status"::"Received from Vendor");
            IF DocumentTrackingLog.FINDLAST THEN
                VersionNo := DocumentTrackingLog.Version + 1;
        END;

        DocTrackingEntry.RESET;
        IF DocTrackingEntry.FINDLAST THEN
            EntryNo := DocTrackingEntry."Entry No." + 1
        ELSE
            EntryNo := 1;
        DocTrackingEntry.INIT;
        DocTrackingEntry."Entry No." := EntryNo;
        DocTrackingEntry."Job No." := "Job No.";
        DocTrackingEntry."Document No." := "Document No.";
        DocTrackingEntry."Document code" := "Document Code";
        DocTrackingEntry."User ID" := USERID;
        DocTrackingEntry."Date Changed" := WORKDATE;
        DocTrackingEntry."Previous status" := Status;
        DocTrackingEntry."Table ID" := "Table ID";
        DocTrackingEntry."Document Type" := "Document Type";
        DocTrackingEntry."Line No." := "Line No.";

        // ALLEAA Start
        DocTrackingEntry."Purchase Doc No." := "Purchase Doc No.";
        DocTrackingEntry."Sales Doc No." := "Sales Doc  No.";
        DocTrackingEntry."Document Description" := "Document Description";
        IF DocTrackstatus."Generate Transmittal Nos" THEN BEGIN
            DocTrackingEntry."Transmittal No." := NoSeriesMgt.GetNextNo(Job."Transmittal No. Series", WORKDATE, TRUE);
            DocTrackingEntry."Transmittal Date" := WORKDATE;
            DocTrackingEntry.CC1 := CC1;
            DocTrackingEntry."CC1 Designation" := "CC1 Designation";
            DocTrackingEntry.CC2 := CC2;
            DocTrackingEntry."CC2 Designation" := "CC2 Designation";
            DocTrackingEntry.CC3 := CC3;
            DocTrackingEntry."CC3 Designation" := "CC3 Designation";
            DocTrackingEntry.CC4 := CC4;
            DocTrackingEntry."CC4 Designation" := "CC4 Designation";
            DocTrackingEntry."Client Contact" := "Client Contact";
            DocTrackingEntry."Client Contact Designation" := "Client Contact Designation";
            DocTrackingEntry."CC1 Only Transmittal" := "CC1 Only Transmittal";
            DocTrackingEntry."CC2 Only Transmittal" := "CC2 Only Transmittal";
            DocTrackingEntry."CC3 Only Transmittal" := "CC3 Only Transmittal";
            DocTrackingEntry."CC4 Only Transmittal" := "CC4 Only Transmittal";
            DocTrackingEntry."Transmittal Sender" := "Transmittal Sender";
            DocTrackingEntry."Remarks : Enclosed" := "Remarks : Enclosed";
            DocTrackingEntry."Remarks : Body" := "Remarks : Body";
            DocTrackingEntry."A/I" := "A/I";
            DocTrackingEntry.Subject := Subject;
        END;


        IF VersionNo <> 0 THEN
            DocTrackingEntry.Version := VersionNo
        ELSE
            DocTrackingEntry.Version := Version;
        DocTrackingEntry.INSERT;
    end;


    procedure ModifyLog(EntryNo: Integer)
    begin
        DocTrackingEntry.GET(EntryNo);
        DocTrackingEntry."New status" := Status;
        DocTrackingEntry.MODIFY;

        DocumentTracking.RESET;
        DocumentTracking.SETRANGE("Job No.", DocTrackingEntry."Job No.");
        DocumentTracking.SETRANGE("Document No.", DocTrackingEntry."Document No.");
        DocumentTracking.SETRANGE("Document Code", DocTrackingEntry."Document code");
        IF DocumentTracking.FINDFIRST THEN BEGIN
            DocumentTracking.Version := DocTrackingEntry.Version;
            DocumentTracking.MODIFY;
        END;
    end;


    procedure ShowDocument()
    var
        NewDocTrack: Record "New Document Tracking";
        NewDocTrackFrm: Page "New Document Trackings";
    begin
        NewDocTrack.SETRANGE("Table ID", DATABASE::"Sales Header");
        NewDocTrack.SETRANGE("Document Type", "Document Type");
        NewDocTrack.SETRANGE("Document No.", "Document No.");
        NewDocTrack.SETRANGE("Line No.", 0);
        NewDocTrackFrm.SETTABLEVIEW(NewDocTrack);
        NewDocTrackFrm.RUNMODAL;
        //GET("Document Type","Document No.");
    end;
}

