Feature: Generated Scenarios

# Agent: GenerateAgent
# Message Type: PACS.008
Feature: Processing of PACS.008 FIToFIC Payment Initiation messages
Scenario Outline: Successful processing of PACS.008 with required fields
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
And the DebtorAgent is "<DebtorAgent>"
And the DebtorName is "<DebtorName>"
And the Instructed Amount is "<Amount>"
And the Currency is "<Currency>"
And the Creditor is "<Creditor>"
And the CreditorAccount is "<CreditorAccount>"
And the EndToEndIdentification is "<EndToEndIdentification>"
And the Remittance Information is "<RemittanceInformation>"
When the message is validated and processed
Then the message is accepted
And a corresponding internal payment instruction is created
And a status update message is generated with status "<Status>"
Examples:
| MessageIdentification | Debtor   | DebtorAccount              | DebtorAgent | DebtorName | Amount  | Currency | Creditor  | CreditorAccount                 | EndToEndIdentification | RemittanceInformation | Status   |
| MSG-001               | John Doe | DE89370400440532013000  | BICTEST     | John Doe   | 1000.00 | USD      | Acme Corp | DE12500105170648489890        | E2E-001               | Invoice 12345          | ACCEPTED |
Scenario Outline: Rejection when a mandatory field is missing
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
When the message is validated
Then the message should be rejected with error code "MandatoryFieldMissing"
And no internal payment instruction should be created
And no status update should be sent
And the missing field reported is "<MissingField>"
Examples:
| MessageIdentification | Debtor   | DebtorAccount | MissingField    |
| MSG-002               | Jane Doe |              | DebtorAccount |

# Agent: EnhanceAgent
# Message Type: PACS.008
Feature: Processing of PACS.008 FIToFIC Payment Initiation messages

Scenario: Successful processing of PACS.008 with full data
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-001"
And the Debtor is "John Doe"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorAgent is "BICTEST"
And the DebtorName is "John Doe"
And the Instructed Amount is "1000.00"
And the Currency is "USD"
And the Creditor is "Acme Corp"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-001"
And the Remittance Information is "Invoice 12345"
When the message is validated and processed
Then the message is accepted
And a corresponding internal payment instruction is created
And a status update message is generated with status "ACCEPTED"
Scenario Outline: Rejection when a mandatory field is missing
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
And the DebtorName is "<DebtorName>"
And the EndToEndIdentification is "<EndToEndIdentification>"
And the Remittance Information is "<RemittanceInformation>"
When the message is validated
Then the message should be rejected with error code "MandatoryFieldMissing"
And no internal payment instruction should be created
And no status update should be sent
And the missing field reported is "<MissingField>"
Examples:
| MessageIdentification | Debtor   | DebtorAccount | DebtorName | EndToEndIdentification | RemittanceInformation | MissingField     |
| MSG-002               | Jane Doe |              | Jane Doe   | E2E-002               | Remit 1               | DebtorAccount     |
| MSG-003               | Alice S  | DE89370400440532013000 | Alice S |                  | Remittance 2          | EndToEndIdentification |
| MSG-004               | Bob Lee  | DE89370400440532013000 | Bob Lee   | E2E-003               |                       | RemittanceInformation |
Scenario Outline: Rejection when Instructed Amount is invalid
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
And the DebtorName is "<DebtorName>"
And the Instructed Amount is "<Amount>"
And the Currency is "<Currency>"
And the Creditor is "<Creditor>"
And the CreditorAccount is "<CreditorAccount>"
And the EndToEndIdentification is "<EndToEndIdentification>"
And the Remittance Information is "<RemittanceInformation>"
When the message is validated
Then the message should be rejected with error code "InvalidAmount"
And no internal payment instruction should be created
And no status update should be sent
And the failing amount reported is "<Amount>"
Examples:
| MessageIdentification | Debtor | DebtorAccount | DebtorName | Amount   | Currency | Creditor | CreditorAccount             | EndToEndIdentification | RemittanceInformation |
| MSG-005               | Jack   | DE89370400440532013000 | Jack      | -100.00  | USD      | Acme     | DE12500105170648489890 | E2E-005               | Invoice A1            |
| MSG-006               | Mary   | DE89370400440532013000 | Mary      | 0.00      | USD      | Acme     | DE12500105170648489890 | E2E-006               | Invoice A2            |

Scenario: Rejection due to invalid DebtorAccount IBAN format
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-007"
And the Debtor is "Invalid Debtor"
And the DebtorAccount is "INVALIDIBAN123"
And the DebtorName is "Invalid Debtor"
And the Instructed Amount is "50.00"
And the Currency is "USD"
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-007"
And the Remittance Information is "Ref"
When the message is validated
Then the message should be rejected with error code "InvalidDebtorAccount"
And no internal payment instruction should be created
And no status update should be sent
And the failing field reported is "DebtorAccount"

