Feature: Generated Scenarios

# Agent: GenerateAgent
# Message Type: PACS.008
Feature: Processing inbound PACS.008 FIToFICustomerCreditTransfer messages

Scenario: Successfully process a valid PACS.008 message
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be accepted
And a settlement entry should be created for amount "<Amount>" "<Currency>"

Scenario: Reject PACS.008 when DebtorAccount is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>"
And DebtorAccount is missing
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing DebtorAccount"

# Agent: EnhanceAgent
# Message Type: PACS.008
Feature: Processing inbound PACS.008 FIToFICustomerCreditTransfer messages

Scenario: Successfully process a valid PACS.008 message
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be accepted
And a settlement entry should be created for amount "<Amount>" "<Currency>"

Scenario: Reject PACS.008 when DebtorAccount is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>"
And DebtorAccount is missing
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing DebtorAccount"

Scenario: Reject PACS.008 when EndToEndIdentification is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification missing
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing EndToEndIdentification"

Scenario: Reject PACS.008 when DebtorAccount format is invalid
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "INVALIDIBAN" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Invalid DebtorAccount format"

Scenario: Reject PACS.008 when InstructedAmount is zero or negative
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "0" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Invalid InstructedAmount"

Scenario: Reject PACS.008 when Currency is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing Currency"

Scenario: Successfully process a valid PACS.008 message with missing DebtorAgent and CreditorAgent
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be accepted
And a settlement entry should be created for amount "<Amount>" "<Currency>"

Scenario: Reject PACS.008 when RemittanceInformation is too long
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfoLong>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "RemittanceInformation too long"

# Agent: ReviewAgent
# Message Type: PACS.008
Feature: Processing inbound PACS.008 FIToFICustomerCreditTransfer messages

Scenario: Successfully process a valid PACS.008 message
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be accepted
And a settlement entry should be created for amount "<Amount>" "<Currency>"

Scenario: Reject PACS.008 when DebtorAccount is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>"
And DebtorAccount is missing
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing DebtorAccount"

Scenario: Reject PACS.008 when EndToEndIdentification is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification missing
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing EndToEndIdentification"

Scenario: Reject PACS.008 when DebtorAccount format is invalid
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "INVALIDIBAN" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Invalid DebtorAccount format"

Scenario: Reject PACS.008 when InstructedAmount is zero or negative
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "0" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Invalid InstructedAmount"

Scenario: Reject PACS.008 when Currency is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing Currency"

Scenario: Successfully process a valid PACS.008 message with missing DebtorAgent and CreditorAgent
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be accepted
And a settlement entry should be created for amount "<Amount>" "<Currency>"

Scenario: Reject PACS.008 when RemittanceInformation is too long
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfoLong>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "RemittanceInformation too long"

# Agent: ExportAgent
# Message Type: PACS.008
Feature: Processing inbound PACS.008 FIToFICustomerCreditTransfer messages

Scenario: Successfully process a valid PACS.008 message
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be accepted
And a settlement entry should be created for amount "<Amount>" "<Currency>"

Scenario: Reject PACS.008 when DebtorAccount is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>"
And DebtorAccount is missing
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing DebtorAccount"

Scenario: Reject PACS.008 when EndToEndIdentification is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification missing
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing EndToEndIdentification"

Scenario: Reject PACS.008 when DebtorAccount format is invalid
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "INVALIDIBAN" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Invalid DebtorAccount format"

Scenario: Reject PACS.008 when InstructedAmount is zero or negative
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "0" "<Currency>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Invalid InstructedAmount"

Scenario: Reject PACS.008 when Currency is missing
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "Missing Currency"

Scenario: Successfully process a valid PACS.008 message with missing DebtorAgent and CreditorAgent
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfo>"
When the message is processed by the system
Then the message should be accepted
And a settlement entry should be created for amount "<Amount>" "<Currency>"

Scenario: Reject PACS.008 when RemittanceInformation is too long
Given a PACS.008 message of type "FIToFICustomerCreditTransfer" with EndToEndIdentification "<E2EID>"
And Debtor "<DebtorName>" with Account "<DebtorIBAN>" and DebtorAgent "<DebtorAgentBIC>"
And Creditor "<CreditorName>" with Account "<CreditorIBAN>" and CreditorAgent "<CreditorAgentBIC>"
And InstructedAmount "<Amount>" "<Currency>"
And RemittanceInformation "<RemittanceInfoLong>"
When the message is processed by the system
Then the message should be rejected
And the rejection reason should be "RemittanceInformation too long"

