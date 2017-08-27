@isTest
private class FlsUtilsTest {

  @testSetup
  static void setupData() {
    Account acc = new Account(
      Name = 'Jhon',
      Phone = '21341243'
    );
    insert acc;
  }
  
  @isTest 
  static void testAccess() {
    Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Jhon'];
    System.assertEquals(true, FlsUtils.isAccessible('Account', new List<String>{'Name', 'Phone'}));
    System.assertEquals(true, FlsUtils.isUpdateable(acc, new List<String>{'Name', 'Phone'}));
    System.assertNotEquals(true, FlsUtils.isUpdateable(acc, new List<String>{'createddate'}));
    System.assertEquals(true, FlsUtils.isCreateable(acc, new List<String>{'Name', 'Phone'}));
    System.assertNotEquals(true, FlsUtils.isCreateable(acc, new List<String>{'id'}));
    System.assertEquals(true, FlsUtils.isDeletable(acc));
  }
  
}