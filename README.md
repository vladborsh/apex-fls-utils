# Field Level Security Enforcement

Missing FLS enforcement is the frequent issue in managed packages.
Force.com allows developers and administrators to control access to data at many different levels. You can control access at the object-level, the record-level, and at the field-level. 
Larger applications usually benefit from the creation of centralized classes that provide abstractions and bundling of these functions based on the type of operations and functionality offered by the application.
The current repository contains FlsUtility class for providing a simple and convenient way to enforce object and field security. 

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Examples

A few next examples show how quick and eazy you can handle CRUD operation security

### Accessible

Check whether object and specified fields is readable

```java
API_request_log__c log = new API_request_log__c(
  Name = name,
  Uri__c = uri,
  Message__c = message
);
if ( !FlsUtils.isAccessible( log, new List<String>{'Name','Uri__c','Message__c'} ) ) {
  return;
}
/* Make stuff */
```

### Createable

Check whether object and specified fields is createable

```java
Account accountItem = [
  SELECT Id, Name, LinkedIn__c
  FROM Account 
  WHERE Name = 'Jhon'
];
if ( !FlsUtils.isCreateable( accountItem, new List<String>{'Name','LinkedIn__c'} ) ) {
  return;
}
/* Make stuff */
```

### Updateable

Check whether object and specified fields is updateable

```java
Account accountItem = [
  SELECT Id, Name, LinkedIn__c
  FROM Account 
  WHERE Name = 'Jhon'
];
if ( !FlsUtils.isUpdateable( accountItem, new List<String>{'Name','LinkedIn__c'} ) ) {
  return;
}
/* Make stuff */
```

### Deletable

Check whether object and specified fields is deletable

```java
Account accountItem = [
  SELECT Id, Name, LinkedIn__c
  FROM Account 
  WHERE Name = 'Jhon'
];
if ( !FlsUtils.isDeletable( accountItem ) ) {
  return;
}
/* Make stuff */
```