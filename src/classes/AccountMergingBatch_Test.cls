@isTest
private class AccountMergingBatch_Test
{
	@isTest static void testScheduleMethod()
	{
		Test.startTest();

		Integer count = [select Id from AsyncApexJob].size();

		AccountMergingBatch.scheduleHourly();

		System.assertEquals(count + 1, [select Id from AsyncApexJob].size());

		Test.stopTest();
	}

	@isTest static void testBatch()
	{
		Id rtID = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'PersonAccount' limit 1].Id;
		Account master = new Account(LastName = 'Master Account', RecordTypeId = rtID);
		insert master;

		insert new List<Account>
		{
			new Account(LastName = 'Child 1', RecordTypeId = rtId, Master__c = master.Id),
			new Account(LastName = 'Child 2', RecordTypeId = rtId, Master__c = master.Id),
			new Account(LastName = 'Child 3', RecordTypeId = rtId, Master__c = master.Id),
			new Account(LastName = 'Child 4', RecordTypeId = rtId, Master__c = master.Id)
		};

		Test.startTest();

		System.assertEquals(5, [select Id from Account].size());
		Database.executeBatch(new AccountMergingBatch());
		Test.stopTest();

		System.assertEquals(1, [select Id from Account].size());
	}
}