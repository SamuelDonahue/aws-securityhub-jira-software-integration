
# AWS Security Hub and Jira Integration

This solution supports a bidirectional integration between AWS Security Hub and Jira. Using this solution, you can automatically and manually create and update JIRA tickets from Security Hub findings. 
Security teams can use this integration to notify developer teams of severe security findings that require action. 

The solution allows you to:

- Select which Security Hub controls automatically create or update tickets in Jira.
- In the Security Hub console, use Security Hub custom actions to manually escalate tickets in Jira.
- Automatically assign tickets in Jira based on the AWS account tags defined in AWS Organizations. If this tag is not defined, a default assignee is used.
- Automatically suppress Security Hub findings that are marked as false positive or accepted risk in Jira.
- Automatically close a Jira ticket when its related finding is archived in Security Hub.
- Reopen Jira tickets when Security Hub findings reoccur.

## Configure Jira
### Setup the workflow
Jira cloud does not support importing xml workflows you can import workflows uploaded to the market place see instructions [here](https://developer.atlassian.com/platform/marketplace/knowledge-base/how-do-i-import-a-workflow-into-a-jira-cloud-instance/)
if you are uploading to market place you can find the workflwo under /asset/security-hub-workflow.jwb. you can also manually setup the work flow using the resurces under `/asset`. jira workfows are found in `settings/issues/workflow`

## Set up the solution parameters
### Configure the solution parameters.
1. In the conf folder, open params_prod.shfile.
2. Provide values for the following parameters:
    * ORG_ACCOUNT_ID – The account ID for your AWS account. The solution can reads account tags and assigns tickets to the specific security contacts defined in those AWS account tags. Note: this feature was disabled in favor of providing security_contact.
    * ORG_ROLE – The name of the IAM role used to access the AWS Organization management account. This role must have OrganizationsReadOnlyAccess permissions. note: this can be blank if you are not using an AWS orgnization.
    * EXTERNAL_ID – An optional parameter if you are using an external ID to assume the IAM role defined in ORG_ROLE. For more information, see How to use an external ID (IAM documentation).
    * JIRA_DEFAULT_ASSIGNEE – This is the Jira ID for default assignee for all Security Issues. This default assigned is used in case account is not tagged properly or role cannot be assumed.
    * JIRA_INSTANCE – The HTTPS address for your Jira server in the following format: team-<team-id>.atlassian.net/
    * JIRA_PROJECT_KEY – The name of the Jira project key used to create tickets, such as SEC or TEST. This project must already exist in Jira. 
    * ISSUE_TYPE –  The name of the issue type scheme assigned to the project in Jira, such as Bug or Security Issue.
    * REGIONS – List of AWS Region codes where you want to deploy this solution, such as eu-west-1.
    * SECURITY_CONTACT - The security contact to assign tickets

Save and close the solution parameter file.

### Identify the findings you want to automate.
1. Open the Security Hub console at https://console.aws.amazon.com/securityhub/
2. In the Security Hub navigation pane, choose Findings.
2. Choose the finding title.
3. Choose the finding ID. This displays the complete JSON for the finding.
4. In the JSON, copy the string in the GeneratorId field. This value is in AWS Security Finding Format (ASFF). For example, aws-foundational-security-best-practices/v/1.0.0/S3.1 corresponds to findings from the security control S3.1 S3 Block Public Access setting should be enabled.
5. Repeat these steps until you have copied all of the GeneratorID values for any findings you want to automate.

### Add the findings to the configuration file.
1. In src/code, open the config.jsonconfig file.
2. Paste the GeneratorID values you retrieved in the previous story into the default parameter, and use commas to separate each ID.
3. Save and close the configuration file.

The following code example shows automating the aws-foundational-security-best-practices/v/1.0.0/SNS.1 and aws-foundational-security-best-practices/v/1.0.0/S3.1 findings.
```
{
    "Controls" : {
        "eu-central-1": [
        "security-control/S3.5",
         "security-control/EFS.6",
         "security-control/EC2.15",
         "security-control/ECS.1",
         "security-control/EC2.25"
     ],
        "default": [
aws-foundational-security-best-practices/v/1.0.0/SNS.1,
aws-foundational-security-best-practices/v/1.0.0/S3.1
     ]
    } 
 }
```
## Deploy the integration
### Deploy the integration.
In a command line terminal, enter the following command:
```
./deploy.sh prod <ORG_ACCOUNT_ID> <JIRA_INSTANCE> <JIRA_PROJECT_KEY>
./deploy.sh prod 383439373719 elisha-donahue.atlassian.net/ SUP
```
### Upload Jira credentials to AWS Secrets Manager.
1. Open the Secrets Manager console at https://console.aws.amazon.com/secretsmanager/.
2. Under Secrets, select JiraAPIToken-prod
3. Choose Store a new secret.
4. For Secret type, choose Other type of secret.
5. If you are using Jira Cloud, for Key/value pairs, do the following:
    * In the first row, enter auth in the key box, and then enter basic_auth in the value box.
    * Add a second row, enter token in the key box, and then enter your API token in the value box.
    * Add a third row, enter email in the key box, and then enter your email address in the value box.
6. Choose Next.
7. On the Secret rotation page, keep Disable automatic rotation, and then at the bottom of the page, choose Next.
8. On the Review page, review the secret details, and then choose Store.

### Create the Security Hub custom action.
1. For each AWS Region, in the AWS Command Line Interface (AWS CLI), use the create-action-target command to create a Security Hub custom action named CreateJiraIssue.
```
aws securityhub create-action-target --name "CreateJiraIssue" \
 --description "Create ticket in JIRA" \
 --id "CreateJiraIssue"
--region $<aws-region>
```
2. Open the Security Hub console at https://console.aws.amazon.com/securityhub/.
3. In the Security Hub navigation pane, choose Findings.
4. In the list of findings, select the findings you want to escalate.
5. In the Actions menu, choose CreateJiraIssue.

## Related Resources:
For the architecture diagram, prerequisites, and instructions for using this AWS Prescriptive Guidance pattern, see [Bidirectionally integrate AWS Security Hub with Jira software](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/bidirectionally-integrate-aws-security-hub-with-jira-software.html).