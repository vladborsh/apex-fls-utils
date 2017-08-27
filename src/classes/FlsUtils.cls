/**
 * @author Borsh Vlad  vlad.borsh@synebo.io
 * Current class designed for checking Field-Level-Security permissions before CRUD operations.
 */
public with sharing class FlsUtils {

  private static String prefix = '';


  public static Boolean isAccessible( String sobjectName, List<String> fields ) {
    setNameSpacePrefix();
    String[] sObjectNames = new String[] { applyPrefixToObject(sobjectName) };
    Schema.DescribeSObjectResult[] dResult = Schema.describeSObjects(sObjectNames);
    if ( dResult[0].isAccessible() ) {
      Map<String,Schema.SObjectField> fieldMap = dResult[0].fields.getMap();
      for ( String fieldToCheck : fields ) {
        if ( !fieldMap.get( applyPrefixToField( dResult[0], fieldToCheck ) ).getDescribe().isAccessible()) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }


  public static Boolean isCreateable( sObject sObj, List<String> fields ) {
    setNameSpacePrefix();
    Schema.DescribeSObjectResult describeResult = sObj.getSObjectType().getDescribe();
    if ( describeResult.isCreateable() ) {
      Map<String,Schema.SObjectField> fieldMap = describeResult.fields.getMap();
      for ( String fieldToCheck : fields ) {
        if ( !fieldMap.get( applyPrefixToField( describeResult, fieldToCheck ) ).getDescribe().isCreateable()) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }


  public static Boolean isUpdateable( sObject sObj, List<String> fields ) {
    setNameSpacePrefix();
    Schema.DescribeSObjectResult describeResult = sObj.getSObjectType().getDescribe();
    if ( describeResult.isUpdateable() ) {
      Map<String,Schema.SObjectField> fieldMap = describeResult.fields.getMap();
      for ( String fieldToCheck : fields ) {
        if ( !fieldMap.get(  applyPrefixToField( describeResult, fieldToCheck )  ).getDescribe().isUpdateable()) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }


  public static Boolean isDeletable( sObject sObj ) {
    setNameSpacePrefix();
    Schema.DescribeSObjectResult describeResult = sObj.getSObjectType().getDescribe();
    if (describeResult.isDeletable()) {
      return true;
    } else {
      return false;
    }
  }


  private static void setNameSpacePrefix() {
    ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'FlsUtils'];
    prefix = ac.NameSpacePrefix + '__';
  }


  private static String applyPrefixToObject( String sObjectName ) {
    Set<string> standardObjectSet = new Set<string>();
    for ( Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
      String name = objTyp.getDescribe().getName();
       // Exclude all the unwanted Sobjects e.g. History, Share etc..
      if( !name.containsignorecase('history') 
        && !name.containsignorecase('tag')
        && !name.containsignorecase('share') 
        && !name.containsignorecase('feed')
      ) {      
          standardObjectSet.add(name);
      }
    }
    return ( standardObjectSet.contains(sObjectName) ) ? sObjectName : prefix + sObjectName;
  }


  private static String applyPrefixToField( DescribeSObjectResult sObjectDescribe, String fieldName ) {
    setNameSpacePrefix();
    Map<String,Schema.SObjectField> fieldMap = sObjectDescribe.fields.getMap();
    Set<String> standardFieldSet = new Set<String> ();
    for ( String field : fieldMap.keySet() ) {
      DescribeFieldResult dField = fieldMap.get( field ).getDescribe();
      if ( dField.getName().equals( dField.getLocalName() )) {
        standardFieldSet.add( dField.getName() );
      }
    }
    return ( standardFieldSet.contains(fieldName) ) ? fieldName : prefix + fieldName;
  }


}