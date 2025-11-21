table 97740 "Document Tracking"
{
    // KLND1.00 ALLEPG 190510 : Created new table.


    fields
    {
        field(1; "Job No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF Job.GET("Job No.") THEN BEGIN
                    "Job Description" := Job.Description;
                    CC1 := Job.CC1;
                    "CC1 Designation" := Job."CC1 Designation";
                    CC2 := Job.CC2;
                    "CC2 Designation" := Job."CC2 Designation";
                    CC3 := Job.CC3;
                    "CC3 Designation" := Job."CC3 Designation";
                    CC4 := Job.CC4;
                    "CC4 Designation" := Job."CC4 Designation";
                    "Client Contact" := Job."Client Contact";
                    "Client Contact Designation" := Job."Client Contact Designation";
                    "CC1 Only Transmittal" := Job."CC1 Only Transmittal";
                    "CC2 Only Transmittal" := Job."CC2 Only Transmittal";
                    "CC3 Only Transmittal" := Job."CC3 Only Transmittal";
                    "CC4 Only Transmittal" := Job."CC4 Only Transmittal";
                    "Transmittal Sender" := USERID;
                    Subject := Job.Subject;
                END ELSE BEGIN
                    "Job Description" := '';
                    CC1 := '';
                    "CC1 Designation" := '';
                    CC2 := '';
                    "CC2 Designation" := '';
                    CC3 := '';
                    "CC3 Designation" := '';
                    CC4 := '';
                    "CC4 Designation" := '';
                    "Client Contact" := '';
                    "Client Contact Designation" := '';
                    "CC1 Only Transmittal" := FALSE;
                    "CC2 Only Transmittal" := FALSE;
                    "CC3 Only Transmittal" := FALSE;
                    "CC4 Only Transmittal" := FALSE;
                    "Transmittal Sender" := '';
                    Subject := '';
                END;
            end;
        }
        field(2; "Job Description"; Text[50])
        {
        }
        field(3; "Document Code"; Code[20])
        {
            NotBlank = true;
        }
        field(4; "Document Description"; Text[100])
        {
        }
        field(5; Recieved; Boolean)
        {
            CalcFormula = Exist(Document WHERE("Table No." = CONST(50074),
                                                "Reference No. 1" = FIELD("Job No."),
                                                "Reference No. 2" = FIELD("Document Code")));
            FieldClass = FlowField;
        }
        field(6; Status; Option)
        {
            OptionCaption = ' ,Received from Vendor,Forwarded to Customer,Returned by Customer,Return to Vendor,Approved,Forwarded to Dept,Recieved From Dept,Released to Site';
            OptionMembers = " ","Received from Vendor","Forwarded to Customer","Returned by Customer","Return to Vendor",Approved,"Forwarded to Dept","Recieved From Dept","Released to Site";
        }
        field(50000; "Vendor Drawing No."; Code[30])
        {
            Description = 'ALLEAA';
        }
        field(50001; "Customer Drawing No."; Code[30])
        {
            Description = 'ALLEAA';
        }
        field(50002; CC1; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50003; "CC1 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'ALLEAA';
        }
        field(50004; CC2; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50005; "CC2 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'ALLEAA';
        }
        field(50006; CC3; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50007; "CC3 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'ALLEAA';
        }
        field(50008; CC4; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50009; "CC4 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'ALLEAA';
        }
        field(50010; "Client Contact"; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50011; "Client Contact Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'ALLEAA';
        }
        field(50012; Subject; Text[80])
        {
            Caption = 'Transmittal Subject';
            Description = 'ALLEAA';
        }
        field(50013; "CC1 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50014; "CC2 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50015; "CC3 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50016; "CC4 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50017; "Transmittal Sender"; Code[20])
        {
            Description = 'ALLEAA';
            TableRelation = User."User Name";
        }
        field(50018; "Remarks : Enclosed"; Text[100])
        {
            Description = 'ALLEAA';
        }
        field(50019; "Remarks : Body"; Text[250])
        {
            Description = 'ALLEAA';
        }
        field(50020; Version; Integer)
        {
            Description = 'ALLEAA';
            Editable = false;
        }
        field(50021; "A/I"; Option)
        {
            Description = 'ALLEAA';
            OptionCaption = 'A,I';
            OptionMembers = A,I;
        }
    }

    keys
    {
        key(Key1; "Job No.", "Document Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Job: Record Job;
        DocTrackingEntry: Record "Document Tracking Log";
        EntryNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentTrackingLog: Record "Document Tracking Log";
        VersionNo: Integer;
        DocumentTracking: Record "Document Tracking";


    procedure CreateLog(CurrentStatus: Option " ","Received from Vendor","Forwarded to Customer","Returned by Customer","Return to Vendor",Approved,"Forwarded to Dept","Recieved From Dept") EntryNo: Integer
    begin
        // ALLEAA Start
        IF CurrentStatus = CurrentStatus::"Forwarded to Customer" THEN BEGIN
            Job.GET("Job No.");
            Job.TESTFIELD(Job."Transmittal No. Series");
            TESTFIELD(Subject);
            TESTFIELD("Client Contact");
            TESTFIELD("Client Contact Designation");
            TESTFIELD("Transmittal Sender");
            TESTFIELD("Remarks : Enclosed");
        END;
        // ALLEAA End

        IF CurrentStatus = CurrentStatus::"Received from Vendor" THEN BEGIN
            DocumentTrackingLog.RESET;
            DocumentTrackingLog.SETRANGE("Document No.", "Document Code");
            DocumentTrackingLog.SETRANGE("Job No.", "Job No.");
            DocumentTrackingLog.SETRANGE("New Status", DocumentTrackingLog."New Status"::"Received from Vendor");
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
        DocTrackingEntry."Document No." := "Document Code";
        DocTrackingEntry."User ID" := USERID;
        DocTrackingEntry."Date Changed" := WORKDATE;
        DocTrackingEntry."Previous Status" := Status;

        // ALLEAA Start
        DocTrackingEntry."Vendor Drawing No." := "Vendor Drawing No.";
        DocTrackingEntry."Customer Drawing No." := "Customer Drawing No.";
        DocTrackingEntry."Document Description" := "Document Description";
        IF CurrentStatus = CurrentStatus::"Forwarded to Customer" THEN BEGIN
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
        // ALLEAA  End
    end;


    procedure ModifyLog(EntryNo: Integer)
    begin
        DocTrackingEntry.GET(EntryNo);
        DocTrackingEntry."New Status" := Status;
        DocTrackingEntry.MODIFY;

        DocumentTracking.RESET;
        DocumentTracking.SETRANGE("Job No.", DocTrackingEntry."Job No.");
        DocumentTracking.SETRANGE("Document Code", DocTrackingEntry."Document No.");
        IF DocumentTracking.FINDFIRST THEN BEGIN
            DocumentTracking.Version := DocTrackingEntry.Version;
            DocumentTracking.MODIFY;
        END;
    end;
}

