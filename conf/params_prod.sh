# Stack parameter
export ORG_ACCOUNT_ID='$2' # ID for Organization Management account 
export ORG_ROLE=OrganizationsReadOnlyAccess
export AWS_REGION=eu-west-1
export EXTERNAL_ID='' #Optional 
export JIRA_DEFAULT_ASSIGNEE='6284541246f77e006f21c5e4' #ID for default assignee for all Security Issues
export JIRA_INSTANCE="$3" #HTTPS address for JIRA server (exclude schema "https://")
export JIRA_PROJECT_KEY="$4" # JIRA Project Key
export ISSUE_TYPE="Security-Bug" #JIRA Issuetype name: Example, "Bug", "Security Issue"
export REGIONS=("us-east-2") # List of regions deployed
export SECURITY_CONTACT=("jira@sdohnahue.et")

PARAMETERS=(
  "OrganizationManagementAccountId=$ORG_ACCOUNT_ID"
  "JIRADefaultAssignee=$JIRA_DEFAULT_ASSIGNEE"
  "OrganizationAccessExternalId=$EXTERNAL_ID"
  "AutomatedChecks=$AUTOMATED_CHECKS"
  "JIRAInstance=$JIRA_INSTANCE"
  "JIRAIssueType"="$ISSUE_TYPE"
  "JIRAProjectKey"="$JIRA_PROJECT_KEY"
  "SecurityContact"="$SECURITY_CONTACT"
)