Scenario: Rejection due to missing Currency
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-008"
And the Debtor is "Someone"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorName is "Someone"
And the Instructed Amount is "100.00"
And the Currency is ""
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-008"
And the Remittance Information is "Remit"
When the message is validated
Then the message should be rejected with error code "MissingCurrency"
And no internal payment instruction should be created
And no status update should be sent
And the missing field reported is "Currency"

Scenario: Remittance Information length boundary check (too long)
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-009"
And the Debtor is "Boundary Tester"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorName is "Boundary Tester"
And the Instructed Amount is "500.00"
And the Currency is "USD"
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-009"
And the Remittance Information is "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
When the message is validated
Then the message should be rejected with error code "RemittanceInfoTooLong"
And no internal payment instruction should be created
And no status update should be sent
And the reported field is "RemittanceInformation"

# Agent: ReviewAgent
# Message Type: PACS.008
Feature: Processing of PACS.008 FIToFIC Payment Initiation messages

Scenario: Successful processing of PACS.008 with full data
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-001"
And the Debtor is "John Doe"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorAgent is "BICTEST"
And the DebtorName is "John Doe"
And the Instructed Amount is "1000.00"
And the Currency is "USD"
And the Creditor is "Acme Corp"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-001"
And the Remittance Information is "Invoice 12345"
When the message is validated and processed
Then the message is accepted
And a corresponding internal payment instruction is created
And a status update message is generated with status "ACCEPTED"
Scenario Outline: Rejection when a mandatory field is missing
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
And the DebtorName is "<DebtorName>"
And the EndToEndIdentification is "<EndToEndIdentification>"
And the Remittance Information is "<RemittanceInformation>"
When the message is validated
Then the message should be rejected with error code "MandatoryFieldMissing"
And no internal payment instruction should be created
And no status update should be sent
And the missing field reported is "<MissingField>"
Examples:
| MessageIdentification | Debtor   | DebtorAccount | DebtorName | EndToEndIdentification | RemittanceInformation | MissingField     |
| MSG-002               | Jane Doe |              | Jane Doe   | E2E-002               | Remittance 1           | DebtorAccount     |
| MSG-003               | Alice S  | DE89370400440532013000 | Alice S |                  | Remittance 2          | EndToEndIdentification |
| MSG-004               | Bob Lee  | DE89370400440532013000 | Bob Lee   | E2E-003               |                       | RemittanceInformation |
Scenario Outline: Rejection when Instructed Amount is invalid
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
And the DebtorName is "<DebtorName>"
And the Instructed Amount is "<Amount>"
And the Currency is "<Currency>"
And the Creditor is "<Creditor>"
And the CreditorAccount is "<CreditorAccount>"
And the EndToEndIdentification is "<EndToEndIdentification>"
And the Remittance Information is "<RemittanceInformation>"
When the message is validated
Then the message should be rejected with error code "InvalidAmount"
And no internal payment instruction should be created
And no status update should be sent
And the failing amount reported is "<Amount>"
Examples:
| MessageIdentification | Debtor | DebtorAccount | DebtorName | Amount   | Currency | Creditor | CreditorAccount             | EndToEndIdentification | RemittanceInformation |
| MSG-005               | Jack   | DE89370400440532013000 | Jack      | -100.00  | USD      | Acme     | DE12500105170648489890 | E2E-005               | Invoice A1            |
| MSG-006               | Mary   | DE89370400440532013000 | Mary      | 0.00      | USD      | Acme     | DE12500105170648489890 | E2E-006               | Invoice A2            |

Scenario: Rejection due to invalid DebtorAccount IBAN format
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-007"
And the Debtor is "Invalid Debtor"
And the DebtorAccount is "INVALIDIBAN123"
And the DebtorName is "Invalid Debtor"
And the Instructed Amount is "50.00"
And the Currency is "USD"
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-007"
And the Remittance Information is "Ref"
When the message is validated
Then the message should be rejected with error code "InvalidDebtorAccount"
And no internal payment instruction should be created
And no status update should be sent
And the failing field reported is "DebtorAccount"

Scenario: Rejection due to missing Currency
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-008"
And the Debtor is "Someone"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorName is "Someone"
And the Instructed Amount is "100.00"
And the Currency is ""
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-008"
And the Remittance Information is "Remit"
When the message is validated
Then the message should be rejected with error code "MissingCurrency"
And no internal payment instruction should be created
And no status update should be sent
And the missing field reported is "Currency"

Scenario: Remittance Information length boundary check (too long)
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-009"
And the Debtor is "Boundary Tester"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorName is "Boundary Tester"
And the Instructed Amount is "500.00"
And the Currency is "USD"
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-009"
And the Remittance Information is "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
When the message is validated
Then the message should be rejected with error code "RemittanceInfoTooLong"
And no internal payment instruction should be created
And no status update should be sent
And the reported field is "RemittanceInformation"

# Agent: ExportAgent
# Message Type: PACS.008
Feature: Processing of PACS.008 FIToFIC Payment Initiation messages

Scenario: Successful processing of PACS.008 with full data
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-001"
And the Debtor is "John Doe"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorAgent is "BICTEST"
And the DebtorName is "John Doe"
And the Instructed Amount is "1000.00"
And the Currency is "USD"
And the Creditor is "Acme Corp"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-001"
And the Remittance Information is "Invoice 12345"
When the message is validated and processed
Then the message is accepted
And a corresponding internal payment instruction is created
And a status update message is generated with status "ACCEPTED"
Scenario Outline: Rejection when a mandatory field is missing
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
And the DebtorName is "<DebtorName>"
And the EndToEndIdentification is "<EndToEndIdentification>"
And the Remittance Information is "<RemittanceInformation>"
When the message is validated
Then the message should be rejected with error code "MandatoryFieldMissing"
And no internal payment instruction should be created
And no status update should be sent
And the missing field reported is "<MissingField>"
Examples:
| MessageIdentification | Debtor   | DebtorAccount | DebtorName | EndToEndIdentification | RemittanceInformation | MissingField     |
| MSG-002               | Jane Doe |              | Jane Doe   | E2E-002               | Remittance 1           | DebtorAccount     |
| MSG-003               | Alice S  | DE89370400440532013000 | Alice S |                  | Remittance 2          | EndToEndIdentification |
| MSG-004               | Bob Lee  | DE89370400440532013000 | Bob Lee   | E2E-003               |                       | RemittanceInformation |
Scenario Outline: Rejection when Instructed Amount is invalid
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "<MessageIdentification>"
And the Debtor is "<Debtor>"
And the DebtorAccount is "<DebtorAccount>"
And the DebtorName is "<DebtorName>"
And the Instructed Amount is "<Amount>"
And the Currency is "<Currency>"
And the Creditor is "<Creditor>"
And the CreditorAccount is "<CreditorAccount>"
And the EndToEndIdentification is "<EndToEndIdentification>"
And the Remittance Information is "<RemittanceInformation>"
When the message is validated
Then the message should be rejected with error code "InvalidAmount"
And no internal payment instruction should be created
And no status update should be sent
And the failing amount reported is "<Amount>"
Examples:
| MessageIdentification | Debtor | DebtorAccount | DebtorName | Amount   | Currency | Creditor | CreditorAccount             | EndToEndIdentification | RemittanceInformation |
| MSG-005               | Jack   | DE89370400440532013000 | Jack      | -100.00  | USD      | Acme     | DE12500105170648489890 | E2E-005               | Invoice A1            |
| MSG-006               | Mary   | DE89370400440532013000 | Mary      | 0.00      | USD      | Acme     | DE12500105170648489890 | E2E-006               | Invoice A2            |

Scenario: Rejection due to invalid DebtorAccount IBAN format
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-007"
And the Debtor is "Invalid Debtor"
And the DebtorAccount is "INVALIDIBAN123"
And the DebtorName is "Invalid Debtor"
And the Instructed Amount is "50.00"
And the Currency is "USD"
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-007"
And the Remittance Information is "Ref"
When the message is validated
Then the message should be rejected with error code "InvalidDebtorAccount"
And no internal payment instruction should be created
And no status update should be sent
And the failing field reported is "DebtorAccount"

Scenario: Rejection due to missing Currency
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-008"
And the Debtor is "Someone"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorName is "Someone"
And the Instructed Amount is "100.00"
And the Currency is ""
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-008"
And the Remittance Information is "Remit"
When the message is validated
Then the message should be rejected with error code "MissingCurrency"
And no internal payment instruction should be created
And no status update should be sent
And the missing field reported is "Currency"

Scenario: Remittance Information length boundary check (too long)
Given a PACS.008 FIToFIC payment initiation message is received
And the Message Identification is "MSG-009"
And the Debtor is "Boundary Tester"
And the DebtorAccount is "DE89370400440532013000"
And the DebtorName is "Boundary Tester"
And the Instructed Amount is "500.00"
And the Currency is "USD"
And the Creditor is "Acme"
And the CreditorAccount is "DE12500105170648489890"
And the EndToEndIdentification is "E2E-009"
And the Remittance Information is "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
When the message is validated
Then the message should be rejected with error code "RemittanceInfoTooLong"
And no internal payment instruction should be created
And no status update should be sent
And the reported field is "RemittanceInformation"

